//
//  Validate.swift
//  
//
//  Created by Igor Malyarov on 02.04.2023.
//

/// A validator that attempts to run a number of validators to accumulate their outputs.
///
/// A general entry point into ``ValidatorBuilder`` syntax, which can be used to build complex validators
/// from simpler ones.
///
/// ```swift
/// let point = Validate {
///   "("
///   Int.validator()
///   ","
///   Int.validator()
///   ")"
/// }
///
/// try point.parse("(2,-4)")  // (2, -4)
///
/// try point.parse("(42,blob)")
/// // error: unexpected input
/// //  --> input:1:5
/// // 1 | (42,blob)
/// //   |     ^ expected integer
/// ```
public struct Validate<Input, Failure, Validators>: Validator
where Validators: Validator<Input, Failure>,
      Validators.Input == Input {

    public let validators: Validators
    
    /// An entry point into ``ValidatorBuilder`` syntax.
    ///
    /// Used to combine the non-void outputs from multiple validators into a single output by running
    /// each validator in sequence and bundling the results up into a tuple.
    ///
    /// For example, the following validator parses a double, skips a comma, and then parses another
    /// double before returning a tuple of each double.
    ///
    /// ```swift
    /// let coordinate = Validate {
    ///   Double.validator()
    ///   ","
    ///   Double.validator()
    /// }
    ///
    /// try coordinate.parse("1,2")  // (1.0, 2.0)
    /// ```
    ///
    /// - Parameter with: A validator builder that will accumulate non-void outputs in a tuple.
    @inlinable
    public init(
        input inputType: Input.Type = Input.self,
        @ValidatorBuilder<Input, Failure> with build: () -> Validators
    ) {
        self.validators = build()
    }
    
    /// A validator builder that bakes in a transformation of the tuple output.
    ///
    /// Equivalent to calling ``Validator/map(_:)`` on the result of a `Validate.init` builder.
    ///
    /// For example, the following validator:
    ///
    /// ```swift
    /// Validate {
    ///   Double.validator()
    ///   ","
    ///   Double.validator()
    /// }
    /// .map(Coordinate.init(x:y:))
    /// ```
    ///
    /// Can be rewritten as:
    ///
    /// ```swift
    /// Validate(Coordinate.init(x:y:)) {
    ///   Double.validator()
    ///   ","
    ///   Double.validator()
    /// }
    /// ```
    ///
    /// - Parameters:
    ///   - transform: A transform to apply to the output of the validator builder.
    ///   - with: A validator builder that will accumulate non-void outputs in a tuple.
//    @inlinable
//    public init<Upstream, NewOutput>(
//        input inputType: Input.Type = Input.self,
//        _ transform: @escaping (Upstream.Output) -> NewOutput,
//        @ValidatorBuilder<Input> with build: () -> Upstream
//    ) where Validators == Validators.Map<Upstream, NewOutput> {
//        self.validators = build().map(transform)
//    }
    
    
    @inlinable
    public func validate(
        _ input: Input
    ) -> ValidatorResult<OK, Failure> {
        
        self.validators.validate(input)
    }
}
