//
//  EventNotifier.swift
//  Faberbabel
//
//  Created by Jean Haberer on 09/07/2020.
//

import Foundation

class EventNotifier {
    static var shared: EventNotifier?

    let projectId: String
    let baseURL: URL

    init(projectId: String,
         baseURL: URL) {
        self.baseURL = baseURL
        self.projectId = projectId
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
        let session = URLSession.shared
        var request = URLRequest(url: url)
        do {
            request.httpBody = try JSONEncoder().encode(restBody)
        } catch {
            print(error.localizedDescription)
        }
        request.httpMethod = "POST"
        let task = session.dataTask(with: request as URLRequest)
        task.resume()
    }
}

extension EventNotifier {

    func notify(event: Event) {
        notify(events: [event])
    }
}
