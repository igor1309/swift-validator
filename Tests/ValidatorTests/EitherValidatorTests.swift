//
//  EitherValidatorTests.swift
//  
//
//  Created by Igor Malyarov on 14.03.2023.
//

import Validator
import XCTest

final class EitherValidatorTests: XCTestCase {
    
    func test_bothInvalid_shouldReturnInvalid() {
        
        let first = Validators.MinLengthValidator(minLength: 4)
        let second = Validators.MinLengthValidator(minLength: 6)
        let either = EitherValidator(first: first, second: second)
        let either2 = first.either(second)

        XCTAssertEqual(first.validate("aaa"), .failure(.tooShort))
        XCTAssertEqual(second.validate("aaaaa"), .failure(.tooShort))
        XCTAssertEqual(either.validate(("aaa", "aaaaa")), .failure(.tooShort))
        XCTAssertEqual(either2.validate(("aaa", "aaaaa")), .failure(.tooShort))
    }
    
    func test_firstValid_shouldReturnValid() {
        
        let first = Validators.MinLengthValidator(minLength: 4)
        let second = Validators.MinLengthValidator(minLength: 6)
        let either = EitherValidator(first: first, second: second)
        let either2 = first.either(second)

        XCTAssertEqual(first.validate("aaaa"), .valid(.init()))
        XCTAssertEqual(second.validate("aaaaa"), .failure(.tooShort))
        XCTAssertEqual(either.validate(("aaaa", "aaaaa")), .valid(.init()))
        XCTAssertEqual(either2.validate(("aaaa", "aaaaa")), .valid(.init()))
    }
    
    func test_secondValid_shouldReturnValid() {
        
        let first = Validators.MinLengthValidator(minLength: 4)
        let second = Validators.MinLengthValidator(minLength: 6)
        let either = EitherValidator(first: first, second: second)
        let either2 = first.either(second)

        XCTAssertEqual(first.validate("aaa"), .failure(.tooShort))
        XCTAssertEqual(second.validate("aaaaaa"), .valid(.init()))
        XCTAssertEqual(either.validate(("aaaa", "aaaaa")), .valid(.init()))
        XCTAssertEqual(either2.validate(("aaaa", "aaaaa")), .valid(.init()))
    }
    
    func test_bothValid_shouldReturnValid() {
        
        let first = Validators.MinLengthValidator(minLength: 4)
        let second = Validators.MinLengthValidator(minLength: 6)
        let either = EitherValidator(first: first, second: second)
        let either2 = first.either(second)

        XCTAssertEqual(first.validate("aaaa"), .valid(.init()))
        XCTAssertEqual(second.validate("aaaaaa"), .valid(.init()))
        XCTAssertEqual(either.validate(("aaaa", "aaaaa")), .valid(.init()))
        XCTAssertEqual(either2.validate(("aaaa", "aaaaa")), .valid(.init()))
    }
}
