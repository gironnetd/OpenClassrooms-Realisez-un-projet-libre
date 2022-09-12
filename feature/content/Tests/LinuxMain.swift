import XCTest

import contentTests

var tests = [XCTestCaseEntry]()
tests += contentTests.allTests()
XCTMain(tests)
