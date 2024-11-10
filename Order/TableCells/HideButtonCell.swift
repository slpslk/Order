//
//  HideButtonCell.swift
//  Order
//
//  Created by Sofya Avtsinova on 18.10.2024.
//

import Foundation
import UIKit

final class HideButtonCell: UITableViewCell {
    var viewModel: TableCellViewModel.CellViewModelType.HideButtonInfo? {
        didSet {
            updateUI()
        }
    }
    
    private lazy var attributes = AttributeContainer.init([
        NSAttributedString.Key.font: UIFont.Roboto.regularWithSize(16) ?? UIFont.systemFont(ofSize: 16)
    ])
    
    private lazy var hideButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        return button
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    override func prepareForReuse() {
        hideButton.configuration = nil
    }
}

private extension HideButtonCell {
    @objc func buttonTapped() {
        guard let viewModel else { return }
        viewModel.click?()
    }
    
    func updateUI() {
        guard let viewModel else {
            return
        }
        
        if viewModel.isHidden {
            hideButton.isHidden = true
        } else {
            hideButton.isHidden = false
            var config = UIButton.Configuration.plain()
            
            let titleAttributedString = AttributedString(viewModel.title, attributes: attributes)
            
            config.attributedTitle = titleAttributedString
            config.baseForegroundColor = Colors.orange
            config.contentInsets = NSDirectionalEdgeInsets(top: 9, leading: 16, bottom: 9, trailing: 16)
            hideButton.configuration = config
        }
    }

    func setupUI() {
        contentView.backgroundColor = .white
        contentView.addSubview(hideButton)
        
        hideButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            hideButton.topAnchor.constraint(equalTo: contentView.topAnchor),
            hideButton.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16),
            hideButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24)
        ])
    }
}
