//
//  ViewController.swift
//  CandyImage
//
//  Created by Matt Thomas on 06/11/2021.
//

import UIKit

class SearchViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var searchTextField: UITextField!
    private let loadingView = LoadingViewController()
    private let viewModel = SearchViewModel()

    override func viewDidLoad() {
        title = "Search"
        searchTextField.delegate = self
        addKeyboardResignTap()
        super.viewDidLoad()
    }
    
    private func addKeyboardResignTap() {
        let resignKeyboardTap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.resignKeyboard(_:)))
        view.addGestureRecognizer(resignKeyboardTap)
    }

    @IBAction func performSearch(_: Any) {
        guard searchTextField.hasText else {
            showAlert(title: "Error!", message: "Please enter a search term")
            return
        }

        if let searchTerm = searchTextField.text {
            searchTextField.text = nil
            resignKeyboard(self)
            showLoadingView(loadingVC: loadingView)
            viewModel.searchForImages(searchTerm: searchTerm, completionHandler: { result, error  in
                guard error == nil else {
                    self.removeLoadingView(loadingVC: self.loadingView)
                    self.showAlert(title: "Error!", message: error?.localizedDescription ?? "An error occured.")
                    return
                }
                self.showResultsController(searchTerm: searchTerm)
            })
        }
    }

    private func showResultsController(searchTerm: String) {
        let resultsViewController: ResultsViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ResultsVC") as! ResultsViewController
        resultsViewController.viewModel.images = self.viewModel.images
        resultsViewController.viewModel.termSearched = searchTerm
        self.removeLoadingView(loadingVC: self.loadingView)
        self.navigationController?.pushViewController(resultsViewController, animated: true)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        performSearch(self)
        resignKeyboard(self)
        return true
    }
}
