//
//  Validator.swift
//
//
//  Created by Igor Malyarov on 14.03.2023.
//

#if swift(>=5.7)
public protocol Validator<Input, Failure> {
    
    /// The type of values this validator can validate.
    associatedtype Input
    
    /// The type of failures produced by this validator.
    associatedtype Failure
    
    /// Attempts to validate a piece of data producing failure.
    /// Typically
    /// you only call this from other `Parser` conformances, not when you want to parse a concrete
    /// input.
    ///
    /// - Parameter input: A piece of data to be validated.
    /// - Returns: Result of validation, either Void in case of successful validation, or failure other.
    func validate(_ input: Input) -> ValidatorResult<OK, Failure>
}
#else
public protocol Validator {
    
    associatedtype Input
    associatedtype Failure
    
    func validate(_ input: Input) -> ValidatorResult<OK, Failure>
}
#endif
