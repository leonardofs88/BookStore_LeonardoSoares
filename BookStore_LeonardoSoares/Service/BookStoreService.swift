//
//  BookStoreService.swift
//  BookStore_LeonardoSoares
//
//  Created by Leonardo Soares on 17/12/22.
//

import Foundation
import UIKit

struct GatheredData: Codable {
    let items: [Book]
}

class BookStoreService {
    public func getShelfData(at index: Int, result: @escaping (Result<[Book], Error>) -> ()) {
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
                    let results = try JSONDecoder().decode(GatheredData.self, from: data)
                    result(.success(results.items))
                } catch {
                    result(.failure(error))
                }
            }.resume()
        }
    }
    
    func getImage(from url: URL, results: @escaping (Result<UIImage, Error>) -> ()) {
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let imageData = data, let result =  UIImage(data: imageData) {
                    results(.success(result))
                }
                
                if let err = error {
                    results(.failure(err))
                }
            }.resume()
        }
    
    private func buildURL(for path: Path, with queryItems: [URLQueryItem]) -> URL? {
        Endpoint(path: path, queryItems: queryItems).builtUrl
    }
}
