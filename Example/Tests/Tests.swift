import XCTest
@testable import Faberbabel

// swiftlint:disable implicitly_unwrapped_optional

class MemoryEventLogger: EventLogger {

    var notifiedEvents: [Event] = []

    // MARK: - EventLogger

    func log(_ events: [Event]) {
        notifiedEvents.append(contentsOf: events)
    }
}

class Tests: XCTestCase {

    var localizableMerger: LocalizableMerger!

    override func setUp() {
        super.setUp()
        let logger = MemoryEventLogger()
        localizableMerger = LocalizableMerger(eventLogger: logger)
    }

    func testMerger_wrongAttributesNumber_ShouldNotMerge() {
        let local = ["key1": "%@ %@", "key2": "%1$@ %2$@"]
        let remote = ["key1": "%@", "key2": "%1$@ %2$@ %3$@"]
        let merged = localizableMerger.merge(localStrings: local, with: remote)
        XCTAssertEqual(merged, local)
    }

    func testMerger_correctAttributesNumber_ShouldMerge() {
        let local = ["key1": "%@ local %@", "key2": "%1$@ local %2$@"]
        let remote = ["key1": "%@ remote %@", "key2": "%1$@ remote %2$@"]
        let merged = localizableMerger.merge(localStrings: local, with: remote)
        XCTAssertEqual(merged, remote)
    }

    func testMerger_lackRemoteKey_ShouldKeepLocalKey() {
        var local = ["key1": "hello world", "key2": "this string should survive"]
        let remote = ["key1": "hello updated world"]
        let merged = localizableMerger.merge(localStrings: local, with: remote)
        local["key1"] = remote["key1"]
        XCTAssertEqual(merged, local)
    }

    func testMerger_emptyRemoteKey_ShouldKeepLocalKey() {
        let local = ["key": "this string should survive"]
        let remote = ["key": ""]
        let merged = localizableMerger.merge(localStrings: local, with: remote)
        XCTAssertEqual(merged, local)
    }

    func testPerfomance_translation() {
        self.measure {
            _ = "hello_world_title".fb_translation
        }
    }

    func testPerformance_localized() {
        self.measure {
            _ = NSLocalizedString("hello_world_title", comment: "")
        }
    }
}
