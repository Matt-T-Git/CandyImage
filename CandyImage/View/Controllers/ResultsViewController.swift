//
//  ResultsViewController.swift
//  CandyImage
//
//  Created by Matt Thomas on 06/11/2021.
//

import UIKit

class ResultsViewController: UICollectionViewController {
    let viewModel = ResultsViewModel()
    private let loadingView = LoadingViewController()

    override func viewDidLoad() {
        title = "Gallery"

        collectionView.dataSource = viewModel
        collectionView.delegate = viewModel
        viewModel.registerCells(collectionView: collectionView)

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Find More", style: .plain, target: self, action: #selector(loadMore))
        addConstraints()

        if viewModel.images.isEmpty {
            showAlert(title: "Results", message: "No images found for \(viewModel.termSearched)")
        }
        super.viewDidLoad()
    }

    private func addConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: self.view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
    }

    @objc private func loadMore() {
        showLoadingView(loadingVC: loadingView)
        viewModel.loadMoreImages(completionHandler: { result, error in
            guard error == nil else {
                self.removeLoadingView(loadingVC: self.loadingView)
                self.showAlert(title: "Error!", message: error?.localizedDescription ?? "An error occured.")
                return
            }
            self.removeLoadingView(loadingVC: self.loadingView)
            self.collectionView.reloadData()
        })
    }
}
