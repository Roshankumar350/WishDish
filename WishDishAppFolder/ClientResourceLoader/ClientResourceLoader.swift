//
//  ClientResourceLoader.swift
//  WishDish
//
//  Created by Roshan Sah on 20/10/25.
//

import Foundation

enum ResourceLoaderError: Error {
    case fileNotFound
    case decodingFailed(Error)
}

protocol ClientResourceLoading {
    func load<T: Decodable>(_ type: T.Type, from filename: String) throws -> T
}

struct ClientResourceLoader: ClientResourceLoading {
    func load<T: Decodable>(_ type: T.Type, from filename: String) throws -> T {
        guard let url = Bundle.main.url(forResource: filename, withExtension: "json") else {
            throw ResourceLoaderError.fileNotFound
        }

        do {
            let data = try Data(contentsOf: url)
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw ResourceLoaderError.decodingFailed(error)
        }
    }
}
