//
//  BookStoreService.swift
//  BookStore_LeonardoSoares
//
//  Created by Leonardo Soares on 17/12/22.
//

import Foundation

struct Result: Codable {
    let items: [Book]
}

class BookStoreService {
    public func getShelfData(at index: Int) {
        let queryItems: [URLQueryItem] = [
            URLQueryItem(name: "q", value: "ios"),
            URLQueryItem(name: "maxResults", value: "20"),
            URLQueryItem(name: "startIndex", value: "\(index)")
        ]
        
        if let url = buildURL(for: .volumes, with: queryItems), let apiKey = Configuration.apiKey {
            var request = URLRequest(url: url)
            request.addValue("\(apiKey)", forHTTPHeaderField: "Key")
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            request.httpMethod = "GET"
            
            URLSession.shared.dataTask(with: request) { (data, response , error) in
                guard let data = data else { return }
                
                do {
                    let results = try JSONDecoder().decode(Result.self, from: data)
                    print(results)
                } catch {
                    print(error)
                }
                print(String(data: data, encoding: .utf8) ?? "Invalid JSON")
            }.resume()
        }
    }
    
    private func buildURL(for path: Path, with queryItems: [URLQueryItem]) -> URL? {
        Endpoint(path: path, queryItems: queryItems).builtUrl
    }
}
