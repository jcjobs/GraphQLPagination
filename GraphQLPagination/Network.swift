//
//  Network.swift
//  GraphQLPagination
//
//  Created by Juan Carlos Perez Delgadillo on 14/09/21.
//

import Apollo

class Network {
    static let shared = Network()
    lazy var apollo = ApolloClient(url: URL(string: "https://apollo-fullstack-tutorial.herokuapp.com/")!)
    
    private init() { }
}
