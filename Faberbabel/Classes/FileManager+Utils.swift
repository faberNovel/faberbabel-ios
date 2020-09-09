//
//  FileManager+Utils.swift
//  Pods
//
//  Created by Pierre Felgines on 09/09/2020.
//

import Foundation

extension FileManager {

    func ft_createDirectoryIfNeeded(at url: URL) throws {
        guard !fileExists(atPath: url.path) else {
            return
        }
        try createDirectory(
            at: url,
            withIntermediateDirectories: true,
            attributes: nil
        )
    }
}
