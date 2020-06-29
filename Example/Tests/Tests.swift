import XCTest
@testable import Faberbabel

class Tests: XCTestCase {

    func testMerger_wrongAttributesNumber_ShouldNotMerge() {
        let local = ["key1": "%@ %@", "key2": "%1$@ %2$@"]
        let remote = ["key1": "%@", "key2": "%1$@ %2$@ %3$@"]
        let localizableMerger = LocalizableMerger()
        let merged = localizableMerger.merge(localStrings: local, with: remote)
        XCTAssertEqual(merged, local)
    }

    func testMerger_correctAttributesNumber_ShouldMerge() {
        let local = ["key1": "%@ local %@", "key2": "%1$@ local %2$@"]
        let remote = ["key1": "%@ remote %@", "key2": "%1$@ remote %2$@"]
        let localizableMerger = LocalizableMerger()
        let merged = localizableMerger.merge(localStrings: local, with: remote)
        XCTAssertEqual(merged, remote)
    }

    func testMerger_lackRemoteKey_ShouldKeepLocalKey() {
        var local = ["key1": "hello world", "key2": "this string should survive"]
        let remote = ["key1": "hello updated world"]
        let localizableMerger = LocalizableMerger()
        let merged = localizableMerger.merge(localStrings: local, with: remote)
        local["key1"] = remote["key1"]
        XCTAssertEqual(merged, local)
    }

    func testMerger_emptyRemoteKey_ShouldKeepLocalKey() {
        let local = ["key": "this string should survive"]
        let remote = ["key": ""]
        let localizableMerger = LocalizableMerger()
        let merged = localizableMerger.merge(localStrings: local, with: remote)
        XCTAssertEqual(merged, local)
    }

    func testPerfomance_translation() {
        self.measure {
            _ = "hello_world_title".translation
        }
    }

    func testPerformance_localized() {
        self.measure {
            _ = NSLocalizedString("hello_world_title", comment: "")
        }
    }
}
