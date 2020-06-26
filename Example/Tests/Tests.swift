import XCTest
@testable import Faberbabel

class Tests: XCTestCase {

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testMerger_wrongAttributesNumber_ShouldNotMerge() {
        let local: NSDictionary = ["key1": "%@ %@", "key2": "%1$@ %2$@"]
        let remote: NSDictionary = ["key1": "%@", "key2": "%1$@ %2$@ %3$@"]
        let localizableMerger = LocalizableMerger()
        let merged = localizableMerger.merge(localStrings: local, with: remote)
        XCTAssertEqual(merged, local)
    }

    func testMerger_correctAttributesNumber_ShouldMerge() {
        let local: NSDictionary = ["key1": "%@ local %@", "key2": "%1$@ local %2$@"]
        let remote: NSDictionary = ["key1": "%@ remote %@", "key2": "%1$@ remote %2$@"]
        let localizableMerger = LocalizableMerger()
        let merged = localizableMerger.merge(localStrings: local, with: remote)
        XCTAssertEqual(merged, remote)
    }

    func testMerger_lackRemoteKey_ShouldKeepLocalKey() {
        let local: NSDictionary = ["key1": "hello world", "key2": "this string should survive"]
        let remote: NSDictionary = ["key1": "hello updated world"]
        let localizableMerger = LocalizableMerger()
        let merged = localizableMerger.merge(localStrings: local, with: remote)
        let awaitedResult = NSMutableDictionary(dictionary: local)
        awaitedResult["key1"] = remote["key1"]
        XCTAssertEqual(merged, awaitedResult)
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
