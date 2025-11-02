//
//  MockResourceLoader.swift
//  WishDishTests
//
//  Created by Roshan Sah on 20/10/25.
//

import Foundation
@testable import WishDish

final class ResourceAnchor {}

struct FileBasedMockLoader: ClientResourceLoading {
    func loadAsync<T>(_ type: T.Type, from urlString: String) async throws -> T where T : Decodable {
        let result = try await withCheckedThrowingContinuation { continuation in
            do {
                let result = try self.load(type, from: urlString)
                continuation.resume(returning: result)
            } catch {
                continuation.resume(throwing: error)
            }
        }
        return result
    }
    
    func load<T: Decodable>(_ type: T.Type, from filename: String) throws -> T {
        guard let url = Bundle(for: ResourceAnchor.self).url(forResource: filename, withExtension: "json") else {
            throw ResourceLoaderError.fileNotFound
        }

        let data = try Data(contentsOf: url)
        return try JSONDecoder().decode(T.self, from: data)
    }
}


