//
//  EventNotifier.swift
//  Faberbabel
//
//  Created by Jean Haberer on 09/07/2020.
//

import Foundation

class EventNotifier {
    static var shared: EventNotifier?

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

    func notify(events: [Event]) {
        let restBody = RestEventNotificationBody(
            events: events.map { RestEventMapper(event: $0).map() }
        )
        for event in restBody.events {
            print("FABERBABEL: \(event.type) on key \'\(event.key)\'")
        }
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

extension EventNotifier {

    func notify(event: Event) {
        notify(events: [event])
    }
}
