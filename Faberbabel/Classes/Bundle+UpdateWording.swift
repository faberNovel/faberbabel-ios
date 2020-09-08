//
//  Bundle+UpdateWording.swift
//  Faberbabel
//
//  Created by Jean Haberer on 23/06/2020.
//

import Foundation

extension Bundle {

    static var updatedLocalizablesBundle = Bundle(bundleName: "updatedLocalizablesBundle")
    private static var appGroupIdentifier: String?

    var localizableDirectoryUrl: URL? {
        let bundleURL = Bundle.updatedLocalizablesBundle?.bundleURL
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

    // MARK: - Public

    public static func fb_setup(projectId: String, baseURL: URL) {
        EventNotifier.shared = EventNotifier(projectId: projectId, baseURL: baseURL)
        LocalizableFetcher.shared = LocalizableFetcher(baseURL: baseURL, projectId: projectId)
    }

    public static func fb_addAppGroupIdentifier(_ appGroupIdentifier: String) {
        self.appGroupIdentifier = appGroupIdentifier
    }

    public func fb_updateWording(request: UpdateWordingRequest,
                                 completion: @escaping(WordingUpdateResult) -> Void) {
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
        guard let fetcher = LocalizableFetcher.shared else {
            completion(.failure(NSError.sdkNotSetUp))
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
                    throw error
                }
            } catch {
                completion(.failure(error))
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
            throw NSError.unaccessibleBundle
        }
        let localStrings: Localizations = NSDictionary(contentsOfFile: mainLocalizableFile) as? Localizations ?? [:]
        let merger = LocalizableMerger()
        return merger.merge(localStrings: localStrings, with: remoteStrings, options: options)
    }

    private func updateLocalizations(forLanguage lang: String,
                                     withLocalizable strings: Localizations) throws {
        guard let bundleURL = Bundle.updatedLocalizablesBundle?.bundleURL else { return }
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
            throw NSError.unaccessibleBundle
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

extension Bundle {

    // MARK: - Convenience functions

    static func bundleUrl(bundleName: String) -> URL? {
        var path: String = ""
        if let appGroupIdentifier = appGroupIdentifier,
            let groupURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroupIdentifier) {
            path = groupURL.path
        } else if let appPath = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true).first {
            path = appPath
        }
        let documentsUrl = URL(fileURLWithPath: path)
        return documentsUrl.appendingPathComponent(bundleName, isDirectory: true)
    }

    convenience init?(bundleName: String) {
        guard let bundleUrl = Bundle.bundleUrl(bundleName: bundleName) else { return nil }
        let fileManager = FileManager.default
        if !fileManager.fileExists(atPath: bundleUrl.path) {
            try? fileManager.createDirectory(
                at: bundleUrl,
                withIntermediateDirectories: true,
                attributes: nil
            )
        }
        self.init(url: bundleUrl)
    }
}
