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
    func loadAsync<T: Decodable>(_ type: T.Type, from urlString: String) async throws -> T
}

extension ClientResourceLoading {
    func loadAsync<T: Decodable>(_ type: T.Type, from urlString: String) async throws -> T {
        throw NSError(domain: "Not implemented", code: 0, userInfo: nil) as? Error  ?? URLError(.badURL)
    }
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
    
    func loadAsync<T: Decodable>(_ type: T.Type, from urlString: String) async throws -> T {
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }
        
        return try JSONDecoder().decode(T.self, from: data)
    }
}
