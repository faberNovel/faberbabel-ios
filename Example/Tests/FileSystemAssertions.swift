//
//  FileSystemAssertions.swift
//  Faberbabel_Example
//
//  Created by Pierre Felgines on 09/09/2020.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation
import XCTest

// swiftlint:disable force_try

func FTAssertFileExists(at url: URL,
                        file: StaticString = #file,
                        line: UInt = #line) {
    XCTAssertTrue(
        FileManager.default.fileExists(atPath: url.path),
        "File should exist at path \(url.path)",
        file: file,
        line: line
    )
}

func FTAssertFileMissing(at url: URL,
                         file: StaticString = #file,
                         line: UInt = #line) {
    XCTAssertFalse(
        FileManager.default.fileExists(atPath: url.path),
        "File should not exist at path \(url.path)",
        file: file,
        line: line
    )
}

func FTAssertDirectoryEmpty(at url: URL,
                            file: StaticString = #file,
                            line: UInt = #line) {
    let contents = try! FileManager.default.contentsOfDirectory(atPath: url.path)
    XCTAssertTrue(
        contents.isEmpty,
        "Directory should be empty at \(url.path)",
        file: file,
        line: line
    )
}
