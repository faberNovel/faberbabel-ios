//
//  BundleLocationSelector.swift
//  Pods
//
//  Created by Pierre Felgines on 09/09/2020.
//

import Foundation

public class DefaultBundleLocationSelector {

    enum Error: Swift.Error {
        case invalidAppGroupIdentifier(String)
        case directoryNotFound
    }

    private let bundleName: String
    private let appGroupIdentifier: String?
    private let fileManager = FileManager.default

    public init(bundleName: String,
                appGroupIdentifier: String?) {
        self.bundleName = bundleName
        self.appGroupIdentifier = appGroupIdentifier
    }

    // MARK: - Public

    public func bundleUrl() throws -> URL {
        return try bundleUrl(appGroupIdentifier: appGroupIdentifier)
            .appendingPathComponent(bundleName, isDirectory: true)
    }

    // MARK: - Private

    private func bundleUrl(appGroupIdentifier: String?) throws -> URL {
        if let appGroupIdentifier = appGroupIdentifier {
            return try containerURL(forAppGroupIdentifier: appGroupIdentifier)
        } else {
            return try libraryDirectoryUrl()
        }
    }

    private func containerURL(forAppGroupIdentifier identifier: String) throws -> URL {
        guard let url = fileManager.containerURL(forSecurityApplicationGroupIdentifier: identifier) else {
            throw Error.invalidAppGroupIdentifier(identifier)
        }
        return url
    }

    private func libraryDirectoryUrl() throws -> URL {
        let path = NSSearchPathForDirectoriesInDomains(
            .libraryDirectory,
            .userDomainMask,
            true
        ).first
        guard let url = path.map(URL.init(fileURLWithPath:)) else {
            throw Error.directoryNotFound
        }
        return url
    }
}
