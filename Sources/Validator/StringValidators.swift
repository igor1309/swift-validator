//
//  StringValidators.swift
//  
//
//  Created by Igor Malyarov on 14.03.2023.
//

import Foundation

#if swift(>=5.7)
public typealias StringValidator = Validator<String, ValidationError>
#endif

public struct ValidationError: LocalizedError, Equatable {
    
    private let message: String
    
    public init(_ message: String) {
        self.message = message
    }
    
    public var errorDescription: String? {
        message
    }
}

public extension ValidationError {
    
    static let tooShort: Self = .init("Too short.")
    static let tooLong: Self = .init("Too long.")
}

extension Validators {
    
    public struct MinLengthValidator: Validator {
        
        private let minLength: Int
        
        public init(minLength: Int) {
            self.minLength = minLength
        }
        
        public func validate(
            _ input: String
        ) -> ValidatorResult<OK, ValidationError> {
            
            input.count >= minLength ? .valid(.init()) : .failure(.tooShort)
        }
    }
    
    public struct MaxLengthValidator: Validator {
        
        private let maxLength: Int
        
        init(maxLength: Int) {
            self.maxLength = maxLength
        }
        
        public func validate(
            _ input: String
        ) -> ValidatorResult<OK, ValidationError> {
            
            input.count <= maxLength ? .valid(.init()) : .failure(.tooLong)
        }
    }
    
    public struct MinMaxLengthValidator: Validator {
        
        private let chainedValidator: ChainValidator<MinLengthValidator, MaxLengthValidator>
        
        public init(minLength: Int, maxLength: Int) {
            
            self.chainedValidator = ChainValidator(
                first: MinLengthValidator(minLength: minLength),
                second: MaxLengthValidator(maxLength: maxLength)
            )
        }
        
        public func validate(
            _ input: String
        ) -> ValidatorResult<OK, ValidationError> {
            
            chainedValidator.validate(input)
        }
    }
    
    public struct ContainsValidator: Validator {
        
        private let start: UInt
        private let expected: String
        
        public init(start: UInt, expected: String) {
            self.start = start
            self.expected = expected
        }
        
        public func validate(
            _ input: String
        ) -> ValidatorResult<OK, ValidationError> {
            
            let result: Bool = {
                let minimumLength = Int(start) + expected.count
                
                guard input.count >= minimumLength else {
                    return false
                }
                
                let rangeStart = String.Index(utf16Offset: Int(start), in: input)
                let rangeEnd = String.Index(utf16Offset: minimumLength, in: input)
                let characterInRange = input[rangeStart..<rangeEnd]
                
                return characterInRange == expected
            }()
            
            
            if result {
                return .valid(.init())
            } else {
                return .failure(.init("Input \"\(input)\" does not contain \"\(expected)\" starting from \(start)"))
            }
        }
    }
    
    public struct RegExValidator: Validator {
        
        private let regEx: String
        
        public init(regEx: String) {
            self.regEx = regEx
        }
        
        public func validate(
            _ input: String
        ) -> ValidatorResult<OK, ValidationError> {
            
            let predicate = NSPredicate(format:"SELF MATCHES %@", regEx)
            if predicate.evaluate(with: input) {
                return .valid(.init())
            } else {
                return .failure(.init("Does not match regEx \"\(regEx)\""))
            }
        }
    }
}
