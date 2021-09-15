//
//  Error.swift
//  GraphQLPagination
//
//  Created by Juan Carlos Perez Delgadillo on 14/09/21.
//

import Foundation

enum FetchError: Error {
    case noData
    case custom(errorResult: Error)
}

extension FetchError: LocalizedError {
    var localizedDescription: String {
        switch self {
        case .noData:
            return "No data..."
            
        case .custom(let errorResult):
            return errorResult.localizedDescription
        }
    }
}
