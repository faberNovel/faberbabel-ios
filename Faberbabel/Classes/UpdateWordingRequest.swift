//
//  UpdateWordingRequest.swift
//  Faberbabel
//
//  Created by Jean Haberer on 29/06/2020.
//

import Foundation

public struct UpdateWordingRequest {
    public let baseURL: URL
    public let projectId: String
    public let language: Language
    public let mergingOptions : [MergingOption]

    public enum Language {
        case current
        case languageCode(String)
    }

    public init(
        baseURL: URL,
        projectId: String,
        language: Language = .current,
        mergingOptions: [MergingOption] = []
    ) {
        self.baseURL = baseURL
        self.projectId = projectId
        self.language = language
        self.mergingOptions = mergingOptions
    }
}

public enum MergingOption {
    case allowRemoteEmptyString
    case allowAttributeNumberMismatch
}
