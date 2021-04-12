//
//  ServiceResult.swift
//  TechnicalTask
//
//  Created by Viacheslav Markov on 11.04.2021.
//

import Foundation

public enum ServiceResult<Value, Error: Swift.Error> {
    case success(Value)
    case failure(Error)
}
