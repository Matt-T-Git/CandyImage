//
//  LoadingViewController.swift
//  CandyImage
//
//  Created by Matt Thomas on 06/11/2021.
//

import UIKit

class LoadingViewController: UIViewController {
    var loadingWheel = UIActivityIndicatorView(style: .large)

    override func loadView() {
        view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 0.7)
        loadingWheel.translatesAutoresizingMaskIntoConstraints = false
        loadingWheel.startAnimating()
        view.addSubview(loadingWheel)
        loadingWheel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loadingWheel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
}
