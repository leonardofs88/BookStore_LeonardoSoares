//
//  Config.swift
//  BookStore_LeonardoSoares
//
//  Created by Leonardo Soares on 18/12/22.
//

import Foundation
enum Configuration {
    
    static let baseURL = "www.googleapis.com"
    static let apiVersion = "/books/v1"
    static let apiKey = info["API_KEY"] as? String
    
    private static var info : [String: Any] {
        if let dict = Bundle.main.infoDictionary {
              return dict
          } else {
              fatalError("Info Plist file not found")
          }
    }
}
