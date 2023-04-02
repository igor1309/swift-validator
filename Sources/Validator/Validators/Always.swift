//
//  Always.swift
//  
//
//  Created by Igor Malyarov on 02.04.2023.
//

public struct Always<Input, Failure>: Validator {
    
    public init() {}

    public func validate(_ input: Input) -> ValidatorResult<OK, Failure> {
        
        .valid(.init())
    }
}
