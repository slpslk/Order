//
//  PromocodeCell.swift
//  Order
//
//  Created by Sofya Avtsinova on 18.10.2024.
//

import Foundation
import UIKit

class PromocodeCell: UITableViewCell {
    var viewModel: TableCellViewModel.CellViewModelType.PromocodeInfo? {
        didSet {
            updateUI()
        }
    }
    
    private lazy var promocodeTitle: UILabel = {
        let label = UILabel()
        label.textColor = Colors.darkGray
        label.font = UIFont(name: "Roboto-Regular", size: 16)
        return label
    }()
    
    
    private lazy var discountLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.font = UIFont.preferredFont(forTextStyle: .caption1)
        return label
    } ()
    
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
        label.font = UIFont(name: "Roboto-Regular", size: 14)
        return label
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
        view.addSubview(titleView)
        view.addSubview(promocodeDate)
        view.addSubview(promocodeSwitch)
        return view
    }()
    
    private lazy var promocodeDescription: UILabel = {
        let label = UILabel()
        label.textColor = Colors.lightGray
        label.font = UIFont(name: "Roboto-Regular", size: 12)
        return label
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
        view.addSubview(promocodeInfo)
        view.addSubview(promocodeDescription)
        
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
}

private extension PromocodeCell {
    @objc func toggle() {
        guard let viewModel else { return }
        if let result = viewModel.toggle?(viewModel.id), !result {
            promocodeSwitch.isOn.toggle()
        }
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
                
                NSLayoutConstraint.activate([
                    promocodeDate.topAnchor.constraint(equalTo: titleView.bottomAnchor),
                    promocodeDate.leftAnchor.constraint(equalTo: promocodeInfo.leftAnchor),
                    promocodeDate.bottomAnchor.constraint(equalTo: promocodeInfo.bottomAnchor)
                ])
        } else {
            NSLayoutConstraint.activate([
                titleView.bottomAnchor.constraint(equalTo: promocodeInfo.bottomAnchor),
            ])
        }
        
        
        if let description = viewModel.info{
            if promocodeDescription.text == nil {
                promocodeDescription.text = description
                
                NSLayoutConstraint.activate([
                    promocodeDescription.topAnchor.constraint(equalTo: promocodeInfo.bottomAnchor, constant: 8),
                    promocodeDescription.leftAnchor.constraint(equalTo: promocodeBackground.leftAnchor, constant: 20),
                    promocodeDescription.rightAnchor.constraint(equalTo: promocodeBackground.rightAnchor, constant: -20),
                    promocodeDescription.bottomAnchor.constraint(equalTo: promocodeBackground.bottomAnchor, constant: -12)
                ])
            }
        } else {
            NSLayoutConstraint.activate([
                promocodeInfo.bottomAnchor.constraint(equalTo: promocodeBackground.bottomAnchor, constant: -12)
            ])
        }
    }

    func setupUI() {
        contentView.addSubview(promocodeInfo)
        contentView.addSubview(promocodeBackground)
        
        promocodeTitle.translatesAutoresizingMaskIntoConstraints = false
        promocodeDiscount.translatesAutoresizingMaskIntoConstraints = false
        discountLabel.translatesAutoresizingMaskIntoConstraints = false
        titleView.translatesAutoresizingMaskIntoConstraints = false
        iconView.translatesAutoresizingMaskIntoConstraints = false
        promocodeDate.translatesAutoresizingMaskIntoConstraints = false
        promocodeSwitch.translatesAutoresizingMaskIntoConstraints = false
        promocodeInfo.translatesAutoresizingMaskIntoConstraints = false
        promocodeDescription.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            promocodeBackground.topAnchor.constraint(equalTo: contentView.topAnchor),
            promocodeBackground.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16),
            promocodeBackground.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16),
            promocodeBackground.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
        
        NSLayoutConstraint.activate([
            promocodeInfo.topAnchor.constraint(equalTo: promocodeBackground.topAnchor, constant: 12),
            promocodeInfo.leftAnchor.constraint(equalTo: promocodeBackground.leftAnchor, constant: 20),
            promocodeInfo.rightAnchor.constraint(equalTo: promocodeBackground.rightAnchor, constant: -20),
        ])
   
        NSLayoutConstraint.activate([
            titleView.topAnchor.constraint(equalTo: promocodeInfo.topAnchor),
            titleView.leftAnchor.constraint(equalTo: promocodeInfo.leftAnchor),
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
        
        NSLayoutConstraint.activate([
            promocodeDiscount.topAnchor.constraint(equalTo: titleView.topAnchor),
            promocodeDiscount.leftAnchor.constraint(equalTo: promocodeTitle.rightAnchor, constant: 4),
            promocodeDiscount.bottomAnchor.constraint(equalTo: titleView.bottomAnchor)
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
            iconView.rightAnchor.constraint(equalTo: titleView.rightAnchor),
            iconView.bottomAnchor.constraint(equalTo: titleView.bottomAnchor)
        ])
    }
    
}
