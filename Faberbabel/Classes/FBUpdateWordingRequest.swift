//
//  FBUpdateWordingRequest.swift
//  Faberbabel
//
//  Created by Jean Haberer on 29/06/2020.
//

import Foundation

public struct FBUpdateWordingRequest {
    public let baseURL: URL
    public let projectId: String
    public let language: Language

    public enum Language {
        case current
        case languageCode(String)
    }

    public init(baseURL: URL, projectId: String, language: Language) {
        self.baseURL = baseURL
        self.projectId = projectId
        self.language = language
    }
}
