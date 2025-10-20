//
//  MockResourceLoader.swift
//  WishDishTests
//
//  Created by Roshan Sah on 20/10/25.
//

import Foundation
@testable import WishDish

import Foundation

final class ResourceAnchor {}

struct FileBasedMockLoader: ClientResourceLoading {
    func load<T: Decodable>(_ type: T.Type, from filename: String) throws -> T {
        guard let url = Bundle(for: ResourceAnchor.self).url(forResource: filename, withExtension: "json") else {
            throw ResourceLoaderError.fileNotFound
        }

        let data = try Data(contentsOf: url)
        return try JSONDecoder().decode(T.self, from: data)
    }
}


