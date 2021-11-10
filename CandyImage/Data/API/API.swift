//
//  API.swift
//  CandyImage
//
//  Created by Matt Thomas on 06/11/2021.
//

import Foundation
import UIKit.UIImage

struct API {
    private static let baseURL = "https://pixabay.com/api/"
    private static let apiKey = "13197033-03eec42c293d2323112b4cca6"
    private let cache = ImageCache.shared
    private let session: URLSession

    init(urlSession: URLSession = .shared) {
        self.session = urlSession
    }

    static func imageSearchURL(withUserSearchTerm searchTerms: String?, page: String) -> URL {
        guard let searchParameterString = searchTerms else {
            return apiURL(parameters: ["q": ""])
        }
        let searchParameters = ["q": searchParameterString, "page": page]
        return apiURL(parameters: searchParameters)
    }

    private static func apiURL(parameters: [String:String]?) -> URL {
        var components = URLComponents(string: baseURL)!
        var queryItems = [URLQueryItem]()
        let baseParams = [
            "key": apiKey,
            "image_type": "photo",
            "per_page": "10"
        ]

        for (key, value) in baseParams {
            let item = URLQueryItem(name: key, value: value)
            queryItems.append(item)
        }

        if let additionalParams = parameters {
            for (key, value) in additionalParams {
                let item = URLQueryItem(name: key, value: value)
                queryItems.append(item)
            }
        }
        components.queryItems = queryItems
        return components.url!
    }

    func fetchImageDataFromAPI(searchTerm: String, page: Int, completion: @escaping (Result<[UIImage], APIError>) -> Void) {
        if let cachedImages = cache[searchTerm + String(page)] {
            completion(.success(cachedImages))
            return
        }

        let url = API.imageSearchURL(withUserSearchTerm: searchTerm, page: String(page))
        let request = URLRequest(url: url)
        let task = session.dataTask(with: request) {
            (data, response, error) -> Void in

            if let jsonData = data {
                do {
                    let jsonDecoder = JSONDecoder()
                    let images = try jsonDecoder.decode(Images.self, from: jsonData)
                    var imageURLs = [URL]()
                    for image in images.hits {
                        imageURLs.append(image.previewURL)
                    }
                    DispatchQueue.main.sync {
                        completion(.success((downloadImagesForTerm(searchTerm: searchTerm, page: String(page), urls: imageURLs))))
                    }
                } catch {
                    DispatchQueue.main.async {
                        print()
                        completion(.failure(.parsingError))
                    }
                }
            } else if error != nil {
                DispatchQueue.main.async {
                    completion(.failure(.networkError))
                }
            } else {
                DispatchQueue.main.async {
                    completion(.failure(.unknownError))
                }
            }
        }
        task.resume()
    }

    private func downloadImagesForTerm(searchTerm: String, page: String, urls: [URL]) -> [UIImage] {
        var imageArray = [UIImage]()
        for url in urls {
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    imageArray.append(image)
                }
            }
        }
        self.cache[searchTerm+page] = imageArray
        return imageArray
    }
}
