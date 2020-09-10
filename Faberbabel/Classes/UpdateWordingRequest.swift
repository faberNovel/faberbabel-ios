//
//  UpdateWordingRequest.swift
//  Faberbabel
//
//  Created by Jean Haberer on 29/06/2020.
//

import Foundation

public struct UpdateWordingRequest {
    public let language: Language
    public let mergingOptions: MergingOptions

    public enum Language {
        case current
        case languageCode(String)
    }

    public init(language: Language = .current,
                mergingOptions: MergingOptions = []) {
        self.language = language
        self.mergingOptions = mergingOptions
    }
}

public struct MergingOptions: OptionSet {
    public let rawValue: Int

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }

    public static let allowRemoteEmptyString = MergingOptions(rawValue: 1 << 0)
    public static let allowAttributeNumberMismatch = MergingOptions(rawValue: 1 << 1)
}
