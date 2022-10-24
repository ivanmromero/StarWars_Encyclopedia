//
//  InformationViewController.swift
//  StarWars Encyclopedia
//
//  Created by Ivan Romero on 18/10/2022.
//

import UIKit

class DetailViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackButton()
    }
    
    private func setupBackButton() {
        let buttonItem = UIBarButtonItem()
        buttonItem.title = CategoryManager.shared.category!.rawValue
        self.navigationController?.navigationBar.topItem?.backButtonTitle = CategoryManager.shared.category!.rawValue
    }
}
