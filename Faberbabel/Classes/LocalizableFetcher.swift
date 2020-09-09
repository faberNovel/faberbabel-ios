//
//  LocalizableFetcher.swift
//  Faberbabel
//
//  Created by Jean Haberer on 24/06/2020.
//

import Foundation

public protocol LocalizableFetcher {
    func fetch(for lang: String,
               completion: @escaping(Result<Localizations, Error>) -> Void)
}

class RemoteLocalizableFetcher: LocalizableFetcher {

    enum LocalError: Error {
        case malformedUrl
        case generic
    }

    private let projectId: String
    private let baseURL: URL
    private let urlSession: URLSession

    init(projectId: String,
         baseURL: URL,
         urlSession: URLSession = .shared) {
        self.projectId = projectId
        self.baseURL = baseURL
        self.urlSession = urlSession
    }

    // MARK: - LocalizableFetcher

    func fetch(for lang: String,
               completion: @escaping(Result<Localizations, Error>) -> Void) {
        var urlComponents = URLComponents(string: baseURL.absoluteString + "/translations/projects/\(projectId)")
        urlComponents?.queryItems = [
            URLQueryItem(name: "platform", value: "ios"),
            URLQueryItem(name: "language", value: lang)
        ]

        guard let url = urlComponents?.url else {
            completion(.failure(LocalError.malformedUrl))
            return
        }

        let task = urlSession.dataTask(with: url) { (data, _, error) in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(error ?? LocalError.generic))
                }
                return
            }
            do {
                let decoder = PropertyListDecoder()
                let localizations = try decoder.decode(Localizations.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(localizations))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
}
