//
//  Bundle+UpdateWording.swift
//  Faberbabel
//
//  Created by Jean Haberer on 23/06/2020.
//

import Foundation

extension Bundle {

    // TODO: (Pierre Felgines) 08/09/2020 Pass appGroupIdentifier
    static var updatedLocalizablesBundle = Bundle(bundleName: "updatedLocalizablesBundle", appGroupIdentifier: nil)
}

extension Bundle {

    // MARK: - Convenience functions

    private static func bundleUrl(bundleName: String,
                                  appGroupIdentifier: String?) -> URL? {
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

    private convenience init?(bundleName: String, appGroupIdentifier: String?) {
        guard let bundleUrl = Bundle.bundleUrl(bundleName: bundleName, appGroupIdentifier: appGroupIdentifier) else {
            return nil
        }
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
