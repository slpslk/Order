//
//  ProductsViewController.swift
//  Order
//
//  Created by Sofya Avtsinova on 29.10.2024.
//

import Foundation
import UIKit

final class ProductsViewController: UIViewController {
    let viewModel = ProductsViewModel()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        
        tableView.register(ProductCell.self, forCellReuseIdentifier: String(describing: ProductCell.self))
        
        return tableView
    }()
    
    private let titleAttributes = [NSAttributedString.Key.foregroundColor: Colors.darkGray]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.productTap = { [weak self] product in
            let rewiewView = RewiewViewController(product: product)
            self?.navigationController?.pushViewController(rewiewView, animated: true)
        }
        
        view.backgroundColor = .white
        title = "Напишите отзыв"
        navigationController?.navigationBar.titleTextAttributes = titleAttributes
        
        view.addSubview(tableView)
        
        setupUI()
        
        tableView.reloadData()
        viewModel.showProducts()
    }
}

private extension ProductsViewController {
    func setupUI() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 16),
            tableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -16),
        ])
    }
}


extension ProductsViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.productsCells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let viewModel = viewModel.productsCells[indexPath.row]
       
        switch viewModel.type {
            
        case .product(let productInfo):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ProductCell.self)) as? ProductCell else {
                return UITableViewCell()
            }
            cell.viewModel = productInfo
            cell.selectionStyle = .none
            return cell
        default:
            return UITableViewCell()
        }
    }

}
