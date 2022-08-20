//
//  OrdiPulseAlamofirePlugin.swift
//  
//
//  Created by Ahmed Ramy on 04/08/2022.
//

import Foundation
import Alamofire
import Pulse

public struct OAlamofireEventsMonitor: EventMonitor {
    let logger: NetworkLogger = .init()

    public func request(_: Request, didCreateTask task: URLSessionTask) {
        logger.logTaskCreated(task)
    }

    public func urlSession(_: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        logger.logDataTask(dataTask, didReceive: data)
    }

    public func urlSession(_: URLSession, task: URLSessionTask, didFinishCollecting metrics: URLSessionTaskMetrics) {
        logger.logTask(task, didFinishCollecting: metrics)
    }

    public func urlSession(_: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        logger.logTask(task, didCompleteWithError: error)
    }
}

extension Alamofire.Session {
    public func usePulseMonitor() -> Alamofire.Session {
        .init(eventMonitors: [OAlamofireEventsMonitor()])
    }
}
