//
//  PromocodeCell.swift
//  Order
//
//  Created by Sofya Avtsinova on 18.10.2024.
//

import Foundation
import UIKit

final class PromocodeCell: UITableViewCell {
    var viewModel: TableCellViewModel.CellViewModelType.PromocodeInfo? {
        didSet {
            updateUI()
        }
    }
    
    private lazy var promocodeTitle: UILabel = {
        let label = UILabel()
        label.textColor = Colors.darkGray
        label.font = UIFont.Roboto.regularWithSize(16)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var discountLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.font = UIFont.preferredFont(forTextStyle: .caption1)
        return label
    }()
    
    private lazy var promocodeDiscount: UIView = {
        let discountView = UIView()
        discountView.backgroundColor = Colors.green
        discountView.layer.cornerRadius = 10
        discountView.addSubview(discountLabel)
        return discountView
    }()
    
    private lazy var iconView: UIImageView = {
       let icon = UIImageView(image: UIImage(named: "infoIcon"))
        return icon
    }()
    
    private lazy var titleView: UIView = {
        let view = UIView()
        view.addSubview(promocodeTitle)
        view.addSubview(promocodeDiscount)
        view.addSubview(iconView)
        return view
    }()
    
    private lazy var promocodeDate: UILabel = {
       let label = UILabel()
        label.textColor = Colors.lightGray
        label.font = UIFont.Roboto.regularWithSize(14)
        return label
    }()
    
    private lazy var promocodeHeader: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.addArrangedSubview(titleView)
        stackView.addArrangedSubview(promocodeDate)
        return stackView
    }()
    
    private lazy var promocodeSwitch: UISwitch = {
        let switchView = UISwitch()
        switchView.tintColor = Colors.lightGray
        switchView.layer.cornerRadius = switchView.frame.height / 2.0
        switchView.backgroundColor = Colors.lightGray
        switchView.clipsToBounds = true
        switchView.onTintColor = Colors.orange
        switchView.addTarget(self, action: #selector(toggle), for: .valueChanged)
        return switchView
    }()
    
    private lazy var promocodeInfo: UIView = {
        let view = UIView()
        view.addSubview(promocodeHeader)
        view.addSubview(promocodeSwitch)
        return view
    }()
    
    private lazy var promocodeDescription: UILabel = {
        let label = UILabel()
        label.textColor = Colors.lightGray
        label.font = UIFont.Roboto.regularWithSize(12)
        return label
    }()
    
    private lazy var promocodeContent: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 8
        stackView.addArrangedSubview(promocodeInfo)
        stackView.addArrangedSubview(promocodeDescription)
        return stackView
    }()
    
    private lazy var promocodeBackground: UIView = {
        let view = UIView()
        view.backgroundColor = Colors.backgroundGray
        view.layer.cornerRadius = 12
        
        let circleView = UIView(frame: CGRect(x: view.frame.minX, y: view.frame.minY, width: 16, height: 16))
        circleView.layer.cornerRadius = circleView.frame.width / 2
        circleView.backgroundColor = .white
        
        let rightCircleView = UIView(frame: CGRect(x: view.frame.minX, y: view.frame.minY, width: 16, height: 16))
        rightCircleView.layer.cornerRadius = circleView.frame.width / 2
        rightCircleView.backgroundColor = .white
        
        view.addSubview(circleView)
        view.addSubview(rightCircleView)
        view.addSubview(promocodeContent)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        circleView.translatesAutoresizingMaskIntoConstraints = false
        rightCircleView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            circleView.heightAnchor.constraint(equalToConstant: 16),
            circleView.widthAnchor.constraint(equalToConstant: 16),
            circleView.centerXAnchor.constraint(equalTo: view.leftAnchor),
            circleView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            rightCircleView.heightAnchor.constraint(equalToConstant: 16),
            rightCircleView.widthAnchor.constraint(equalToConstant: 16),
            rightCircleView.centerXAnchor.constraint(equalTo: view.rightAnchor),
            rightCircleView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
        
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
        promocodeTitle.text = nil
        discountLabel.text = nil
        promocodeSwitch.isOn = false
        promocodeDate.text = nil
        promocodeDescription.text = nil
    }
}

private extension PromocodeCell {
    @objc func toggle() {
        guard let viewModel else { return }
        viewModel.toggle?(viewModel.id, promocodeSwitch.isOn)
    }
    
    func updateUI() {
        guard let viewModel else {
            return
        }

        promocodeTitle.text = viewModel.title
        discountLabel.text = "-\(viewModel.percent)%"
        promocodeSwitch.isOn = viewModel.isActive
        
        if let date = viewModel.endDate {
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "ru_RU")
            
            dateFormatter.dateFormat = "LLLL"
            let monthString = dateFormatter.string(from: date).dropLast() + "я"
            
            dateFormatter.dateFormat = "d"
            let dayString = dateFormatter.string(from: date)
            
            promocodeDate.text = "По \(dayString) \(monthString)"
            promocodeDate.isHidden = false
        }
        else {
            promocodeDate.isHidden = true
        }
        
        if let description = viewModel.info{
            promocodeDescription.text = description
            promocodeDescription.isHidden = false
        } else {
            promocodeDescription.isHidden = true
        }
    }

    func setupUI() {
        contentView.backgroundColor = .white
        contentView.addSubview(promocodeBackground)
        
        promocodeTitle.translatesAutoresizingMaskIntoConstraints = false
        promocodeDiscount.translatesAutoresizingMaskIntoConstraints = false
        discountLabel.translatesAutoresizingMaskIntoConstraints = false
        titleView.translatesAutoresizingMaskIntoConstraints = false
        iconView.translatesAutoresizingMaskIntoConstraints = false
        promocodeDate.translatesAutoresizingMaskIntoConstraints = false
        promocodeHeader.translatesAutoresizingMaskIntoConstraints = false
        promocodeSwitch.translatesAutoresizingMaskIntoConstraints = false
        promocodeInfo.translatesAutoresizingMaskIntoConstraints = false
        promocodeDescription.translatesAutoresizingMaskIntoConstraints = false
        promocodeContent.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            promocodeBackground.topAnchor.constraint(equalTo: contentView.topAnchor),
            promocodeBackground.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16),
            promocodeBackground.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16),
            promocodeBackground.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
        
        NSLayoutConstraint.activate([
            promocodeContent.topAnchor.constraint(equalTo: promocodeBackground.topAnchor, constant: 12),
            promocodeContent.leftAnchor.constraint(equalTo: promocodeBackground.leftAnchor, constant: 20),
            promocodeContent.rightAnchor.constraint(equalTo: promocodeBackground.rightAnchor, constant: -20),
            promocodeContent.bottomAnchor.constraint(equalTo: promocodeBackground.bottomAnchor, constant: -12)
        ])
              
        NSLayoutConstraint.activate([
            promocodeHeader.topAnchor.constraint(equalTo: promocodeInfo.topAnchor),
            promocodeHeader.leftAnchor.constraint(equalTo: promocodeInfo.leftAnchor),
            promocodeHeader.rightAnchor.constraint(lessThanOrEqualTo: promocodeSwitch.leftAnchor, constant: -8),
            promocodeHeader.bottomAnchor.constraint(equalTo: promocodeInfo.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            promocodeSwitch.centerYAnchor.constraint(equalTo: promocodeInfo.centerYAnchor),
            promocodeSwitch.rightAnchor.constraint(equalTo: promocodeInfo.rightAnchor)
        ])
        
        NSLayoutConstraint.activate([
            promocodeTitle.topAnchor.constraint(equalTo: titleView.topAnchor),
            promocodeTitle.leftAnchor.constraint(equalTo: titleView.leftAnchor),
            promocodeTitle.bottomAnchor.constraint(equalTo: titleView.bottomAnchor)
        ])
        
        promocodeDiscount.setContentCompressionResistancePriority(.required, for: .horizontal)
        discountLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        iconView.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        NSLayoutConstraint.activate([
            promocodeDiscount.topAnchor.constraint(equalTo: titleView.topAnchor),
            promocodeDiscount.leftAnchor.constraint(equalTo: promocodeTitle.rightAnchor, constant: 4),
        ])
        
        NSLayoutConstraint.activate([
            discountLabel.topAnchor.constraint(equalTo: promocodeDiscount.topAnchor, constant: 2),
            discountLabel.bottomAnchor.constraint(equalTo: promocodeDiscount.bottomAnchor, constant: -2),
            discountLabel.leadingAnchor.constraint(equalTo: promocodeDiscount.leadingAnchor, constant: 6),
            discountLabel.trailingAnchor.constraint(equalTo: promocodeDiscount.trailingAnchor, constant: -6)
        ])
        
        NSLayoutConstraint.activate([
            iconView.topAnchor.constraint(equalTo: titleView.topAnchor),
            iconView.leftAnchor.constraint(equalTo: promocodeDiscount.rightAnchor, constant: 4),
            iconView.rightAnchor.constraint(equalTo: titleView.rightAnchor)
        ])
    }
    
}
