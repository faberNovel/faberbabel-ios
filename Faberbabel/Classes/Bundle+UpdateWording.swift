//
//  Bundle+UpdateWording.swift
//  Faberbabel
//
//  Created by Jean Haberer on 23/06/2020.
//

import Foundation
import CoreData

extension Bundle {

    static var updatedLocalizables: [String: Localizations] = [:]

    static func localizableFileUrl(forLanguage lang: String) -> URL? {
        let bundleURL = Bundle(bundleName: "updatedLocalizationsBundle")?.bundleURL
        let languageURL = bundleURL?.appendingPathComponent("\(lang).lproj", isDirectory: true)
        guard let langURL = languageURL else { return nil }

        if FileManager.default.fileExists(atPath: langURL.path) == false {
            try? FileManager.default.createDirectory(at: langURL, withIntermediateDirectories: true, attributes: nil)
        }

        let filePath = langURL.appendingPathComponent("Localizable.strings")
        return filePath
    }

    // MARK: - Public
    
    public func updateWording(request: UpdateWordingRequest, completion: @escaping(WordingUpdateResult) -> Void) {
        let lang: String
        switch request.language {
        case let .languageCode(langCode):
            lang = langCode
        case .current:
            lang = Locale.current.languageCode ?? "en"
        }

        guard self.localizations.contains(lang) else {
            completion(.failure(NSError.unknownLanguage))
            return
        }

        let fetcher = LocalizableFetcher(baseURL: request.baseURL, projectId: request.projectId)
        fetcher.fetch(for: lang) { result in
            let mergedLocalizableResult = result.mapThrow { try self.mergedLocalization(remoteStrings: $0, forLanguage: lang)}
            do {
                switch mergedLocalizableResult {
                case let .success(mergedLocalizable):
                    try self.updateLocalizations(forLanguage: lang, withLocalizable: mergedLocalizable)
                    completion(.success)
                case let .failure(error):
                    throw error
                }
            } catch {
                completion(.failure(error))
            }
        }
    }

    // MARK: - Private

    private func mergedLocalization(remoteStrings: Localizations, forLanguage lang: String) throws -> Localizations {
        guard let localFileUrl = Bundle.localizableFileUrl(forLanguage: lang) else {
            throw NSError.unaccessibleBundle
        }
        let localStrings: Localizations = NSDictionary(contentsOfFile: localFileUrl.path) as? Localizations ?? [:]
        let merger = LocalizableMerger()
        return merger.merge(localStrings: localStrings, with: remoteStrings)
    }

    private func updateLocalizations(forLanguage lang: String, withLocalizable strings: Localizations) throws {
        guard let localFileUrl = Bundle.localizableFileUrl(forLanguage: lang) else {
            throw NSError.unaccessibleBundle
        }
        Bundle.updatedLocalizables[lang] = strings
        (strings as NSDictionary).write(to: localFileUrl, atomically: false)
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
