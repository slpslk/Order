//
//  MainCell.swift
//  Order
//
//  Created by Sofya Avtsinova on 01.11.2024.
//

import Foundation
import UIKit

final class MainCollectionCell: UICollectionViewCell {
    var viewModel: CollectionCellViewModel.CellViewModelType.MainInfo? {
        didSet {
            updateUI()
        }
    }
    
    private lazy var leftImage: UIImageView = {
        let image = UIImageView(image: UIImage(named: "cloud"))
        return image
    }()
    
    private lazy var title: UILabel = {
        let label = UILabel()
        label.font = UIFont.Roboto.regularWithSize(14)
        label.textColor = Colors.darkGray
        return label
    }()
    
    private lazy var subTitle: UILabel = {
        let label = UILabel()
        label.font = UIFont.Roboto.regularWithSize(12)
        label.textColor = Colors.lightGray
        return label
    }()
    
    private lazy var titleView: UIView = {
        let view = UIView()
        view.addSubview(title)
        view.addSubview(subTitle)
        return view
    }()
    
    private lazy var background: UIView = {
        let view = UIView()
        view.backgroundColor = Colors.backgroundGray
        view.layer.cornerRadius = 12
        view.addSubview(leftImage)
        view.addSubview(titleView)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        title.text = nil
        subTitle.text = nil
    }
}

private extension MainCollectionCell {
    @objc func tapCell() {
        guard let viewModel else {
            return
        }
        viewModel.tap?()
    }
    
    func updateUI() {
        guard let viewModel else {
            return
        }
        
        title.text = viewModel.title
        subTitle.text = viewModel.subTitle
    }
    
    func setupUI() {
        contentView.addSubview(background)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapCell))
        contentView.addGestureRecognizer(tapGesture)
        
        background.translatesAutoresizingMaskIntoConstraints = false
        leftImage.translatesAutoresizingMaskIntoConstraints = false
        titleView.translatesAutoresizingMaskIntoConstraints = false
        title.translatesAutoresizingMaskIntoConstraints = false
        subTitle.translatesAutoresizingMaskIntoConstraints = false
        
        
        NSLayoutConstraint.activate([
            background.heightAnchor.constraint(equalToConstant: 80),
            background.topAnchor.constraint(equalTo: contentView.topAnchor),
            background.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            background.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            background.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            leftImage.centerYAnchor.constraint(equalTo: background.centerYAnchor),
            leftImage.leadingAnchor.constraint(equalTo: background.leadingAnchor, constant: 16),
        ])
        
        NSLayoutConstraint.activate([
            titleView.centerYAnchor.constraint(equalTo: background.centerYAnchor),
            titleView.leadingAnchor.constraint(equalTo: leftImage.trailingAnchor, constant: 16),
            titleView.trailingAnchor.constraint(equalTo: background.trailingAnchor, constant: -16),
        ])
        
        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: titleView.topAnchor),
            title.leadingAnchor.constraint(equalTo: titleView.leadingAnchor),
        ])
        
        NSLayoutConstraint.activate([
            subTitle.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 2),
            subTitle.leadingAnchor.constraint(equalTo: titleView.leadingAnchor),
            subTitle.bottomAnchor.constraint(equalTo: titleView.bottomAnchor)
        ])
    }
}
