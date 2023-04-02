//
//  EitherValidator.swift
//  
//
//  Created by Igor Malyarov on 14.03.2023.
//

extension Validator {
    
    public func either<V: Validator>(
        _ validator: V
    ) -> EitherValidator<Self, V> {
        
        .init(first: self, second: validator)
    }
}

public struct EitherValidator<First, Second>: Validator
where First: Validator,
      Second: Validator,
      First.Failure == Second.Failure {
    
    private let first: First
    private let second: Second
    
    public init(first: First, second: Second) {
        self.first = first
        self.second = second
    }
    
    public func validate(
        _ input: (First.Input, Second.Input)
    ) -> ValidatorResult<OK, First.Failure> {
        
        switch first.validate(input.0) {
        case .valid:
            return .valid(.init())
            
        case .failure:
            return second.validate(input.1)
        }
    }
}
