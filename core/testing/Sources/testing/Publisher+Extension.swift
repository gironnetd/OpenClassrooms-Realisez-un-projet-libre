//
//  File.swift
//  
//
//  Created by damien on 19/09/2022.
//

import Foundation
import Combine
import XCTest

extension Publisher {
    
    public func waitingCompletion(for timeout: TimeInterval = 30.0, file: StaticString = #file, line: UInt = #line) throws -> [Output] {
        let expectation = XCTestExpectation(description: "wait for completion")
        var completion: Subscribers.Completion<Failure>?
        var output = [Output]()

        let subscription = self.collect()
            .sink(receiveCompletion: { receiveCompletion in
                completion = receiveCompletion
                expectation.fulfill()
            }, receiveValue: { value in
                output = value
            })

        XCTWaiter().wait(for: [expectation], timeout: timeout)
        subscription.cancel()

        // We're also including a more meaningful error here!
        switch try XCTUnwrap(completion, "Publisher never completed", file: file, line: line) {
        case let .failure(error):
            throw error
        case .finished:
            return output
        }
    }
}
