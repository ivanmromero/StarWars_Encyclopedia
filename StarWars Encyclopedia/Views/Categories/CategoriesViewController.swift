//
//  CategorysViewController.swift
//  StarWars Encyclopedia
//
//  Created by Ivan Romero on 08/10/2022.
//

import UIKit

class CategoriesViewController: UIViewController {
//MARK: IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
//MARK: Private Cons
    private let viewModel = CategoriesViewModel()
    
//MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
//MARK: setups
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib.init(nibName: "CategoriesTableViewCell", bundle: nil), forCellReuseIdentifier: "CategoriesCell")
    }
}

//MARK: - extension UITableViewDataSource
extension CategoriesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getCategoriesCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoriesCell", for: indexPath) as! CategoriesTableViewCell
        
        let allCategories = viewModel.getAllCategories()
        
        cell.categoriesName.text = allCategories[indexPath.row].rawValue.uppercased()
        cell.categoriesImage.image = allCategories[indexPath.row].getCategoryImage()
        
        return cell
    }
}

//MARK: - extension UITableViewDelegate
extension CategoriesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        print(viewModel.getSelectedCategory(indexPath: indexPath.row))
        let categoryDataManage = CategoryDataManageFactory.buildCategoryDataManage(typeCategory: viewModel.getSelectedCategory(indexPath: indexPath.row))
        let viewModel = CategoryViewModel(categoryDataManage: categoryDataManage)
        self.navigationController?.pushViewController(CategoryViewController(viewModel: viewModel), animated: true)
    }
}
