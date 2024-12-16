//
//  ProductCell.swift
//  Order
//
//  Created by Sofya Avtsinova on 29.10.2024.
//

import Foundation
import UIKit

final class ProductCell: UITableViewCell {
    var viewModel: RewiewTableCellViewModel.CellViewModelType.ProductInfo? {
        didSet {
            updateUI()
        }
    }
    
    private lazy var productImage: UIImageView = {
        let image = UIImageView(frame: CGRect(x: 0, y: 0, width: 14, height: 14))
        image.backgroundColor = .white
        image.clipsToBounds = true
        return image
    }()
    
    private lazy var productTitle: UILabel = {
        let label = UILabel()
        label.font = UIFont.Roboto.regularWithSize(14)
        label.textColor = Colors.darkGray
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var arrowImage: UIImageView = {
        let image = UIImageView(image: UIImage(named: "arrow"))
        return image
    }()
    
    private lazy var productView: UIView = {
        let view = UIView()
        view.addSubview(productImage)
        view.addSubview(productTitle)
        view.addSubview(arrowImage)
        return view
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    override func prepareForReuse() {
        productImage.image = nil
        productTitle.text = nil
    }
}

private extension ProductCell {
    @objc func tapCell() {
        guard let viewModel else {
            return
        }
        viewModel.click?(viewModel.id)
    }
    
    func updateUI() {
        guard let viewModel else {
            return
        }
        
        productImage.image = UIImage(named: viewModel.imagePath)
        productTitle.text = viewModel.title
    }

    func setupUI() {
        contentView.backgroundColor = .white
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapCell))
        contentView.addGestureRecognizer(tapGesture)
        
        contentView.addSubview(productView)
        contentView.addSubview(productImage)
        contentView.addSubview(productTitle)
        contentView.addSubview(arrowImage)
        
        productView.translatesAutoresizingMaskIntoConstraints = false
        productImage.translatesAutoresizingMaskIntoConstraints = false
        productTitle.translatesAutoresizingMaskIntoConstraints = false
        arrowImage.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            productView.topAnchor.constraint(equalTo: contentView.topAnchor),
            productView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            productView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            productView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24)
        ])

        NSLayoutConstraint.activate([
            productImage.topAnchor.constraint(equalTo: productView.topAnchor),
            productImage.leadingAnchor.constraint(equalTo: productView.leadingAnchor),
            productImage.bottomAnchor.constraint(equalTo: productView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            productTitle.topAnchor.constraint(equalTo: productView.topAnchor, constant: 9),
            productTitle.leadingAnchor.constraint(equalTo: productImage.trailingAnchor, constant: 12),
            productTitle.trailingAnchor.constraint(lessThanOrEqualTo: arrowImage.leadingAnchor, constant: -55),
        ])
        
        productTitle.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        NSLayoutConstraint.activate([
            arrowImage.centerYAnchor.constraint(equalTo: productView.centerYAnchor),
            arrowImage.trailingAnchor.constraint(equalTo: productView.trailingAnchor, constant: -7),
        ])
    }
}

