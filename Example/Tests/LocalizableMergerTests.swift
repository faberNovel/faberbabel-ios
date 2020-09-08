//
//  LocalizableMergerTests.swift
//  Faberbabel_Example
//
//  Created by Pierre Felgines on 08/09/2020.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation
import XCTest
@testable import Faberbabel

extension Event: Equatable {
    public static func == (lhs: Event, rhs: Event) -> Bool {
        return lhs.key == rhs.key
            && lhs.type == rhs.type
    }
}

extension Event: Comparable {

    public static func < (lhs: Event, rhs: Event) -> Bool {
        return lhs.key < rhs.key
    }
}

// swiftlint:disable implicitly_unwrapped_optional

class MemoryEventLogger: EventLogger {

    var loggedEvents: [Event] = []

    // MARK: - EventLogger

    func log(_ events: [Event]) {
        loggedEvents.append(contentsOf: events)
    }
}

class LocalizableMergerTests: XCTestCase {

    var logger: MemoryEventLogger!
    var localizableMerger: LocalizableMerger!

    override func setUp() {
        super.setUp()
        logger = MemoryEventLogger()
        localizableMerger = LocalizableMerger(eventLogger: logger)
    }

    func testWrongAttributesNumberShouldNotMerge() {
        // Given
        let local = ["key1": "%@ %@", "key2": "%1$@ %2$@"]
        let remote = ["key1": "%@", "key2": "%1$@ %2$@ %3$@"]
        // When
        let merged = localizableMerger.merge(localStrings: local, with: remote)
        // Then
        XCTAssertEqual(merged, local)
        let expectedEvents = [
            Event(type: .mismatchAttributes, key: "key1"),
            Event(type: .mismatchAttributes, key: "key2")
        ]
        XCTAssertEqual(logger.loggedEvents.sorted(), expectedEvents)
    }

    func testWrongAttributesNumberShouldMerge() {
        // Given
        let local = ["key1": "%@ %@", "key2": "%1$@ %2$@"]
        let remote = ["key1": "%@", "key2": "%1$@ %2$@ %3$@"]
        // When
        let merged = localizableMerger.merge(
            localStrings: local,
            with: remote,
            options: [.allowAttributeNumberMismatch]
        )
        // Then
        XCTAssertEqual(merged, remote)
        XCTAssertEqual(logger.loggedEvents, [])
    }

    func testCorrectAttributesNumberShouldMerge() {
        // Given
        let local = ["key1": "%@ local %@", "key2": "%1$@ local %2$@"]
        let remote = ["key1": "%@ remote %@", "key2": "%1$@ remote %2$@"]
        // When
        let merged = localizableMerger.merge(localStrings: local, with: remote)
        // Then
        XCTAssertEqual(merged, remote)
        XCTAssertEqual(logger.loggedEvents, [])
    }

    func testLackRemoteKeyShouldKeepLocalKey() {
        // Given
        let local = ["key1": "hello world", "key2": "this string should survive"]
        let remote = ["key1": "hello updated world"]
        // When
        let merged = localizableMerger.merge(localStrings: local, with: remote)
        // Then
        let expected = ["key1": "hello updated world", "key2": "this string should survive"]
        XCTAssertEqual(merged, expected)
        XCTAssertEqual(logger.loggedEvents, [])
    }

    func testEmptyRemoteKeyShouldKeepLocalKey() {
        // Given
        let local = ["key": "this string should survive"]
        let remote = ["key": ""]
        // When
        let merged = localizableMerger.merge(localStrings: local, with: remote)
        // Then
        XCTAssertEqual(merged, local)
        let event = Event(type: .emptyValue, key: "key")
        XCTAssertEqual(logger.loggedEvents.sorted(), [event])
    }

    func testEmptyRemoteKeyShouldMerge() {
        // Given
        let local = ["key": "this string should survive"]
        let remote = ["key": ""]
        // When
        let merged = localizableMerger.merge(
            localStrings: local,
            with: remote,
            options: [.allowRemoteEmptyString]
        )
        // Then
        XCTAssertEqual(merged, remote)
        XCTAssertEqual(logger.loggedEvents, [])
    }
}
