//
//  CheckboxCell.swift
//  Order
//
//  Created by Sofya Avtsinova on 30.10.2024.
//

import Foundation
import UIKit


final class CheckboxCell: UITableViewCell {
    var viewModel: RewiewTableCellViewModel.CellViewModelType.CheckboxInfo? {
        didSet {
            updateUI()
        }
    }

    private lazy var checkbox: Checkbox = {
        let checkbox = Checkbox(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        checkbox.layer.cornerRadius = 6
        checkbox.addTarget(self, action: #selector(toggle), for: .touchUpInside)
        return checkbox
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.Roboto.regularWithSize(16)
        label.textColor = Colors.darkGray
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var checkboxView: UIView = {
        let view = UIView()
        view.addSubview(checkbox)
        view.addSubview(titleLabel)
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
        titleLabel.text = nil
        checkbox.isChecked = true
    }
}

private extension CheckboxCell {
    @objc func toggle() {
        guard let viewModel else {
            return
        }
        viewModel.toggle?(checkbox.isChecked)
    }
    func updateUI() {
        guard let viewModel else {
            return
        }

        titleLabel.text = viewModel.title
        checkbox.isChecked = viewModel.isChecked
    }

    func setupUI() {
        contentView.backgroundColor = .white
        contentView.addSubview(checkboxView)
        
        checkboxView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            checkboxView.topAnchor.constraint(equalTo: contentView.topAnchor),
            checkboxView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            checkboxView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            checkboxView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
        
        checkbox.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            checkbox.topAnchor.constraint(equalTo: checkboxView.topAnchor, constant: 4),
            checkbox.leadingAnchor.constraint(equalTo: checkboxView.leadingAnchor, constant: 14),
            checkbox.bottomAnchor.constraint(equalTo: checkboxView.bottomAnchor, constant: -4)
        ])
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: checkboxView.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: checkbox.trailingAnchor, constant: 8),
        ])
    }
}
