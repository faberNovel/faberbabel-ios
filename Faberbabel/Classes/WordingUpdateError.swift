//
//  WordingUpdateError.swift
//  Faberbabel
//
//  Created by Jean Haberer on 24/06/2020.
//

import Foundation

public enum WordingUpdateError: Error {
    case unknownLanguage
    case unaccessibleBundle
    case noLocalizableFileInBundle(Bundle)
    case unreachableServer(_ error: Error)
    case other(_ error: Error)
}

extension WordingUpdateError: LocalizedError {

    // MARK: - LocalizedError

    public var errorDescription: String? {
        switch self {
        case .unknownLanguage:
            return "Unknown Language Code"
        case let .unreachableServer(error):
            return "Unable to reach the server \(error.localizedDescription)"
        case let .noLocalizableFileInBundle(bundle):
            return "No localizable file in bundle \(bundle)"
        case .unaccessibleBundle:
            return "Unaccessible Bundle"
        case let .other(error):
            return error.localizedDescription
        }
    }
}
