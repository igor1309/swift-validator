//
//  ValidatorBuilder.swift
//  
//
//  Created by Igor Malyarov on 02.04.2023.
//

/// A custom parameter attribute that constructs validators from closures.
/// The constructed validator runs a number of validators, one after the other,
/// and accumulates their outputs.
///
/// The ``Validate``validator acts as an entry point into `@ValidatorBuilder` syntax,
/// where you can list all of the parsers you want to run.
/// For example, to validate ????????????????? /two comma-separated integers/:
/// - Warning:THE FOLLOWING EXAMPLE SHOULD BE REWRITTEN
/// ```swift
/// try Validate {
///   ???????? Int.parser()
///   ?????? ","
///   ??????? Int.parser()
/// }
/// .validate("123,456") // (123, 456)
/// ```
@resultBuilder
public enum ValidatorBuilder<Input, Failure> {
    
    @inlinable
    public static func buildBlock() -> Always<Input, Failure> {
        
        Always<Input, Failure>()
    }
    
    @inlinable
    public static func buildBlock<V: Validator>(
        _ validator: V
    ) -> V where V.Input == Input {
        
        validator
    }
    
    /// Provides support for `if`-`else` statements in ``ValidatorBuilder`` blocks, producing a
    /// conditional validator for the `if` branch.
    ///
    /// ```swift
    /// Validate {
    ///   "Hello"
    ///   if shouldParseComma {
    ///     ", "
    ///   } else {
    ///     " "
    ///   }
    ///   Rest()
    /// }
    /// ```
    @inlinable
    public static func buildEither<TrueValidator, FalseValidator>(
        trueValidator: TrueValidator
    ) -> Validators.Conditional<TrueValidator, FalseValidator>
    where TrueValidator.Input == Input, FalseValidator.Input == Input {
        
        .first(trueValidator)
    }
    
    @inlinable
    public static func buildEither<TrueValidator, FalseValidator>(
        falseValidator: FalseValidator
    ) -> Validators.Conditional<TrueValidator, FalseValidator>
    where TrueValidator.Input == Input, FalseValidator.Input == Input {
        
        .second(falseValidator)
    }
    
    //    @inlinable
    //    public static func buildArray<V>(
    //        _ validators: V...
    //    ) -> any Validator
    //    where V: Validator {
    //
    //        guard let first = validators.first
    //        else {
    //            return Always<V.Input, V.Failure>()
    //        }
    //
    //        return Validators.Chained(first: first, second: Array(validators.dropFirst()))
    //    }
    
    @inlinable
    public static func buildBlock<V0, V1>(
        _ validator0: V0,
        _ validator1: V1
    ) -> some Validator
    where V0: Validator,
          V1: Validator,
          V0.Input == V1.Input,
          V0.Failure == V1.Failure
    {
        
        Validators.Chained(first: validator0, second: validator1)
    }
    
    @inlinable
    public static func buildBlock<V0, V1, V2>(
        _ validator0: V0,
        _ validator1: V1,
        _ validator2: V2
    ) -> some Validator
    where V0: Validator,
          V1: Validator,
          V2: Validator,
          V0.Input == V1.Input,
          V1.Input == V2.Input,
          V0.Failure == V1.Failure,
          V1.Failure == V2.Failure
    {
        Validators.Chained(
            first: validator0,
            second: Validators.Chained(
                first: validator1,
                second: validator2
            )
        )
    }
}

@ValidatorBuilder<String, ValidationError>
func minMaxValidator() -> some Validator {
    
    Validators.MinLengthValidator(minLength: 2)
    Validators.MaxLengthValidator(maxLength: 10)
    
}

@ValidatorBuilder<String, ValidationError>
func minMaxContainsValidator() -> some Validator {
    
    Validators.MinLengthValidator(minLength: 2)
    Validators.MaxLengthValidator(maxLength: 10)
    Validators.ContainsValidator(start: 0, expected: "aaa")
}
