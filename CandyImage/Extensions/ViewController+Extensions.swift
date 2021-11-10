//
//  ViewController+Extensions.swift
//  CandyImage
//
//  Created by Matt Thomas on 06/11/2021.
//

import UIKit

extension UIViewController {

    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true)
    }

    func showLoadingView(loadingVC: LoadingViewController) {
        addChild(loadingVC)
        loadingVC.view.frame = view.frame
        view.addSubview(loadingVC.view)
        loadingVC.didMove(toParent: self)
    }

    func removeLoadingView(loadingVC: LoadingViewController) {
        loadingVC.willMove(toParent: nil)
        loadingVC.view.removeFromSuperview()
        loadingVC.removeFromParent()
    }

    @objc func resignKeyboard(_: Any) {
        view.endEditing(true)
    }
}
