//
//  orderPlacingCell.swift
//  Order
//
//  Created by Sofya Avtsinova on 18.10.2024.
//

import Foundation
import UIKit

class OrderPlacingCell: UITableViewCell {
    var viewModel: TableCellViewModel.CellViewModelType.OrderButtonInfo? {
        didSet {
            updateUI()
        }
    }
    
    private lazy var buttonTextAttributes = AttributeContainer.init( [
        NSAttributedString.Key.font: UIFont(name: "Roboto-Regular", size: 16) ?? .systemFont(ofSize: 16)
    ])
    
    private var textAttributes = [
        NSAttributedString.Key.font: UIFont(name: "Roboto-Regular", size: 12),
        NSAttributedString.Key.foregroundColor: Colors.lightGray
    ]
    
    private var highlightedAttributes = [
        NSAttributedString.Key.font: UIFont(name: "Roboto-Regular", size: 12),
        NSAttributedString.Key.foregroundColor: Colors.darkGray
    ]
    
    private lazy var placeOrderButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = Colors.orange
        button.layer.cornerRadius = 12
        return button
    }()
    
    private lazy var warningText: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    override func prepareForReuse() {
        placeOrderButton.configuration = nil
        warningText.attributedText = nil
    }
}

private extension OrderPlacingCell {
    func updateUI() {
        guard let viewModel else {
            return
        }

        var config = UIButton.Configuration.plain()
        
        let titleAttributedString = AttributedString(viewModel.title,
                                                     attributes: buttonTextAttributes)
        
        config.attributedTitle = titleAttributedString
        config.baseForegroundColor = .white
        config.titleAlignment = .center
        placeOrderButton.configuration = config
        
        
        let attributedText = NSMutableAttributedString(string: viewModel.warningText,
                                                       attributes: textAttributes as [NSAttributedString.Key : Any])
        let highlightedText = NSMutableAttributedString(string: viewModel.highlightedText,
                                                        attributes: highlightedAttributes as [NSAttributedString.Key : Any])
        attributedText.append(highlightedText)
        warningText.attributedText = attributedText
    }

    func setupUI() {
        contentView.backgroundColor = Colors.backgroundGray
        contentView.addSubview(placeOrderButton)
        contentView.addSubview(warningText)
        
        placeOrderButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            placeOrderButton.heightAnchor.constraint(equalToConstant: 54),
            placeOrderButton.topAnchor.constraint(equalTo: contentView.topAnchor),
            placeOrderButton.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 32),
            placeOrderButton.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -32)
        ])
        
        warningText.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            warningText.topAnchor.constraint(equalTo: placeOrderButton.bottomAnchor, constant: 16),
            warningText.widthAnchor.constraint(equalToConstant: 220),
            warningText.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            warningText.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }
    
}
