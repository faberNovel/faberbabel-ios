//
//  Bundle+UpdateWording.swift
//  Faberbabel
//
//  Created by Jean Haberer on 23/06/2020.
//

import Foundation
import CoreData

extension Bundle {

    static var updatedLocalizationsBundle: Bundle?

    static func updateLocalizationsBundle(forLanguage lang: String, withLocalizables strings: NSDictionary) {
        if updatedLocalizationsBundle == nil {
            updatedLocalizationsBundle = Bundle(bundleName: "updatedLocalizationsBundle")
        }

        let bundleURL = updatedLocalizationsBundle?.bundleURL
        let languageURL = bundleURL?.appendingPathComponent("\(lang).lproj", isDirectory: true)
        guard let langURL = languageURL else { return }

        if FileManager.default.fileExists(atPath: langURL.path) == false {
            try? FileManager.default.createDirectory(at: langURL, withIntermediateDirectories: true, attributes: nil)
        }
        let filePath = langURL.appendingPathComponent("Localizable.strings")
        strings.write(to: filePath, atomically: false)
    }

    // MARK: - Public

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

                    let localString = NSDictionary(contentsOfFile: url.path) ?? NSDictionary()
                    let merger = LocalizableMerger()
                    let mergedStrings = merger.merge(localStrings: localString, with: strings)
                    mergedStrings.write(
                        to: url,
                        atomically: false
                    )
                    Bundle.updateLocalizationsBundle(forLanguage: lang, withLocalizables: mergedStrings)
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

extension Bundle {

    // MARK: - Convenience functions

    static func bundleUrl(bundleName: String) -> URL? {
        guard let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first else {
            return nil
        }
        let documentsUrl = URL(fileURLWithPath: path)
        return documentsUrl.appendingPathComponent(bundleName, isDirectory: true)
    }

    convenience init?(bundleName: String) {
        guard let bundleUrl = Bundle.bundleUrl(bundleName: bundleName) else { return nil }
        let fileManager = FileManager.default
        if !fileManager.fileExists(atPath: bundleUrl.path) {
            try? fileManager.createDirectory(at: bundleUrl, withIntermediateDirectories: true, attributes: nil)
        }
        self.init(url: bundleUrl)

    }
}
