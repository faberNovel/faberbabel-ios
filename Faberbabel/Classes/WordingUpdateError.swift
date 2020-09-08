//
//  WordingUpdateError.swift
//  Faberbabel
//
//  Created by Jean Haberer on 24/06/2020.
//

import Foundation

public enum WordingUpdateError: Error {
    case unknownLanguage
    case unreachableServer
    case unaccessibleBundle
    case sdkNotSetUp
    case other(_ error: Error)
}

extension WordingUpdateError: LocalizedError {

    // MARK: - LocalizedError

    public var errorDescription: String? {
        switch self {
        case .unknownLanguage:
            return "Unknown Language Code"
        case .unreachableServer:
            return "Unable to reach the server"
        case .unaccessibleBundle:
            return "Unaccessible Bundle"
        case .sdkNotSetUp:
            return "The SDK wasn't setup. Follow the README instructions."
        case let .other(error):
            return error.localizedDescription
        }
    }
}
