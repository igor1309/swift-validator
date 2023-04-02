//
//  Conditional.swift
//  
//
//  Created by Igor Malyarov on 02.04.2023.
//

import Foundation

extension Validators {
    
    public enum Conditional<First, Second>: Validator
    where First: Validator,
          Second: Validator,
          First.Input == Second.Input,
          First.Failure == Second.Failure {
        
        case first(First)
        case second(Second)
        
        @inlinable
        public func validate(
            _ input: First.Input
        ) -> ValidatorResult<OK, First.Failure> {
            
            switch self {
            case let .first(first):
                return first.validate(input)
                
            case let .second(second):
                return second.validate(input)
            }
        }
    }
}
