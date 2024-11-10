//
//  ProductCell.swift
//  Order
//
//  Created by Sofya Avtsinova on 30.10.2024.
//

import Foundation
import UIKit

final class RewiewProductCell: UITableViewCell {
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
    
    private lazy var productSize: UILabel = {
        let label = UILabel()
        label.font = UIFont.Roboto.regularWithSize(14)
        label.textColor = Colors.lightGray
        return label
    }()
    
    private lazy var productInfoView: UIView = {
        let view = UIView()
        view.addSubview(productTitle)
        view.addSubview(productSize)
        return view
    }()
    
    private lazy var productView: UIView = {
        let view = UIView()
        view.addSubview(productImage)
        view.addSubview(productInfoView)
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
        productSize.text = nil
    }
}

private extension RewiewProductCell {
    func updateUI() {
        guard let viewModel else {
            return
        }
        
        productImage.image = UIImage(named: viewModel.imagePath)
        productTitle.text = viewModel.title
        
        if viewModel.size.truncatingRemainder(dividingBy: 1) == 0 {
            productSize.text = "Размер: \(Int(viewModel.size))"
        } else {
            productSize.text = "Размер: \(viewModel.size)"
        }
        
    }

    func setupUI() {
        contentView.backgroundColor = .white
    
        contentView.addSubview(productView)
        
        productView.translatesAutoresizingMaskIntoConstraints = false
        productInfoView.translatesAutoresizingMaskIntoConstraints = false
        productImage.translatesAutoresizingMaskIntoConstraints = false
        productTitle.translatesAutoresizingMaskIntoConstraints = false
        productSize.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            productView.topAnchor.constraint(equalTo: contentView.topAnchor),
            productView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            productView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            productView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])

        NSLayoutConstraint.activate([
            productImage.topAnchor.constraint(equalTo: productView.topAnchor),
            productImage.leadingAnchor.constraint(equalTo: productView.leadingAnchor),
            productImage.bottomAnchor.constraint(equalTo: productView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            productInfoView.centerYAnchor.constraint(equalTo: productView.centerYAnchor),
            productInfoView.leadingAnchor.constraint(equalTo: productImage.trailingAnchor, constant: 12),
            productInfoView.trailingAnchor.constraint(equalTo: productView.trailingAnchor),
        ])
        
        NSLayoutConstraint.activate([
            productTitle.topAnchor.constraint(equalTo: productInfoView.topAnchor),
            productTitle.leadingAnchor.constraint(equalTo: productInfoView.leadingAnchor),
            productTitle.trailingAnchor.constraint(lessThanOrEqualTo: productInfoView.trailingAnchor),
        ])
        
        productTitle.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        NSLayoutConstraint.activate([
            productSize.topAnchor.constraint(equalTo: productTitle.bottomAnchor, constant: 2),
            productSize.leadingAnchor.constraint(equalTo: productInfoView.leadingAnchor),
            productSize.trailingAnchor.constraint(lessThanOrEqualTo: productInfoView.trailingAnchor),
            productSize.bottomAnchor.constraint(equalTo: productInfoView.bottomAnchor)
        ])
    }
}

