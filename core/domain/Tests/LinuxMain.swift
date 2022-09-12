import XCTest

import domainTests

var tests = [XCTestCaseEntry]()
tests += domainTests.allTests()
XCTMain(tests)
