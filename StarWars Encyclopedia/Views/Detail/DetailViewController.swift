//
//  InformationViewController.swift
//  StarWars Encyclopedia
//
//  Created by Ivan Romero on 18/10/2022.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet weak var detailTableView: UITableView!
    @IBOutlet weak var categoryImage: UIImageView!
    @IBOutlet weak var selectedCategoryLabel: UILabel!

    private var viewModel: DetailViewModel

    init(viewModel: DetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "DetailViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackButton()
        setupDetailTableView()
        setupCategoryImage()
        setupSelectedCategoryLabel()
    }
    
    private func setupDetailTableView() {
        detailTableView.register(UINib(nibName: "InfoTableViewCell", bundle: nil), forCellReuseIdentifier: "InfoCell")
        detailTableView.register(UINib(nibName: "CollectionTableViewCell", bundle: nil), forCellReuseIdentifier: "CollectionCell")
        self.detailTableView.dataSource = self
        self.detailTableView.delegate = self
    }
    
    private func setupBackButton() {
        let buttonItem = UIBarButtonItem()
        buttonItem.title = CategoryManager.shared.category!.rawValue
        self.navigationController?.navigationBar.topItem?.backButtonTitle = CategoryManager.shared.category!.rawValue
    }
    
    private func setupCategoryImage() {
        if let image = viewModel.getImage() {
            self.categoryImage.image = image
        } else {
            let noImageView = NoImageViewController()
            noImageView.view.frame = self.categoryImage.bounds
            self.categoryImage.addSubview(noImageView.view)
        }
        self.categoryImage.backgroundColor = UIColor.black
        self.categoryImage.layer.borderWidth = 1
        self.categoryImage.layer.masksToBounds = false
        self.categoryImage.layer.borderColor = UIColor.white.cgColor
        self.categoryImage.layer.cornerRadius = CGRectGetWidth(self.categoryImage.frame) / 2
        self.categoryImage.clipsToBounds = true
    }

    private func setupSelectedCategoryLabel() {
        self.selectedCategoryLabel.text = viewModel.getNameOrTitle()
    }
}

//MARK: - UITableViewDelegate
extension DetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section != 0 {
            let headerLabel = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 30))
            headerLabel.font = UIFont(name: "SFDistantGalaxy-Italic", size: 20)
            headerLabel.textColor = .white
            headerLabel.text = viewModel.getSectionNameAt(index: section)
            headerLabel.textAlignment = .center
            headerLabel.sizeToFit()

            return headerLabel
        }
        return nil
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section != 0 {
            return 30
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        // UIView with darkGray background for section-separators as Section Footer
        if section != (viewModel.getCountOfSections() - 1) {
            let v = UIView(frame: CGRect(x: 0, y:0, width: tableView.frame.width, height: 20))
            v.backgroundColor = .clear
            let separator = UIView(frame: CGRect(x: 0, y: (v.frame.height/2), width: v.frame.width, height: 1))
            separator.backgroundColor = .darkGray
            v.addSubview(separator)
            v.clipsToBounds = true
            return v
        }

        return nil
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section != (viewModel.getCountOfSections() - 1) {
            return 20
        }
        return 1
    }
}

//MARK: - UITableViewDataSource
extension DetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "InfoCell", for: indexPath) as! InfoTableViewCell
            
            if cell.verticalStackView.subviews.isEmpty {
                if let dictionary = viewModel.getInfo() {
                    dictionary.sorted { $0 < $1 }.forEach { (key: String, value: String) in
                        let horizontalStackView = UIStackView()
                 
                        horizontalStackView.axis = .horizontal
                        horizontalStackView.spacing = 8
                        horizontalStackView.distribution = .fillEqually
                        let leftLabel = UILabel()
                        let rightLabel = UILabel()
                        
                        leftLabel.textAlignment = .left
                        leftLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
                        leftLabel.numberOfLines = 0
                        rightLabel.textAlignment = .left
                        rightLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
                        rightLabel.numberOfLines = 0
                        
                        leftLabel.font = UIFont(name: "SFDistantGalaxy-Italic", size: 15.0)
                        leftLabel.textColor = .white
                        leftLabel.text = key.replacingOccurrences(of: "_", with: " ")
                        leftLabel.numberOfLines = 1
                        leftLabel.adjustsFontSizeToFitWidth = true
                        rightLabel.font = UIFont(name: "SFDistantGalaxy-Italic", size: 15.0)
                        rightLabel.textColor = UIColor(named: "StarWarsColor")
                        rightLabel.text = value
                        horizontalStackView.addArrangedSubview(leftLabel)
                        horizontalStackView.addArrangedSubview(rightLabel)
                        horizontalStackView.alignment = .top
                        
                        cell.verticalStackView.addArrangedSubview(horizontalStackView)
                    }
                }
            }
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CollectionCell", for: indexPath) as! CollectionTableViewCell
            
            if let sectionDataManage = viewModel.getSectionDataManage(index: indexPath.section) {
                if cell.viewModel.sectionDataManage == nil {
                    let viewModel = CollectionTableViewCellViewModel()
                    viewModel.sectionDataManage = sectionDataManage
                    viewModel.getData { isLoadign in
                        if !isLoadign {
                            DispatchQueue.main.async {
                                cell.viewModel = viewModel
                            }
                        }
                    }
                }
                return cell
            }
            return cell
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.getCountOfSections()
    }
}
