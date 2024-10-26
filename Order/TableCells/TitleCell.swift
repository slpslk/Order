//
//  TitleCell.swift
//  Order
//
//  Created by Sofya Avtsinova on 18.10.2024.
//

import Foundation
import UIKit


class TitleCell: UITableViewCell {
    var viewModel: TableCellViewModel.CellViewModelType.TitleInfo? {
        didSet {
            updateUI()
        }
    }
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Roboto-Regular", size: 24)
        label.textColor = Colors.darkGray
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var subTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Roboto-Regular", size: 14)
        label.textColor = Colors.lightGray
        label.numberOfLines = 0
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
        titleLabel.text = nil
        subTitleLabel.text = nil
    }
}

private extension TitleCell {
    func updateUI() {
        guard let viewModel else {
            return
        }

        titleLabel.text = viewModel.title
        subTitleLabel.text = viewModel.subtitle
    }

    func setupUI() {
        contentView.backgroundColor = .white
        contentView.addSubview(titleLabel)
        contentView.addSubview(subTitleLabel)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
            titleLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16),
            titleLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16)
        ])
        
        subTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            subTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            subTitleLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16),
            subTitleLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16),
            subTitleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}
