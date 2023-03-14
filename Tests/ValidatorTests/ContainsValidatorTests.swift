//
//  ContainsValidatorTests.swift
//  
//
//  Created by Igor Malyarov on 14.03.2023.
//

import Validator
import XCTest

class ContainsValidatorTests: XCTestCase {
    
    func test_contains() {
        
        let expected = "Summer"
        let containsValidator = Validators.ContainsValidator(
            start: 5,
            expected: expected
        )
        
        XCTAssertEqual(
            containsValidator.validate("This Summer"),
            .valid(.init())
        )
        XCTAssertEqual(
            containsValidator.validate("This summer"),
            .failure(.init("Input \"This summer\" does not contain \"Summer\" starting from 5"))
        )
        XCTAssertEqual(
            containsValidator.validate("This summ"),
            .failure(.init("Input \"This summ\" does not contain \"Summer\" starting from 5"))
        )
    }
}
