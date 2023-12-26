//
//  InformationViewController.swift
//  StarWars Encyclopedia
//
//  Created by Ivan Romero on 18/10/2022.
//

import UIKit

class DetailViewController: UIViewController {
    //MARK: IBOutlets
    @IBOutlet weak var detailTableView: UITableView!
    @IBOutlet weak var categoryImage: UIImageView!
    @IBOutlet weak var selectedCategoryLabel: UILabel!
    
    //MARK: Private Cons
    private let viewModel: DetailViewModel
    
    //MARK: Inits
    init(viewModel: DetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "DetailViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackButton()
        setupDetailTableView()
        setupCategoryImage()
        setupSelectedCategoryLabel()
    }
    
    //MARK: setups
    private func setupDetailTableView() {
        detailTableView.register(UINib(nibName: "InfoTableViewCell", bundle: nil), forCellReuseIdentifier: "InfoCell")
        detailTableView.register(UINib(nibName: "CollectionTableViewCell", bundle: nil), forCellReuseIdentifier: "CollectionCell")
        self.detailTableView.dataSource = self
        self.detailTableView.delegate = self
        detailTableView.indicatorStyle = .white
    }
    
    private func setupBackButton() {
        let buttonItem = UIBarButtonItem()
        buttonItem.title = viewModel.getCategoryRawValue()
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = buttonItem
    }
    
    private func setupCategoryImage() {
        if let image = viewModel.getImage() {
            self.categoryImage.image = image
        } else {
            addNoImageViewOnView(self.categoryImage)
        }
        self.categoryImage.backgroundColor = UIColor.black
        self.categoryImage.layer.borderWidth = 1
        self.categoryImage.layer.masksToBounds = false
        self.categoryImage.layer.borderColor = UIColor.white.cgColor
        self.categoryImage.layer.cornerRadius = CGRectGetWidth(self.categoryImage.frame) / 2
        self.categoryImage.clipsToBounds = true
    }
    
    private func addNoImageViewOnView(_ view: UIView) {
        let noImageView = NoImageViewController()
        noImageView.view.frame = self.categoryImage.bounds
        view.addSubview(noImageView.view)
    }

    private func setupSelectedCategoryLabel() {
        self.selectedCategoryLabel.text = viewModel.getNameOrTitle()
    }
}

//MARK: - UITableViewDelegate

extension DetailViewController: UITableViewDelegate {

    //MARK: Setup Header tableView
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section != 0 {
            let header = getHeaderOfTableView(width: tableView.bounds.size.width, height: getHeaderHeightConstant())
            header.text = viewModel.getSectionNameAt(index: section)
            
            return header
        }
        
        return nil
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section != 0 {
            return getHeaderHeightConstant()
        }
        return 1
    }
    
    private func getHeaderHeightConstant() -> CGFloat { 30 }
    
    private func getHeaderOfTableView(width: CGFloat, height: CGFloat) -> UILabel {
        let headerLabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: height))
        headerLabel.font = UIFont(name: "SFDistantGalaxy-Italic", size: 20)
        headerLabel.textColor = .white
        headerLabel.textAlignment = .center
        headerLabel.sizeToFit()

        return headerLabel
    }
    
    //MARK: Setup Footer tableView
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section != (viewModel.getCountOfSections() - 1) {
            return getFooterOfTableView(width: tableView.bounds.size.width, height: getFooterHeightConstant())
        }

        return nil
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section != (viewModel.getCountOfSections() - 1) {
            return getFooterHeightConstant()
        }
        return 1
    }
    
    private func getFooterHeightConstant() -> CGFloat { 20 }
    
    private func getFooterOfTableView(width: CGFloat, height: CGFloat) -> UIView {
        let view = UIView(frame: CGRect(x: 0, y:0, width: width, height: getFooterHeightConstant()))
        view.backgroundColor = .clear
        let separator = UIView(frame: CGRect(x: 0, y: (view.frame.height/2), width: view.frame.width, height: 1))
        separator.backgroundColor = .darkGray
        view.addSubview(separator)
        view.clipsToBounds = true
        return view
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
                    viewModel.getData { isLoading in
                        if !isLoading {
                                cell.viewModel = viewModel
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
