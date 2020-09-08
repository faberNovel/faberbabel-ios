//
//  LocalizableFetcher.swift
//  Faberbabel
//
//  Created by Jean Haberer on 24/06/2020.
//

import Foundation

class LocalizableFetcher {
    static var shared: LocalizableFetcher?

    let projectId: String
    let baseURL: URL

    init(baseURL: URL, projectId: String) {
        self.baseURL = baseURL
        self.projectId = projectId
    }

    func fetch(for lang: String,
               completion: @escaping(Result<Localizations, Error>) -> Void) {
        var urlComponents = URLComponents(string: baseURL.absoluteString + "/translations/projects/\(projectId)")
        urlComponents?.queryItems = [
            URLQueryItem(name: "platform", value: "ios"),
            URLQueryItem(name: "language", value: lang)
        ]
        DispatchQueue(label: "updateWording").async {
            if let url = urlComponents?.url,
                let dictionary = NSDictionary(contentsOf: url),
                let localizations = dictionary as? Localizations {
                DispatchQueue.main.async {
                    completion(.success(localizations))
                }
            } else {
                DispatchQueue.main.async {
                    completion(.failure(WordingUpdateError.unreachableServer))
                }
            }
        }
    }
}
