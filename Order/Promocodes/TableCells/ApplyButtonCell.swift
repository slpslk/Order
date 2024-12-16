//
//  ApplyButtonCell.swift
//  Order
//
//  Created by Sofya Avtsinova on 18.10.2024.
//

import Foundation
import UIKit

final class ApplyButtonCell: UITableViewCell {
    var viewModel: TableCellViewModel.CellViewModelType.ApplyButtonInfo? {
        didSet {
            updateUI()
        }
    }
    
    private lazy var attributes = AttributeContainer.init([
        NSAttributedString.Key.font: UIFont.Roboto.regularWithSize(16) ?? UIFont.systemFont(ofSize: 16)
    ])
    
    private lazy var applyButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = Colors.lightOrange
        button.layer.cornerRadius = 12
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        return button
    }()
    
    @objc func buttonTapped() {
        guard let viewModel else { return }
            viewModel.click?()
       }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    override func prepareForReuse() {
        applyButton.configuration = nil
    }
}

private extension ApplyButtonCell {
    func updateUI() {
        guard let viewModel else {
            return
        }
        
        var config = UIButton.Configuration.plain()
        
        let titleAttributedString = AttributedString(viewModel.title, attributes: attributes)
        
        config.image = UIImage(named: "promoIcon")
        config.attributedTitle = titleAttributedString
        config.baseForegroundColor = Colors.orange
        config.imagePadding = 10
        config.imagePlacement = .leading
        applyButton.configuration = config
    }

    func setupUI() {
        contentView.backgroundColor = .white
        contentView.addSubview(applyButton)
        
       applyButton.translatesAutoresizingMaskIntoConstraints = false
    
        NSLayoutConstraint.activate([
            applyButton.heightAnchor.constraint(equalToConstant: 54),
            applyButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            applyButton.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16),
            applyButton.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16),
            applyButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }
    
}
