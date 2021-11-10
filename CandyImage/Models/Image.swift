//
//  Image.swift
//  CandyImage
//
//  Created by Matt Thomas on 06/11/2021.
//

import Foundation

class Image: Decodable {
    let id: Int
    let type: String
    let tags: String
    let user: String
    let user_id: Int
    let pageURL: URL
    let previewURL: URL
    let previewHeight: Int
    let previewWidth: Int
    let webformatURL: URL
    let webformatHeight: Int
    let webformatWidth: Int
    let largeImageURL: URL
    let imageHeight: Int
    let imageWidth: Int
}
