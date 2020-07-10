//
//  Event.swift
//  Faberbabel
//
//  Created by Jean Haberer on 10/07/2020.
//

import Foundation

struct Event {
    let type: EventType
    let key: String

    enum EventType: String {
        case missing_key
        case empty_value
        case mismatch_attributes
    }
}
