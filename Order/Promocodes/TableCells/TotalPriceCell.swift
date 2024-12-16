//
//  TotalPriceCell.swift
//  Order
//
//  Created by Sofya Avtsinova on 18.10.2024.
//

import Foundation
import UIKit


final class TotalPriceCell: UITableViewCell {
    var viewModel: TableCellViewModel.CellViewModelType.TotalPriceInfo? {
        didSet {
            updateUI()
        }
    }
    
    private lazy var allPriceTitle: UILabel = {
        let label = UILabel()
        label.font = UIFont.Roboto.regularWithSize(14)
        label.textColor = Colors.darkGray
        return label
    }()
    
    private lazy var allPrice: UILabel = {
        let label = UILabel()
        label.font = UIFont.Roboto.regularWithSize(14)
        label.textColor = Colors.darkGray
        label.textAlignment = .right
        return label
    }()
    
    private lazy var allPriceView: UIView = {
        let view = UIView()
        view.addSubview(allPriceTitle)
        view.addSubview(allPrice)
        return view
    }()
    
    private lazy var discountAmountTitle: UILabel = {
        let label = UILabel()
        label.font = UIFont.Roboto.regularWithSize(14)
        label.textColor = Colors.darkGray
        return label
    }()
    
    private lazy var discountAmount: UILabel = {
        let label = UILabel()
        label.font = UIFont.Roboto.regularWithSize(14)
        label.textColor = Colors.orange
        label.textAlignment = .right
        return label
    }()
    
    private lazy var discountAmountView: UIView = {
        let view = UIView()
        view.addSubview(discountAmountTitle)
        view.addSubview(discountAmount)
        return view
    }()
    
    private lazy var promocodeAmountTitle: UILabel = {
        let label = UILabel()
        label.font = UIFont.Roboto.regularWithSize(14)
        label.textColor = Colors.darkGray
        return label
    }()
    
    private lazy var iconView: UIImageView = {
       let icon = UIImageView(image: UIImage(named: "infoIcon"))
        return icon
    }()
    
    private lazy var promocodeAmount: UILabel = {
        let label = UILabel()
        label.font = UIFont.Roboto.regularWithSize(14)
        label.textColor = Colors.green
        label.textAlignment = .right
        return label
    }()
    
    private lazy var promocodeAmountView: UIView = {
        let view = UIView()
        view.addSubview(promocodeAmountTitle)
        view.addSubview(iconView)
        view.addSubview(promocodeAmount)
        return view
    }()
    
    private lazy var paymentAmountTitle: UILabel = {
        let label = UILabel()
        label.font = UIFont.Roboto.regularWithSize(14)
        label.textColor = Colors.darkGray
        return label
    }()
    
    private lazy var paymentAmount: UILabel = {
        let label = UILabel()
        label.font = UIFont.Roboto.regularWithSize(14)
        label.textColor = Colors.darkGray
        label.textAlignment = .right
        return label
    }()
    
    private lazy var paymentAmountView: UIView = {
        let view = UIView()
        
        view.addSubview(paymentAmountTitle)
        view.addSubview(paymentAmount)
        return view
    }()
    
    private lazy var summaryContent: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 10
        stackView.addArrangedSubview(allPriceView)
        stackView.addArrangedSubview(discountAmountView)
        stackView.addArrangedSubview(promocodeAmountView)
        stackView.addArrangedSubview(paymentAmountView)
        return stackView
    }()
    
    private lazy var separatorLine: UIView = {
        let bottomBorder = UIView()
        bottomBorder.backgroundColor = Colors.separatorGray
        return bottomBorder
    }()
    
    private lazy var totalPriceTitle: UILabel = {
        let label = UILabel()
        label.font = UIFont.Roboto.regularWithSize(18)
        label.textColor = Colors.darkGray
        return label
    }()
    
    private lazy var totalPrice: UILabel = {
        let label = UILabel()
        label.font = UIFont.Roboto.regularWithSize(18)
        label.textColor = Colors.darkGray
        label.textAlignment = .right
        return label
    }()
    
    private lazy var totalPriceView: UIView = {
        let view = UIView()
        
        view.addSubview(totalPriceTitle)
        view.addSubview(totalPrice)
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
        allPriceTitle.text = nil
        allPrice.text = nil
        discountAmountTitle.text = nil
        discountAmount.text = nil
        promocodeAmountTitle.text = nil
        promocodeAmount.text = nil
        paymentAmountTitle.text = nil
        paymentAmount.text = nil
        totalPriceTitle.text = nil
        totalPrice.text = nil
    }
}

private extension TotalPriceCell {
    func updateUI() {
        guard let viewModel else {
            return
        }

        allPriceTitle.text = viewModel.allPriceTitle
        allPrice.text = "\(Int(viewModel.allPrice)) ₽"
        
        if let discountValue = viewModel.discountAmount, discountValue > 0 {
            discountAmountTitle.text = viewModel.discountAmountTitle
            discountAmount.text = "-\(Int(discountValue)) ₽"
            discountAmountView.isHidden = false
        } else {
            discountAmountView.isHidden = true
        }
        
        if let promoValue = viewModel.promocodeAmount, promoValue > 0 {
            promocodeAmountTitle.text = viewModel.promocodeAmountTitle
            promocodeAmount.text = "-\(Int(promoValue)) ₽"
            promocodeAmountView.isHidden = false
        } else {
            promocodeAmountView.isHidden = true
        }
        
        if let paymentValue = viewModel.paymentAmount, paymentValue > 0 {
            paymentAmountTitle.text = viewModel.paymentAmountTitle
            paymentAmount.text = "-\(Int(paymentValue)) ₽"
            paymentAmountView.isHidden = false
        } else {
            paymentAmountView.isHidden = true
        }
        
        totalPriceTitle.text = viewModel.totalPriceTitle
        totalPrice.text = "\(Int(viewModel.totalPrice)) ₽"
        
    }

    func setupUI() {
        contentView.backgroundColor = Colors.backgroundGray
        contentView.addSubview(summaryContent)
        contentView.addSubview(separatorLine)
        contentView.addSubview(totalPriceView)
        
        summaryContent.translatesAutoresizingMaskIntoConstraints = false
        allPriceView.translatesAutoresizingMaskIntoConstraints = false
        discountAmountView.translatesAutoresizingMaskIntoConstraints = false
        promocodeAmountView.translatesAutoresizingMaskIntoConstraints = false
        paymentAmountView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            summaryContent.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
            summaryContent.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 32),
            summaryContent.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -32)
        ])

        allPriceTitle.translatesAutoresizingMaskIntoConstraints = false
        allPrice.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            allPriceTitle.topAnchor.constraint(equalTo: allPriceView.topAnchor),
            allPriceTitle.leftAnchor.constraint(equalTo: allPriceView.leftAnchor),
            allPriceTitle.bottomAnchor.constraint(equalTo: allPriceView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            allPrice.topAnchor.constraint(equalTo: allPriceView.topAnchor),
            allPrice.rightAnchor.constraint(equalTo: allPriceView.rightAnchor),
            allPrice.bottomAnchor.constraint(equalTo: allPriceView.bottomAnchor)
        ])
        
        discountAmountTitle.translatesAutoresizingMaskIntoConstraints = false
        discountAmount.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            discountAmountTitle.topAnchor.constraint(equalTo: discountAmountView.topAnchor),
            discountAmountTitle.leftAnchor.constraint(equalTo: discountAmountView.leftAnchor),
            discountAmountTitle.bottomAnchor.constraint(equalTo: discountAmountView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            discountAmount.topAnchor.constraint(equalTo: discountAmountView.topAnchor),
            discountAmount.rightAnchor.constraint(equalTo: discountAmountView.rightAnchor),
            discountAmount.bottomAnchor.constraint(equalTo: discountAmountView.bottomAnchor)
        ])
        
        promocodeAmountTitle.translatesAutoresizingMaskIntoConstraints = false
        iconView.translatesAutoresizingMaskIntoConstraints = false
        promocodeAmount.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            promocodeAmountTitle.topAnchor.constraint(equalTo: promocodeAmountView.topAnchor),
            promocodeAmountTitle.leftAnchor.constraint(equalTo: promocodeAmountView.leftAnchor),
            promocodeAmountTitle.bottomAnchor.constraint(equalTo: promocodeAmountView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            iconView.topAnchor.constraint(equalTo: promocodeAmountView.topAnchor),
            iconView.leftAnchor.constraint(equalTo: promocodeAmountTitle.rightAnchor, constant: 6),
            iconView.bottomAnchor.constraint(equalTo: promocodeAmountView.bottomAnchor),
        ])
        
        NSLayoutConstraint.activate([
            promocodeAmount.topAnchor.constraint(equalTo: promocodeAmountView.topAnchor),
            promocodeAmount.rightAnchor.constraint(equalTo: promocodeAmountView.rightAnchor),
            promocodeAmount.bottomAnchor.constraint(equalTo: promocodeAmountView.bottomAnchor)
        ])
        
        paymentAmountTitle.translatesAutoresizingMaskIntoConstraints = false
        paymentAmount.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            paymentAmountTitle.topAnchor.constraint(equalTo: paymentAmountView.topAnchor),
            paymentAmountTitle.leftAnchor.constraint(equalTo: paymentAmountView.leftAnchor),
            paymentAmountTitle.bottomAnchor.constraint(equalTo: paymentAmountView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            paymentAmount.topAnchor.constraint(equalTo: paymentAmountView.topAnchor),
            paymentAmount.rightAnchor.constraint(equalTo: paymentAmountView.rightAnchor),
            paymentAmount.bottomAnchor.constraint(equalTo: paymentAmountView.bottomAnchor)
        ])
        
        separatorLine.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            separatorLine.heightAnchor.constraint(equalToConstant: 1),
            separatorLine.topAnchor.constraint(equalTo: summaryContent.bottomAnchor, constant: 16),
            separatorLine.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 32),
            separatorLine.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -32)
        ])
        
        totalPriceView.translatesAutoresizingMaskIntoConstraints = false
        totalPriceTitle.translatesAutoresizingMaskIntoConstraints = false
        totalPrice.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            totalPriceView.topAnchor.constraint(equalTo: separatorLine.bottomAnchor, constant: 16),
            totalPriceView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 32),
            totalPriceView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -32),
            totalPriceView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
        
        NSLayoutConstraint.activate([
            totalPriceTitle.topAnchor.constraint(equalTo: totalPriceView.topAnchor),
            totalPriceTitle.leftAnchor.constraint(equalTo: totalPriceView.leftAnchor),
            totalPriceTitle.bottomAnchor.constraint(equalTo: totalPriceView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            totalPrice.topAnchor.constraint(equalTo: totalPriceView.topAnchor),
            totalPrice.rightAnchor.constraint(equalTo: totalPriceView.rightAnchor),
            totalPrice.bottomAnchor.constraint(equalTo: totalPriceView.bottomAnchor)
        ])
    }
}
