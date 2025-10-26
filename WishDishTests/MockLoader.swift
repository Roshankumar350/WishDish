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
    let menuItems: [MenuItem]

    func load<T>(_ type: T.Type, from filename: String) throws -> T where T : Decodable {
        guard let items = menuItems as? T else {
            throw ResourceLoaderError.decodingFailed(NSError(domain: "MockLoader", code: 1))
        }
        return items
    }
}

