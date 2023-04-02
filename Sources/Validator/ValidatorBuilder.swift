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
}
