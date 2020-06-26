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
        guard let localFileUrl = localizableFileUrl(forLanguage: lang) else {
            completion(.failure(NSError.unaccessibleBundle))
            return
        }

        let fetcher = LocalizableFetcher()
        fetcher.fetch(for: lang) { result in
            let mergedResult = result.map { remoteStrings -> Localizations in
                mergedLocalization(fromLocalFileUrl: localFileUrl, remoteStrings: remoteStrings, forLanguage: lang)
            }
            switch mergedResult {
            case let .success(mergedStrings):
                updateMainBundle(localFileUrl: localFileUrl, withLocalizables: mergedStrings)
                updateLocalizationsBundle(forLanguage: lang, withLocalizables: mergedStrings)
                completion(.sucess)
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }

    // MARK: - Private

    private func mergedLocalization(fromLocalFileUrl: URL, remoteStrings: Localizations, forLanguage lang: String) -> Localizations {
        let localStrings: Localizations = NSDictionary(contentsOfFile: fromLocalFileUrl.path) as? Localizations ?? [:]
        let merger = LocalizableMerger()
        return merger.merge(localStrings: localStrings, with: remoteStrings)
    }

    private func updateMainBundle(localFileUrl: URL, withLocalizables strings: Localizations) {
        (strings as NSDictionary).write(to: localFileUrl, atomically: false)
    }

    private func updateLocalizationsBundle(forLanguage lang: String, withLocalizables strings: Localizations){
        if Bundle.updatedLocalizationsBundle == nil {
            Bundle.updatedLocalizationsBundle = Bundle(bundleName: "updatedLocalizationsBundle")
        }

        let bundleURL = Bundle.updatedLocalizationsBundle?.bundleURL
        let languageURL = bundleURL?.appendingPathComponent("\(lang).lproj", isDirectory: true)
        guard let langURL = languageURL else { return }

        if FileManager.default.fileExists(atPath: langURL.path) == false {
            try? FileManager.default.createDirectory(at: langURL, withIntermediateDirectories: true, attributes: nil)
        }

        let filePath = langURL.appendingPathComponent("Localizable.strings")
        (strings as NSDictionary).write(to: filePath, atomically: false)
    }

    private func localizableFileUrl(forLanguage lang: String) -> URL? {
        return self.url(
            forResource: "Localizable",
            withExtension: "strings",
            subdirectory: "\(lang).lproj"
        )
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
