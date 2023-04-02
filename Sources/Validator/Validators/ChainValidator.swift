//
//  ChainValidator.swift
//  
//
//  Created by Igor Malyarov on 14.03.2023.
//

extension Validator {
    
    public func chained<V: Validator>(
        with validator: V
    ) -> Validators.Chained<Self, V> {
        
        .init(first: self, second: validator)
    }
}

extension Validators {
    
    public struct Chained<First, Second>: Validator
    where First: Validator,
          Second: Validator,
          First.Input == Second.Input,
          First.Failure == Second.Failure {
        
        private let first: First
        private let second: Second
        
        public init(first: First, second: Second) {
            self.first = first
            self.second = second
        }
        
        public func validate(
            _ input: First.Input
        ) -> ValidatorResult<OK, First.Failure> {
            
            switch first.validate(input) {
            case .valid:
                return second.validate(input)
                
            case let .failure(failure):
                return .failure(failure)
            }
        }
    }
}
