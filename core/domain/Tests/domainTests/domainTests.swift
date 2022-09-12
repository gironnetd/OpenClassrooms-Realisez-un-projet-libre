import XCTest
@testable import domain

final class domainTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(domain().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
