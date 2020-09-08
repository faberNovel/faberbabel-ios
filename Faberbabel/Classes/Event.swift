//
//  Event.swift
//  Faberbabel
//
//  Created by Jean Haberer on 10/07/2020.
//

import Foundation

public enum EventType {
    case missingKey
    case emptyValue
    case mismatchAttributes
}

public struct Event {
    public let type: EventType
    public let key: String
}
