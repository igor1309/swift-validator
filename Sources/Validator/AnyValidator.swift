//
//  AnyValidator.swift
//  
//
//  Created by Igor Malyarov on 14.03.2023.
//

#if swift(<5.7)
public struct AnyValidator<Input, Failure>: Validator {

    private let _validate: (Input) -> ValidatorResult<OK, Failure>
    
    public init<V>(validator: V)
    where V: Validator, V.Input == Input, V.Failure == Failure {
        
        self._validate = validator.validate
    }
    
    public func validate(_ input: Input) -> ValidatorResult<OK, Failure> {
        
        _validate(input)
    }
    
}

extension Validator {
    
    @inlinable
    func eraseToAnyValidator() -> AnyValidator<Input, Failure> {
        .init(validator: self)
    }
}
#endif
