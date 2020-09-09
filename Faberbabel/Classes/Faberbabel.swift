//
//  Faberbabel.swift
//  Pods
//
//  Created by Pierre Felgines on 08/09/2020.
//

import Foundation

public class Faberbabel {

    let logger: EventLogger
    private let fetcher: LocalizableFetcher
    private let appGroupIdentifier: String?

    private lazy var updatedLocalizablesBundle = Bundle(
        bundleName: "updatedLocalizablesBundle",
        appGroupIdentifier: appGroupIdentifier
    )

    init(fetcher: LocalizableFetcher,
         logger: EventLogger,
         appGroupIdentifier: String?) {
        self.fetcher = fetcher
        self.logger = logger
        self.appGroupIdentifier = appGroupIdentifier
    }

    // MARK: - Public

    var localizableDirectoryUrl: URL? {
        let bundleURL = updatedLocalizablesBundle?.bundleURL
        guard let propertyFileURL = bundleURL?.appendingPathComponent("currentLocalizableVersion.txt") else {
            return nil
        }
        let currentVersion: String
        if let version = try? String(contentsOfFile: propertyFileURL.path, encoding: .utf8) {
            currentVersion = version
        } else {
            currentVersion = "\(Date().timeIntervalSince1970)"
            try? currentVersion.write(to: propertyFileURL, atomically: false, encoding: .utf8)
        }
        return bundleURL?.appendingPathComponent(currentVersion, isDirectory: true)
    }

    func updateWording(request: UpdateWordingRequest,
                       bundle: Bundle,
                       completion: @escaping (WordingUpdateResult) -> Void) {
        let lang: String
        switch request.language {
        case let .languageCode(langCode):
            lang = langCode
        case .current:
            lang = Locale.current.languageCode ?? "en"
        }
        guard bundle.localizations.contains(lang) else {
            completion(.failure(.unknownLanguage))
            return
        }
        fetcher.fetch(for: lang) { result in
            let mergedLocalizableResult = result.mapThrow {
                try self.mergedLocalization(
                    remoteStrings: $0,
                    forLanguage: lang,
                    options: request.mergingOptions
                )
            }
            do {
                switch mergedLocalizableResult {
                case let .success(mergedLocalizable):
                    try self.updateLocalizations(forLanguage: lang, withLocalizable: mergedLocalizable)
                    completion(.success)
                case let .failure(error):
                    completion(.failure(.other(error)))
                }
            } catch let error as WordingUpdateError {
                completion(.failure(error))
            } catch {
                completion(.failure(.other(error)))
            }
        }
    }

    // MARK: - Private

    private func mergedLocalization(remoteStrings: Localizations,
                                    forLanguage lang: String,
                                    options: [MergingOption]) throws -> Localizations {
        let bundle = Bundle.main.path(
            forResource: "Localizable",
            ofType: "strings",
            inDirectory: "\(lang).lproj"
        )
        guard let mainLocalizableFile = bundle else {
            throw WordingUpdateError.unaccessibleBundle
        }
        let localStrings: Localizations = NSDictionary(contentsOfFile: mainLocalizableFile) as? Localizations ?? [:]
        let merger = LocalizableMerger(eventLogger: logger)
        return merger.merge(localStrings: localStrings, with: remoteStrings, options: options)
    }

    private func updateLocalizations(forLanguage lang: String,
                                     withLocalizable strings: Localizations) throws {
        guard let bundleURL = updatedLocalizablesBundle?.bundleURL else { return }
        let propertyFileURL = bundleURL.appendingPathComponent("currentLocalizableVersion.txt")
        if let version = try? String(contentsOfFile: propertyFileURL.path, encoding: .utf8) {
            let lastLocalizablesUrl = bundleURL.appendingPathComponent(version, isDirectory: true)
            try? FileManager.default.removeItem(atPath: lastLocalizablesUrl.path)
        }
        let currentVersion = "\(Date().timeIntervalSince1970)"
        try currentVersion.write(
            to: propertyFileURL,
            atomically: false,
            encoding: .utf8
        )
        guard let localFileUrl = localizableFileUrl(forLanguage: lang, copyMainLocalizable: false) else {
            throw WordingUpdateError.unaccessibleBundle
        }
        (strings as NSDictionary).write(to: localFileUrl, atomically: false)
    }

    private func localizableFileUrl(forLanguage lang: String,
                                    copyMainLocalizable: Bool) -> URL? {
        let languageURL = localizableDirectoryUrl?.appendingPathComponent("\(lang).lproj", isDirectory: true)
        guard let langURL = languageURL else { return nil }
        if FileManager.default.fileExists(atPath: langURL.path) == false {
            try? FileManager.default.createDirectory(
                at: langURL,
                withIntermediateDirectories: true,
                attributes: nil
            )
            if copyMainLocalizable {
                copyMainLocalization(forLang: lang, atUrl: langURL)
            }
        }
        let filePath = langURL.appendingPathComponent("Localizable.strings")
        return filePath
    }

    private func copyMainLocalization(forLang lang: String, atUrl langURL: URL) {
        let localizableFilePath = langURL.appendingPathComponent("Localizable.strings")
        let bundle = Bundle.main.path(
            forResource: "Localizable",
            ofType: "strings",
            inDirectory: "\(lang).lproj"
        )
        guard let mainLocalizableFile = bundle else {
            return
        }
        let mainLocalizable = NSDictionary(contentsOfFile: mainLocalizableFile)
        mainLocalizable?.write(toFile: localizableFilePath.path, atomically: false)
    }
}
