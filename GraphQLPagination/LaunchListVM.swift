//
//  LaunchListVM.swift
//  GraphQLPagination
//
//  Created by Juan Carlos Perez Delgadillo on 14/09/21.
//

import Foundation

protocol LaunchListVMProtocol {
    init(pageSize: Int)
    func getAll(for lastCursor: String?, completionHandler: @escaping (Result<LaunchListByQuery.Data.Launch, FetchError>) -> Void)
}
class LaunchListVM: LaunchListVMProtocol {
    private let page: Int
    
    required init(pageSize: Int) {
        page = pageSize
    }
    
    func getAll(for lastCursor: String?, completionHandler: @escaping (Result<LaunchListByQuery.Data.Launch, FetchError>) -> Void) {
        Network.shared.apollo.fetch(query: LaunchListByQuery(pageSize: page, lastCursor: lastCursor ?? "")) { result in
            switch result {
            case .success(let graphQLResult):
                print(graphQLResult)
                
                guard  let launchesResult = graphQLResult.data?.launches else {
                    completionHandler(.failure(.noData))
                    return
                }
                completionHandler(.success(launchesResult))
                
            case .failure(let error):
                print(error)
                completionHandler(.failure(.custom(errorResult: error)))
            }
        }
    }
}
