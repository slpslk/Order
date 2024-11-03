//
//  ErrorCell.swift
//  Order
//
//  Created by Sofya Avtsinova on 03.11.2024.
//

import Foundation
import UIKit

class ErrorCell: UITableViewCell {
    var viewModel: RewiewTableCellViewModel.CellViewModelType.ErrorInfo? {
        didSet {
            updateUI()
        }
    }
    
    private lazy var errorLabel: UILabel = {
       let label = UILabel()
        label.textColor = Colors.red
        label.font = UIFont(name: "Roboto-Regular", size: 14)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var errorIcon: UIImageView = {
        let icon = UIImageView(frame: CGRect(x: 0, y: 0, width: 24, height: 24) )
        icon.image = UIImage(systemName: "exclamationmark.circle.fill")
        icon.tintColor = Colors.red
        icon.contentMode = .scaleAspectFill
        return icon
    }()
    
    private lazy var background: UIView = {
        let view = UIView()
        view.backgroundColor = Colors.lightRed
        view.layer.cornerRadius = 12
        view.addSubview(errorLabel)
        view.addSubview(errorIcon)
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

    }
}

private extension ErrorCell {
    func updateUI() {
        guard let viewModel else {
            return
        }
        
        errorLabel.text = viewModel.title
    }

    func setupUI() {
        contentView.backgroundColor = .white
        contentView.addSubview(background)
        
        background.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            background.heightAnchor.constraint(equalToConstant: 65),
            background.topAnchor.constraint(equalTo: contentView.topAnchor),
            background.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            background.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            background.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
        
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            errorLabel.leadingAnchor.constraint(equalTo: background.leadingAnchor, constant: 16),
            errorLabel.centerYAnchor.constraint(equalTo: background.centerYAnchor)
        ])
        
        errorIcon.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            errorIcon.heightAnchor.constraint(equalToConstant: 24),
            errorIcon.centerYAnchor.constraint(equalTo: background.centerYAnchor),
            errorIcon.trailingAnchor.constraint(equalTo: background.trailingAnchor, constant: -16),
            errorIcon.leadingAnchor.constraint(greaterThanOrEqualTo: errorLabel.trailingAnchor, constant: 16)
        ])
    }
}

