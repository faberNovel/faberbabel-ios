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
    private let fileManager = FileManager.default

    private lazy var updatedLocalizablesBundleURL = bundleUrl(
        bundleName: "updatedLocalizablesBundle",
        appGroupIdentifier: appGroupIdentifier
    )

    init(fetcher: LocalizableFetcher,
         logger: EventLogger,
         appGroupIdentifier: String?) {
        self.fetcher = fetcher
        self.logger = logger
        self.appGroupIdentifier = appGroupIdentifier
        setUp()
    }

    // MARK: - Public

    var localizableDirectoryUrl: URL {
        updatedLocalizablesBundleURL
    }

    func updateWording(request: UpdateWordingRequest,
                       bundle: Bundle,
                       completion: @escaping (WordingUpdateResult) -> Void) {
        let lang = self.lang(for: request)
        guard bundle.localizations.contains(lang) else {
            completion(.failure(.unknownLanguage(lang)))
            return
        }
        fetcher.fetch(for: lang) { result in
            switch result {
            case let .failure(error):
                completion(.failure(.unreachableServer(error)))
            case let .success(localizations):
                do {
                    let mergedLocalizable = try self.mergedLocalization(
                        remoteStrings: localizations,
                        forLanguage: lang,
                        bundle: bundle,
                        options: request.mergingOptions
                    )
                    try self.updateLocalizations(
                        forLanguage: lang,
                        withLocalizable: mergedLocalizable
                    )
                    completion(.success)
                } catch let error as WordingUpdateError {
                    completion(.failure(error))
                } catch {
                    completion(.failure(.other(error)))
                }
            }
        }
    }

    // MARK: - Private

    private func setUp() {
        try? fileManager.ft_createDirectoryIfNeeded(at: updatedLocalizablesBundleURL)
    }

    private func lang(for request: UpdateWordingRequest) -> String {
        switch request.language {
        case let .languageCode(langCode):
            return langCode
        case .current:
            return Locale.current.languageCode ?? "en"
        }
    }

    func bundleUrl(bundleName: String,
                   appGroupIdentifier: String?) -> URL {
        var path: String = ""
        if let appGroupIdentifier = appGroupIdentifier,
            let groupURL = fileManager.containerURL(forSecurityApplicationGroupIdentifier: appGroupIdentifier) {
            path = groupURL.path
        } else if let appPath = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true).first {
            path = appPath
        }
        let documentsUrl = URL(fileURLWithPath: path)
        return documentsUrl.appendingPathComponent(bundleName, isDirectory: true)
    }

    private func mergedLocalization(remoteStrings: Localizations,
                                    forLanguage lang: String,
                                    bundle: Bundle,
                                    options: MergingOptions) throws -> Localizations {
        let localizableFile = bundle.path(
            forResource: "Localizable",
            ofType: "strings",
            inDirectory: "\(lang).lproj"
        )
        guard let mainLocalizableFile = localizableFile else {
            throw WordingUpdateError.noLocalizableFileInBundle(bundle)
        }
        let localStrings: Localizations = NSDictionary(contentsOfFile: mainLocalizableFile) as? Localizations ?? [:]
        let merger = LocalizableMerger(eventLogger: logger)
        return merger.merge(localStrings: localStrings, with: remoteStrings, options: options)
    }

    private func updateLocalizations(forLanguage lang: String,
                                     withLocalizable strings: Localizations) throws {
        let langURL = localizableDirectoryUrl.appendingPathComponent("\(lang).lproj", isDirectory: true)
        try fileManager.ft_createDirectoryIfNeeded(at: langURL)
        let localFileUrl = langURL.appendingPathComponent("Localizable.strings")
        (strings as NSDictionary).write(to: localFileUrl, atomically: false)
    }
}
