//
//  EventLogger.swift
//  Faberbabel
//
//  Created by Jean Haberer on 09/07/2020.
//

import Foundation

public protocol EventLogger {
    func log(_ events: [Event])
}

public extension EventLogger {

    func log(_ event: Event) {
        log([event])
    }
}

public class CompoundEventLogger: EventLogger {

    private let loggers: [EventLogger]

    public init(loggers: [EventLogger]) {
        self.loggers = loggers
    }

    // MARK: - EventLogger

    public func log(_ events: [Event]) {
        loggers.forEach {
            $0.log(events)
        }
    }
}

public class ConsoleEventLogger: EventLogger {

    // MARK: - EventLogger

    public func log(_ events: [Event]) {
        events.forEach { event in
            print("FABERBABEL: \(event.type) on key \'\(event.key)\'")
        }
    }
}

class RemoteEventLogger: EventLogger {

    private let projectId: String
    private let baseURL: URL
    private let urlSession: URLSession

    init(projectId: String,
         baseURL: URL,
         urlSession: URLSession = .shared) {
        self.baseURL = baseURL
        self.projectId = projectId
        self.urlSession = urlSession
    }

    private struct RestEventNotificationBody: Codable {
        let events: [RestEvent]
    }

    // MARK: - EventLogger

    func log(_ events: [Event]) {
        let restBody = RestEventNotificationBody(
            events: events.map { RestEventMapper(event: $0).map() }
        )
        let url = baseURL.appendingPathComponent("translations/projects/\(projectId)/events")
        var request = URLRequest(url: url)
        do {
            request.httpBody = try JSONEncoder().encode(restBody)
        } catch {
            print(error.localizedDescription)
        }
        request.httpMethod = "POST"
        let task = urlSession.dataTask(with: request as URLRequest)
        task.resume()
    }
}
