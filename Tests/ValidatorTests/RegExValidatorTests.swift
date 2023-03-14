//
//  RegExValidatorTests.swift
//  
//
//  Created by Igor Malyarov on 14.03.2023.
//

import Validator
import XCTest

class RegExValidatorTests: XCTestCase {

    func test_regex() {
        
        let regEx = "^[\\s\\-_\\.a-zA-ZА-Яа-яЁё]+$"
        let regExValidator = Validators.RegExValidator(regEx: regEx)
        
        XCTAssertEqual(
            regExValidator.validate("Ann Mary Jane"),
            .valid(.init())
        )
        XCTAssertEqual(
            regExValidator.validate("Ann Mary Jane 3"),
            .failure(.init("Does not match regEx \"\(regEx)\""))
        )
    }
}
