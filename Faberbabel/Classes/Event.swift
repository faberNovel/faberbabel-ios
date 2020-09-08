//
//  Event.swift
//  Faberbabel
//
//  Created by Jean Haberer on 10/07/2020.
//

import Foundation

enum EventType {
    case missingKey
    case emptyValue
    case mismatchAttributes
}

struct Event {
    let type: EventType
    let key: String
}
