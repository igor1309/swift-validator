//
//  ValidatorResult.swift
//  
//
//  Created by Igor Malyarov on 02.04.2023.
//

public enum ValidatorResult<Success, Failure> {
    case valid(Success)
    case failure(Failure)
}

extension ValidatorResult: Equatable where Success: Equatable, Failure: Equatable {}
