//
//  EventMapper.swift
//  Faberbabel
//
//  Created by Jean Haberer on 10/07/2020.
//

import Foundation

class EventMapper {

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
