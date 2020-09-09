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
}
