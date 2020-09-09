//
//  RestEventMapper.swift
//  Faberbabel
//
//  Created by Jean Haberer on 10/07/2020.
//

import Foundation

private extension EventType {

    var rawValue: String {
        switch self {
        case .emptyValue:
            return "empty_value"
        case .mismatchAttributes:
            return "mismatch_attributes"
        case .missingKey:
            return "missing_key"
        }
    }
}

class RestEventMapper {

    let event: Event

    init(event: Event) {
        self.event = event
    }

    func map() -> RestEvent {
        return RestEvent(
            type: event.type.rawValue,
            key: event.key
        )
    }
}
