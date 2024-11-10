//
//  ImageCell.swift
//  Order
//
//  Created by Sofya Avtsinova on 01.11.2024.
//

import Foundation
import UIKit

final class ImageCollectionCell: UICollectionViewCell {
    
    var viewModel: CollectionCellViewModel.CellViewModelType.ImageInfo? {
        didSet {
            updateUI()
        }
    }
    
    private lazy var closeButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        button.addTarget(self, action: #selector(tapCell), for: .touchUpInside)
        
        var config = UIButton.Configuration.plain()
        config.image = UIImage(named: "delete")
        config.contentInsets = NSDirectionalEdgeInsets(top: 5,
                                                       leading: 5,
                                                       bottom: 5,
                                                       trailing: 5)
        button.configuration = config
        return button
    }()
    
    private lazy var image: UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = 12
        image.addSubview(closeButton)
        image.isUserInteractionEnabled = true
        return image
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension ImageCollectionCell {
    @objc func tapCell() {
        guard let viewModel else {
            return
        }
        viewModel.delete?(viewModel.id)
    }
    
    func updateUI() {
        guard let viewModel else {
            return
        }
        
        image.image = UIImage(named: viewModel.imagePath)
    }
    
    func setupUI() {
        contentView.addSubview(image)
        image.translatesAutoresizingMaskIntoConstraints = false
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            image.topAnchor.constraint(equalTo: contentView.topAnchor),
            image.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            image.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            image.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: image.topAnchor, constant: 8),
            closeButton.trailingAnchor.constraint(equalTo: image.trailingAnchor, constant: -8),
        ])
    }
}

