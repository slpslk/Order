//
//  StarsCell.swift
//  Order
//
//  Created by Sofya Avtsinova on 30.10.2024.
//

import Foundation
import UIKit

final class StarsCell: UITableViewCell {
    var viewModel: RewiewTableCellViewModel.CellViewModelType.StarsInfo? {
        didSet {
            updateUI()
        }
    }
    
    private lazy var starsTitle: UILabel = {
        let label = UILabel()
        label.font = UIFont.Roboto.regularWithSize(16)
        label.textColor = Colors.lightGray
        return label
    }()
    
    private var starButton: UIButton {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
        button.tintColor = Colors.starGray
        button.addTarget(self, action: #selector(starTapped(sender:)), for: .touchUpInside)
        var config = UIButton.Configuration.plain()
        
        config.image = UIImage(systemName: "star.fill")

        if let image = config.image {
            let imageSize = image.size
            let horizontalInset = (button.frame.width - imageSize.width) / 2
            let verticalInset = (button.frame.height - imageSize.height) / 2
            config.contentInsets = NSDirectionalEdgeInsets(top: verticalInset,
                                                           leading: horizontalInset,
                                                           bottom: verticalInset,
                                                           trailing: horizontalInset)
        }
        
        button.configuration = config
        
        return button
    }
    
    private lazy var starsView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.spacing = 2
        view.translatesAutoresizingMaskIntoConstraints = false
        
        for _ in 0..<5 {
            let button = starButton

            button.translatesAutoresizingMaskIntoConstraints = false
            view.addArrangedSubview(button)
        }
        
        return view
    }()
    
    private lazy var starsBackground: UIView = {
        let view = UIView()
        view.backgroundColor = Colors.backgroundGray
        view.layer.cornerRadius = 12
        view.addSubview(starsTitle)
        view.addSubview(starsView)
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
        starsTitle.text = nil
    }
}

private extension StarsCell {
    @objc private func starTapped(sender: UIButton) {
        guard let viewModel else {
            return
        }
        if let index = starsView.arrangedSubviews.firstIndex(of: sender) {
            viewModel.tapStar?(index)
        }
    }

    
    func updateStars(count: Int) {
        for index in 0..<starsView.arrangedSubviews.count {
            if let item = starsView.arrangedSubviews[index] as? UIButton {
                if index < count {
                    item.tintColor = Colors.starYellow
                } else {
                    item.tintColor = Colors.starGray
                }
            }
        }
    }
    
    func updateUI() {
        guard let viewModel else {
            return
        }
        updateStars(count: viewModel.filledStarsCount)
        if viewModel.filledStarsCount != 0 {
            starsTitle.textColor = Colors.darkGray
        }
        starsTitle.text = viewModel.title
        
    }

    func setupUI() {
        contentView.backgroundColor = .white
    
        contentView.addSubview(starsBackground)
        
        starsBackground.translatesAutoresizingMaskIntoConstraints = false
        starsTitle.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            starsBackground.topAnchor.constraint(equalTo: contentView.topAnchor),
            starsBackground.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            starsBackground.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            starsBackground.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])

        NSLayoutConstraint.activate([
            starsTitle.leadingAnchor.constraint(equalTo: starsBackground.leadingAnchor, constant: 16),
            starsTitle.centerYAnchor.constraint(equalTo: starsBackground.centerYAnchor),
            starsTitle.rightAnchor.constraint(lessThanOrEqualTo: starsView.leftAnchor, constant: -8)
        ])
        
        starsTitle.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        NSLayoutConstraint.activate([
            starsView.trailingAnchor.constraint(equalTo: starsBackground.trailingAnchor, constant: -16),
            starsView.topAnchor.constraint(equalTo: starsBackground.topAnchor, constant: 16),
            starsView.bottomAnchor.constraint(equalTo: starsBackground.bottomAnchor, constant: -16),
        ])
        
    }
}


