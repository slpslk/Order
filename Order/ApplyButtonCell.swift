//
//  ApplyButtonCell.swift
//  Order
//
//  Created by Sofya Avtsinova on 18.10.2024.
//

import Foundation
import UIKit


class ApplyButtonCell: UITableViewCell {
    var viewModel: TableCellViewModel.CellViewModelType.ApplyButtonInfo? {
        didSet {
            updateUI()
        }
    }
    
    private lazy var buttonLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Roboto-Regular", size: 16)
        label.textColor = Colors.orange
        return label
    }()
    
    private lazy var buttonImage: UIImageView = {
        let image = UIImageView(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    private lazy var buttonContent: UIView = {
        let content = UIView()
        content.addSubview(buttonLabel)
        content.addSubview(buttonImage)
        return content
    }()
    
    private lazy var applyButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = Colors.lightOrange
        button.layer.cornerRadius = 12
        button.addSubview(buttonContent)
        return button
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
}

private extension ApplyButtonCell {
    func updateUI() {
        guard let viewModel else {
            return
        }

        buttonLabel.text = viewModel.title
        buttonImage.image = viewModel.image
    }

    func setupUI() {
        contentView.addSubview(applyButton)
        
        buttonLabel.translatesAutoresizingMaskIntoConstraints = false
        buttonImage.translatesAutoresizingMaskIntoConstraints = false
        buttonContent.translatesAutoresizingMaskIntoConstraints = false
        applyButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            buttonImage.topAnchor.constraint(equalTo: buttonContent.topAnchor),
            buttonImage.leftAnchor.constraint(equalTo: buttonContent.leftAnchor),
            buttonImage.bottomAnchor.constraint(equalTo: buttonContent.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            buttonLabel.topAnchor.constraint(equalTo: buttonContent.topAnchor),
            buttonLabel.leftAnchor.constraint(equalTo: buttonImage.rightAnchor, constant: 12),
            buttonLabel.rightAnchor.constraint(equalTo: buttonContent.rightAnchor),
            buttonLabel.bottomAnchor.constraint(equalTo: buttonContent.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            buttonContent.centerYAnchor.constraint(equalTo: applyButton.centerYAnchor),
            buttonContent.centerXAnchor.constraint(equalTo: applyButton.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            applyButton.heightAnchor.constraint(equalToConstant: 54),
            applyButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            applyButton.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16),
            applyButton.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16),
            applyButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
        
       
    }
    
}
