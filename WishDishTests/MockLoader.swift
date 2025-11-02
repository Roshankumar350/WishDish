//
//  MockLoader.swift
//  WishDishTests
//
//  Created by Nidhi Kumari on 26/10/25.
//

import Testing
@testable import WishDish
import Foundation

struct MockLoader: ClientResourceLoading {
    
    let menuItems: [MenuList.MenuItem]

    func load<T>(_ type: T.Type, from filename: String) throws -> T where T : Decodable {
        let wrapped = MenuList(items: menuItems, meta: .init(page: 0, limit: 50, total: 41))
        guard let result = wrapped as? T else {
            throw ResourceLoaderError.decodingFailed(NSError(domain: "MockLoader", code: 1))
        }
        return result
    }
    
    func loadAsync<T>(_ type: T.Type, from urlString: String) async throws -> T where T : Decodable {
        let wrapped = MenuList(items: menuItems, meta: .init(page: 0, limit: 50, total: 41))
        guard let result = wrapped as? T else {
            throw ResourceLoaderError.decodingFailed(NSError(domain: "MockLoader", code: 1))
        }
        return result
    }
}

