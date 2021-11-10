//
//  SearchViewModel.swift
//  CandyImage
//
//  Created by Matt Thomas on 07/11/2021.
//

import Foundation
import UIKit

class SearchViewModel: NSObject {
    private let api = API()
    var images = [UIImage]()

    func searchForImages(searchTerm: String, completionHandler: @escaping (Bool, Error?) -> Void) {
        api.fetchImageDataFromAPI(searchTerm: searchTerm, page: 1, completion: { result in
            switch result {
            case .success(let images):
                self.images = images
                completionHandler(true, nil)
            case .failure(let error):
                completionHandler(false, error)
            }
        })
    }
}
