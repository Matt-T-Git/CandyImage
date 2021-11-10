//
//  ResultsViewModel.swift
//  CandyImage
//
//  Created by Matt Thomas on 06/11/2021.
//

import Foundation
import UIKit

class ResultsViewModel: NSObject, UICollectionViewDelegate, UICollectionViewDataSource {
    private let reuseIdentifier = "ResultsCell"
    private let api = API()
    private var currentPage = 1
    var images = [UIImage]()
    var termSearched = ""

    func loadMoreImages(completionHandler: @escaping (Bool, Error?) -> Void) {
        currentPage += 1
        api.fetchImageDataFromAPI(searchTerm: termSearched, page: currentPage, completion: { result in
            switch result {
            case .success(let images):
                self.images += images
                completionHandler(true, nil)
            case .failure(let error):
                completionHandler(false, error)
            }
        })
    }

    func registerCells(collectionView: UICollectionView) {
        collectionView.register(ResultsCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ResultsCell
        cell.imageView.image = images[indexPath.row]
        return cell
    }
}
