// swift-tools-version: 5.4

import PackageDescription

let package = Package(
    name: "swift-validator",
    products: [
        .validator,
    ],
    targets: [
        .validator,
        .validatorTests,
    ]
)

private extension Product {
    
    static let validator = library(
        name: .validator,
        targets: [
            .validator
        ]
    )
}

private extension Target {
    
    
    static let validator = target(name: .validator)
    static let validatorTests = testTarget(
        name: .validatorTests,
        dependencies: [
            .validator
        ]
    )
}

private extension Target.Dependency {
    
    static let validator = byName(name: .validator)
}

private extension String {
    
    static let validator = "Validator"
    static let validatorTests = "ValidatorTests"
}
