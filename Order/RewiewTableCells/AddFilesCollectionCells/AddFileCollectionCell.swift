//
//  AddFileCell.swift
//  Order
//
//  Created by Sofya Avtsinova on 01.11.2024.
//

import Foundation
import UIKit

final class AddFileCollectionCell: UICollectionViewCell {
    var viewModel: CollectionCellViewModel.CellViewModelType.AddFileInfo?
    
    private lazy var cloud: UIImageView = {
        let image = UIImageView(image: UIImage(named: "cloud"))
        return image
    }()
    
    private lazy var background: UIView = {
        let view = UIView()
        view.backgroundColor = Colors.backgroundGray
        view.layer.cornerRadius = 12
        view.addSubview(cloud)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension AddFileCollectionCell {
    @objc func tapCell() {
        guard let viewModel else {
            return
        }
        viewModel.tap?()
    }
    
    func setupUI() {
        contentView.addSubview(background)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapCell))
        contentView.addGestureRecognizer(tapGesture)
        
        background.translatesAutoresizingMaskIntoConstraints = false
        cloud.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            background.topAnchor.constraint(equalTo: contentView.topAnchor),
            background.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            background.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            background.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            cloud.centerXAnchor.constraint(equalTo: background.centerXAnchor),
            cloud.centerYAnchor.constraint(equalTo: background.centerYAnchor),
        ])
    }
    
}
