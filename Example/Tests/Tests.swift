import XCTest
import Faberbabel

class Tests: XCTestCase {

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
