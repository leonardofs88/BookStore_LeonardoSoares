//
//  Endpoint.swift
//  BookStore_LeonardoSoares
//
//  Created by Leonardo Soares on 18/12/22.
//

import Foundation

enum Path: String {
    case books = "/books"
    case eBooks = "/ebooks"
    case volumes = "/volumes"
}

enum Scheme: String {
    case http
    case https
}

struct Endpoint {
    let path: Path
    let queryItems: [URLQueryItem]?
    let icon: String?
    
    init(path: Path, queryItems: [URLQueryItem]? = nil, icon: String? = nil) {
        self.path = path
        self.queryItems = queryItems
        self.icon = icon
    }
    
    var builtUrl: URL? {
        var components = URLComponents()
        components.scheme = Scheme.https.rawValue
        components.host = Configuration.baseURL
        components.path = Configuration.apiVersion + path.rawValue
        components.queryItems = queryItems
        return components.url
    }
}
