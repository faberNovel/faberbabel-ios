//
//  FaberbabelTests.swift
//  Faberbabel_Tests
//
//  Created by Pierre Felgines on 08/09/2020.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation
import XCTest
@testable import Faberbabel

// swiftlint:disable implicitly_unwrapped_optional force_try

class Fetcher: LocalizableFetcher {

    var result: Result<Localizations, Error> = .success([:])

    func fetch(for lang: String,
               completion: @escaping (Result<Localizations, Error>) -> Void) {
        completion(result)
    }
}

func FTAssertFileExists(at url: URL, file: StaticString = #file, line: UInt = #line) {
    XCTAssertTrue(
        FileManager.default.fileExists(atPath: url.path),
        "File should exist at path \(url.path)",
        file: file,
        line: line
    )
}

func FTAssertFileMissing(at url: URL, file: StaticString = #file, line: UInt = #line) {
    XCTAssertFalse(
        FileManager.default.fileExists(atPath: url.path),
        "File should not exist at path \(url.path)",
        file: file,
        line: line
    )
}

class FaberbabelTests: XCTestCase {

    struct TestError: Error {}

    var faberbabel: Faberbabel!
    var fetcher: Fetcher!

    override func setUp() {
        super.setUp()
        fetcher = Fetcher()
        faberbabel = try! Faberbabel(
            fetcher: fetcher,
            logger: EmptyLogger(),
            appGroupIdentifier: nil
        )
    }

    override func tearDown() {
        super.tearDown()
        try! FileManager.default.removeItem(at: faberbabel.localizableDirectoryUrl)
    }

    func testUpdateWordingFailsWhenFetcherFails() {
        // Given
        fetcher.result = .failure(TestError())

        // When
        let expectation = XCTestExpectation(description: "failure")
        let request = UpdateWordingRequest()
        faberbabel.updateWording(
            request: request,
            bundle: .main
        ) { result in
            switch result {
            case .success:
                XCTFail("This should not be a success")
            case let .failure(error):
                switch error {
                case .unknownLanguage,
                     .noLocalizableFileInBundle,
                     .other:
                    XCTFail("This is not the correct error")
                case .unreachableServer:
                    expectation.fulfill()
                }
            }
        }
        wait(for: [expectation], timeout: 0.1)
    }

    func testUpdateWordingFailsWhenBundleDoesNotContainLocalizableFile() {
        // Given
        let bundle = Bundle(for: FaberbabelTests.self)

        // When
        let expectation = XCTestExpectation(description: "failure")
        let request = UpdateWordingRequest()
        faberbabel.updateWording(
            request: request,
            bundle: bundle
        ) { result in
            switch result {
            case .success:
                XCTFail("This should not be a success")
            case let .failure(error):
                switch error {
                case .unreachableServer,
                     .unknownLanguage,
                     .other:
                    XCTFail("This is not the correct error \(error)")
                case let .noLocalizableFileInBundle(errorBundle):
                    XCTAssertEqual(bundle, errorBundle)
                    expectation.fulfill()
                }
            }
        }
        wait(for: [expectation], timeout: 0.1)
    }

    func testUpdateWordingFailsWhenLanguageIsNotAvailable() {
        // Given
        let lang = "zzzz"

        // When
        let expectation = XCTestExpectation(description: "failure")
        let request = UpdateWordingRequest(language: .languageCode(lang))
        faberbabel.updateWording(
            request: request,
            bundle: .main
        ) { result in
            switch result {
            case .success:
                XCTFail("This should not be a success")
            case let .failure(error):
                switch error {
                case .unreachableServer,
                     .noLocalizableFileInBundle,
                     .other:
                    XCTFail("This is not the correct error \(error)")
                case let .unknownLanguage(errorLang):
                    XCTAssertEqual(lang, errorLang)
                    expectation.fulfill()
                }
            }
        }
        wait(for: [expectation], timeout: 0.1)
    }

    func testUpdateWordingSucceedsWithLocalizableFilesUpdated() {
        // Given
        let remoteKey = "test_key"
        let remoteValue = "test_value"
        let remoteLocalizations: Localizations = [remoteKey: remoteValue]
        fetcher.result = .success(remoteLocalizations)

        let localizableStringsUrl = faberbabel
            .localizableDirectoryUrl
            .appendingPathComponent("en.lproj/Localizable.strings")

        FTAssertFileExists(at: faberbabel.localizableDirectoryUrl)
        FTAssertFileMissing(at: localizableStringsUrl)

        // When
        let expectation = XCTestExpectation(description: "success")
        let request = UpdateWordingRequest(language: .languageCode("en"))
        faberbabel.updateWording(
            request: request,
            bundle: .main
        ) { result in
            switch result {
            case .success:
                // Then
                FTAssertFileExists(at: localizableStringsUrl)
                let writtenLocalization = NSDictionary(contentsOf: localizableStringsUrl) as? Localizations ?? [:]
                XCTAssertEqual(writtenLocalization[remoteKey], remoteValue)
                expectation.fulfill()
            case .failure:
                XCTFail("This should not be a failure")
            }
        }
        wait(for: [expectation], timeout: 0.1)
    }
}
