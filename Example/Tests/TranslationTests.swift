//
//  TranslationTests.swift
//  Faberbabel_Example
//
//  Created by Pierre Felgines on 09/09/2020.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation
import XCTest
@testable import Faberbabel

// swiftlint:disable implicitly_unwrapped_optional force_try unavailable_function

class EmptyFetcher: LocalizableFetcher {

    func fetch(for lang: String,
               completion: @escaping (Result<Localizations, Error>) -> Void) {
        fatalError("This should not be called")
    }
}

class TranslationTests: XCTestCase {

    var manager: LocalizableManager!
    var logger: MemoryEventLogger!

    override func setUp() {
        super.setUp()
        logger = MemoryEventLogger()
        manager = try! LocalizableManager(
            fetcher: EmptyFetcher(),
            logger: logger,
            appGroupIdentifier: nil
        )

        FTAssertDirectoryEmpty(at: manager.localizableDirectoryUrl)
    }

    override func tearDown() {
        super.tearDown()
        try! FileManager.default.removeItem(at: manager.localizableDirectoryUrl)
    }

    func testMissingKey() {
        // Given
        let missingKey = "___"
        // When
        let value = manager.translation(forKey: missingKey, lang: "en")
        // Then
        let event = Event(type: .missingKey, key: missingKey)
        XCTAssertEqual(logger.loggedEvents, [event])
        XCTAssertEqual(value, missingKey)
    }

    func testDefaultValueIfNoRemoteLocalizable() {
        // Given
        let key = "hello_world_title"

        ["en", "fr", "pt"].forEach { lang in
            // When
            let value = manager.translation(forKey: key, lang: "en")
            // Then
            let expectedValue = Bundle.main.localizedString(forKey: key, value: nil, table: nil)
            XCTAssertFalse(expectedValue.isEmpty)
            XCTAssertNotEqual(expectedValue, key)
            XCTAssertEqual(value, expectedValue)
            XCTAssertEqual(logger.loggedEvents, [])
        }
    }

    func testSuccessWithRemoteLocalizable() {
        // Given
        let key = "hello_world_title"
        let expectedValue = "this is a remote key"
        let content: Localizations = [key: expectedValue]

        writeLocalizable(content, forLanguage: "en")

        // When
        let value = manager.translation(forKey: key, lang: "en")

        // Then
        XCTAssertEqual(logger.loggedEvents, [])
        let defaultValue = Bundle.main.localizedString(forKey: key, value: nil, table: nil)
        XCTAssertNotEqual(value, defaultValue)
        XCTAssertEqual(value, expectedValue)
    }

    func testFallbackWithRemoteLocalizable() {
        // Given
        let key = "hello_world_title"
        let fallbackValue = "this is a remote key"
        let content: Localizations = [key: fallbackValue]
        writeLocalizable(content, forLanguage: "en")
        writeLocalizable([:], forLanguage: "fr")

        // When
        let value = manager.translation(forKey: key, lang: "fr")

        // Then
        let event = Event(type: .missingKey, key: key)
        XCTAssertEqual(logger.loggedEvents, [event])
        XCTAssertEqual(value, fallbackValue)
    }

    // MARK: - Private

    private func writeLocalizable(_ content: Localizations,
                                  forLanguage lang: String) {
        let lprojUrl = manager.localizableDirectoryUrl.appendingPathComponent("\(lang).lproj")
        XCTAssertNoThrow(
            try FileManager.default.createDirectory(at: lprojUrl, withIntermediateDirectories: true)
        )
        let url = lprojUrl.appendingPathComponent("Localizable.strings")
        let result = (content as NSDictionary).write(to: url, atomically: false)
        XCTAssertTrue(result, "File could not be written")
        FTAssertFileExists(at: url)
    }
}
