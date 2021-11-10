//
//  APIError.swift
//  CandyImage
//
//  Created by Matt Thomas on 08/11/2021.
//

import Foundation

enum APIError: String, LocalizedError {
    case parsingError = "Error creating JSON object"
    case networkError = "Error fetching images"
    case unknownError = "Unexpected error with the request"
    var errorDescription: String? {
        rawValue
    }
}
