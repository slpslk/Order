//
//  HideButtonCell.swift
//  Order
//
//  Created by Sofya Avtsinova on 18.10.2024.
//

import Foundation
import UIKit

class HideButtonCell: UITableViewCell {
    var viewModel: TableCellViewModel.CellViewModelType.HideButtonInfo? {
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
    
    private lazy var hideButton: UIButton = {
        let button = UIButton()
        button.addSubview(buttonLabel)
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

private extension HideButtonCell {
    func updateUI() {
        guard let viewModel else {
            return
        }

        buttonLabel.text = viewModel.title
    }

    func setupUI() {
        contentView.addSubview(hideButton)
        
        buttonLabel.translatesAutoresizingMaskIntoConstraints = false
        hideButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            buttonLabel.topAnchor.constraint(equalTo: hideButton.topAnchor, constant: 9),
            buttonLabel.leftAnchor.constraint(equalTo: hideButton.leftAnchor,constant: 16),
            buttonLabel.rightAnchor.constraint(equalTo: hideButton.rightAnchor, constant: -16),
            buttonLabel.bottomAnchor.constraint(equalTo: hideButton.bottomAnchor, constant: -9)
        ])
        
        NSLayoutConstraint.activate([
            hideButton.topAnchor.constraint(equalTo: contentView.topAnchor),
            hideButton.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16),
            hideButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24)
        ])
    }
}
