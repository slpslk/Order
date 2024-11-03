//
//  SendRewiewCell.swift
//  Order
//
//  Created by Sofya Avtsinova on 30.10.2024.
//

import Foundation
import UIKit

class SendRewiewCell: UITableViewCell {
    var viewModel: RewiewTableCellViewModel.CellViewModelType.SubmitButtonInfo? {
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
        NSAttributedString.Key.foregroundColor: Colors.orange
    ]
    
    private lazy var sendRewiewButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = Colors.orange
        button.layer.cornerRadius = 12
        button.addTarget(self, action: #selector(tapButton), for: .touchUpInside)
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
        sendRewiewButton.configuration = nil
        warningText.attributedText = nil
    }
}

private extension SendRewiewCell {
    @objc func tapButton() {
        guard let viewModel else {
            return
        }
        
        viewModel.click?()
    }
    
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
        sendRewiewButton.configuration = config
        
        
        let attributedText = NSMutableAttributedString(string: viewModel.warningText,
                                                       attributes: textAttributes as [NSAttributedString.Key : Any])
        let highlightedText = NSMutableAttributedString(string: viewModel.highlightedText,
                                                        attributes: highlightedAttributes as [NSAttributedString.Key : Any])
        attributedText.append(highlightedText)
        warningText.attributedText = attributedText
    }

    func setupUI() {
        contentView.addSubview(sendRewiewButton)
        contentView.addSubview(warningText)
        
        sendRewiewButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            sendRewiewButton.heightAnchor.constraint(equalToConstant: 54),
            sendRewiewButton.topAnchor.constraint(equalTo: contentView.topAnchor),
            sendRewiewButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            sendRewiewButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
        
        warningText.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            warningText.topAnchor.constraint(equalTo: sendRewiewButton.bottomAnchor, constant: 16),
            warningText.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 32),
            warningText.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -32),
            warningText.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }
    
}
