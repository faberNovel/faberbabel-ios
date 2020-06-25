//
//  Bundle+UpdateWording.swift
//  Faberbabel
//
//  Created by Jean Haberer on 23/06/2020.
//

import Foundation
import CoreData

extension Bundle {
    public func updateCurrentWording(completion: (WordingUpdateResult) -> Void) {
        let lang = Locale.current.languageCode ?? "Base"
        updateWording(forLanguageCode: lang, completion: completion)
    }

    public func updateWording(forLanguageCode lang: String, completion: (WordingUpdateResult) -> Void) {
        guard self.localizations.contains(lang) else {
            completion(.failure(NSError.unknownLanguage))
            return
        }

        let fetcher = LocalizableFetcher()
        fetcher.fetch(for: lang) { (result) in
            switch result {
            case let .success(strings):
                do {

                    guard
                        let url: URL = self.url(
                            forResource: "Localizable",
                            withExtension: "strings",
                            subdirectory: "\(lang).lproj"
                        )
                        else { throw NSError.unaccessibleBundle }

                    try strings.write(
                        to: url,
                        atomically: false,
                        encoding: .utf8
                    )

                    completion(.sucess)
                } catch let error {
                    completion(.failure(error))
                }
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}
