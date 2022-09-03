//
//  URLSessionManager.swift
//  CafuPlayground
//
//  Created by Ahmed Ramy on 24/08/2022.
//

import Foundation
import OrdiLogging
import OrdiPulseLogging

// MARK: - URLSessionManager

actor URLSessionManager: NetworkProtocol {
  // MARK: Lifecycle

  init() {
    session = URLSession(configuration: .default)
  }

  // MARK: Internal

  func call<T: Decodable, U: Endpoint>(api: U, model: T.Type) async throws -> T {
    let urlRequest = URLRequestFactory.generateRequest(outOf: api)
    do {
      return try await session.data(for: urlRequest, expects: model)
    } catch URLError.cancelled {
      throw NetworkError.cancelled
    } catch URLError.notConnectedToInternet, URLError.networkConnectionLost {
      throw NetworkError.unreachable
    } catch let error as DecodingError {
      throw NetworkError.decodingFailure(error)
    } catch {
      throw NetworkError.unknown(error)
    }
  }

  // MARK: Private

  private nonisolated let session: URLSession
}

extension URLSession {
  func data<T: Decodable>(
    for urlRequest: URLRequest,
    expects expectedType: T.Type,
    delegate: URLSessionTaskDelegate? = nil) async throws
    -> T
  {
    let (data, _) = try await data(for: urlRequest, delegate: delegate)
    return try EHJSONDecoder().decode(expectedType, from: data)
  }
}

// MARK: - URLRequestFactory

enum URLRequestFactory {
  // MARK: Internal

  /// Generates URLRequest after building the URL, injecting the method and the headers
  /// and encoding the Parameters suitably according to the endpoint
  /// - Parameter endpoint: the protocol that carries the details of the request
  /// - Returns: URLRequest for the manager to use
  static func generateRequest(outOf endpoint: Endpoint) -> URLRequest {
    let url = generateURL(outOf: endpoint)
    var urlRequest = URLRequest(url: url)

    urlRequest.httpMethod = endpoint.method.rawValue

    endpoint.headers.forEach { key, value in
      urlRequest.setValue(value, forHTTPHeaderField: key)
    }

    encodeRequestWithParameters(&urlRequest, from: endpoint)

    return urlRequest
  }

  // MARK: Private

  /// Generates URL out of endpoint protocol
  /// - Parameter endpoint: the protocol that carries the details of the request
  /// - Returns: the URL to be used to build the URLRequest
  private static func generateURL(outOf endpoint: Endpoint) -> URL {
    guard let url = URL(string: endpoint.baseURL + endpoint.path) else {
      // We used a fatalError here with a helpful message so that if we had a
      // typo in the path or the baseURL, this fatalError notifies us, Normally
      // i'd go for an assertionFailure so it doesn't crash the app in
      // production, but since am sure this won't happen in production but only
      // in development, so I don't see anything wrong with it
      fatalError("You probably passed a wrong URL,\n check \(endpoint.baseURL) or \(endpoint.path)")
    }
    return url
  }

  /// Encodes the parameters in the URL
  private static func encodeParametersInURL(in urlRequest: inout URLRequest, endpoint: Endpoint) {
    guard let url = urlRequest.url?.absoluteString else { return }
    guard var urlComponents = URLComponents(string: url) else { return }
    urlComponents.queryItems = endpoint.parameters.map { key, value in
      URLQueryItem(name: key, value: value as? String ?? "")
    }

    urlComponents.percentEncodedQuery = urlComponents.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")

    urlRequest.url = urlComponents.url
  }

  /// Encodes the parameters in the Request Body
  private static func encodeParametersInBodyOfRequest(in request: inout URLRequest, endpoint: Endpoint) {
    do {
      let data = try JSONSerialization.data(withJSONObject: endpoint.parameters, options: [])
      request.httpBody = data
    } catch {
      LoggersManager.error(message: "\(error)")
    }
  }

  /// Handles How the parameters will be encoded according to the endpoint encoding
  private static func encodeRequestWithParameters(_ request: inout URLRequest, from endpoint: Endpoint) {
    switch endpoint.encoding {
    case .urlEncoding:
      encodeParametersInURL(in: &request, endpoint: endpoint)
    case .jsonEncoding:
      encodeParametersInBodyOfRequest(in: &request, endpoint: endpoint)
    case .multipartEncoding:
      // TODO: - Add Multipart support
      break
    }
  }
}

// MARK: - EHJSONDecoder

class EHJSONDecoder: JSONDecoder {
  // MARK: Lifecycle

  override init() {
    super.init()
    keyDecodingStrategy = .convertFromSnakeCase
    dateDecodingStrategy = .custom({ try self.decodeDate(from: $0) })
  }

  // MARK: Internal

  func decodeDate(from decoder: Decoder) throws -> Date {
    let container = try decoder.singleValueContainer()
    let dateStr = try container.decode(String.self)
    guard let date = decodeDate(from: dateStr) else {
      throw DecodingError.dataCorruptedError(
        in: container,
        debugDescription: "ISO8601 date string \(dateStr)")
    }
    return date
  }

  func decodeDate(from dateStr: String) -> Date? {
    let formatOptions: [ISO8601DateFormatter.Options] = [
      .withInternetDateTime,
      .withFractionalSeconds,
    ]

    for option in formatOptions {
      let dateFormatter = ISO8601DateFormatter()
      dateFormatter.formatOptions.insert(option)
      guard let date = dateFormatter.date(from: dateStr) else { continue }
      return date
    }
    return nil
  }

  override func decode<T>(_ type: T.Type, from data: Data) throws -> T where T: Decodable {
    do {
      return try super.decode(type, from: data)
    } catch DecodingError.keyNotFound(let key, let context) {
      LoggersManager.error(message: "could not find key \(key) in JSON: \(context.debugDescription)")
      throw DecodingError.keyNotFound(key, context)
    } catch DecodingError.valueNotFound(let type, let context) {
      LoggersManager.error(message: "could not find type \(type) in JSON: \(context.debugDescription)")
      throw DecodingError.valueNotFound(type, context)
    } catch DecodingError.typeMismatch(let type, let context) {
      LoggersManager.error(message: "type mismatch for type \(type) in JSON: \(context.debugDescription)")
      throw DecodingError.typeMismatch(type, context)
    } catch DecodingError.dataCorrupted(let context) {
      LoggersManager.error(message: "data found to be corrupted in JSON: \(context.debugDescription)")
      throw DecodingError.dataCorrupted(context)
    } catch let error as NSError {
      LoggersManager
        .error(message: "Error in read(from:ofType:) domain= \(error.domain), description= \(error.localizedDescription)")
      throw error
    } catch {
      LoggersManager.error(message: "Failed to Parse Object with this type: \(type)\nError: \(error)")
      throw error
    }
  }
}
