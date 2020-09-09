//
//  WordingUpdateError.swift
//  Faberbabel
//
//  Created by Jean Haberer on 24/06/2020.
//

import Foundation

public enum WordingUpdateError: Error {
    case unknownLanguage(String)
    case noLocalizableFileInBundle(Bundle)
    case unreachableServer(_ error: Error)
    case other(_ error: Error)
}

extension WordingUpdateError: LocalizedError {

    // MARK: - LocalizedError

    public var errorDescription: String? {
        switch self {
        case let .unknownLanguage(lang):
            return "Unknown Language Code \(lang)"
        case let .unreachableServer(error):
            return "Unable to reach the server \(error.localizedDescription)"
        case let .noLocalizableFileInBundle(bundle):
            return "No localizable file in bundle \(bundle)"
        case let .other(error):
            return error.localizedDescription
        }
    }
}
