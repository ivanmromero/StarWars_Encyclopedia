//
//  CategoryViewController.swift
//  StarWars Encyclopedia
//
//  Created by Ivan Romero on 08/10/2022.
//

import UIKit
import iProgressHUD

class CategoryViewController: UIViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var viewModel: CategoryViewModel = CategoryViewModel()
    private let iprogress: iProgressHUD = iProgressHUD()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchBar()
        setupCollectionView()
        setupCategoryLabel()
        setupBackButton()
        setupSpinner()
        viewModel.getData {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    private func setupSpinner() {
        iprogress.captionSize = 25
        iprogress.isShowModal = false
        iprogress.isShowBox = false
        iprogress.iprogressStyle = .horizontal
        iprogress.indicatorStyle = .ballRotateChase
        iprogress.indicatorSize = 90
        iprogress.alphaModal = 0.7
        iprogress.captionDistance = 10
        iprogress.indicatorColor = UIColor(named: "StarWarsColor")!
        iprogress.attachProgress(toView: self.collectionView)

        collectionView.showProgress()
    }
    
    private func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: "CategoryCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CategoryCell")
    }
    
    private func setupSearchBar() {
        searchBar.searchTextField.backgroundColor = .black
        searchBar.searchTextField.textColor = UIColor(named: "StarWarsColor")
        searchBar.placeholder = "Find your favorite \(CategoryManager.shared.category!.getSingularCategoriesRawValue())"
        searchBar.searchTextField.clearButtonMode = .never
        searchBar.delegate = self
    }
    
    private func setupCategoryLabel() {
        categoryLabel.text = CategoryManager.shared.category?.rawValue
    }
    
    private func setupBackButton() {
        let backButton = UIBarButtonItem()
        backButton.title = " categories"
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
    }
}

// MARK: UICollectionViewDataSource
extension CategoryViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if viewModel.isSearching {
            return viewModel.getSearchResultsCount()
        }
        return viewModel.getResultsCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as! CategoryCollectionViewCell
        
        if viewModel.isSearching {
            cell.categoryLabel.text = viewModel.getNameOrTitleOfSearchResult(index: indexPath.row)
            if let urlImage = viewModel.getImageOfSearchResult(index: indexPath.row) {
                DispatchQueue.global().async {
                    DispatchQueue.main.async {
                        cell.categoryImage.image = urlImage
                    }
                }
            }
            return cell
        }
        
        if !viewModel.isLoading {
            cell.categoryLabel.text = viewModel.getNameOrTitle(index: indexPath.row)
            if let urlImage = viewModel.getImage(index: indexPath.row) {
                DispatchQueue.global().async {
                    DispatchQueue.main.async {
                        cell.categoryImage.image = urlImage
                    }
                }
            }
            collectionView.dismissProgress()
        }
        return cell
    }
}

// MARK: UICollectionViewDelegate
extension CategoryViewController: UICollectionViewDelegate {
    
}

// MARK: UICollectionViewDelegateFlowLayout
extension CategoryViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.bounds.width / 2), height: (collectionView.bounds.height / 3))
    }
}

// MARK: UISearchBarDelegate
extension CategoryViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.searchText = searchText
        collectionView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        viewModel.searchText = ""
        collectionView.reloadData()
    }
}

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}


