//
//  TotalPriceCell.swift
//  Order
//
//  Created by Sofya Avtsinova on 18.10.2024.
//

import Foundation
import UIKit


class TotalPriceCell: UITableViewCell {
    var viewModel: TableCellViewModel.CellViewModelType.TotalPriceInfo? {
        didSet {
            updateUI()
        }
    }
    
    private lazy var allPriceTitle: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Roboto-Regular", size: 14)
        label.textColor = Colors.darkGray
        return label
    }()
    
    private lazy var allPrice: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Roboto-Regular", size: 14)
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
        label.font = UIFont(name: "Roboto-Regular", size: 14)
        label.textColor = Colors.darkGray
        return label
    }()
    
    private lazy var discountAmount: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Roboto-Regular", size: 14)
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
        label.font = UIFont(name: "Roboto-Regular", size: 14)
        label.textColor = Colors.darkGray
        return label
    }()
    
    private lazy var promocodeAmount: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Roboto-Regular", size: 14)
        label.textColor = Colors.green
        label.textAlignment = .right
        return label
    }()
    
    private lazy var promocodeAmountView: UIView = {
        let view = UIView()
        view.addSubview(promocodeAmountTitle)
        view.addSubview(promocodeAmount)
        return view
    }()
    
    private lazy var paymentAmountTitle: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Roboto-Regular", size: 14)
        label.textColor = Colors.darkGray
        return label
    }()
    
    private lazy var paymentAmount: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Roboto-Regular", size: 14)
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
    
    private lazy var separatorLine: UIView = {
        let bottomBorder = UIView()
        bottomBorder.backgroundColor = Colors.separatorGray
        return bottomBorder
    }()
    
    private lazy var totalPriceTitle: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Roboto-Regular", size: 18)
        label.textColor = Colors.darkGray
        return label
    }()
    
    private lazy var totalPrice: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Roboto-Regular", size: 18)
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
}

private extension TotalPriceCell {
    func updateUI() {
        guard let viewModel else {
            return
        }

        allPriceTitle.text = viewModel.allPriceTitle
        allPrice.text = "\(Int(viewModel.allPrice)) ₽"
        discountAmountTitle.text = viewModel.discountAmountTitle
        discountAmount.text = "-\(Int(viewModel.discountAmount ?? 0)) ₽"
        promocodeAmountTitle.text = viewModel.promocodeAmountTitle
        promocodeAmount.text = "-\(Int(viewModel.promocodeAmount ?? 0)) ₽"
        paymentAmountTitle.text = viewModel.paymentAmountTitle
        paymentAmount.text = "-\(Int(viewModel.paymentAmount ?? 0)) ₽"
        totalPriceTitle.text = viewModel.totalPriceTitle
        totalPrice.text = "\(Int(viewModel.totalPrice)) ₽"
        
    }

    func setupUI() {
        contentView.backgroundColor = Colors.backgroundGray
        contentView.addSubview(allPriceView)
        contentView.addSubview(discountAmountView)
        contentView.addSubview(promocodeAmountView)
        contentView.addSubview(paymentAmountView)
        contentView.addSubview(separatorLine)
        contentView.addSubview(totalPriceView)
        
        allPriceView.translatesAutoresizingMaskIntoConstraints = false
        allPriceTitle.translatesAutoresizingMaskIntoConstraints = false
        allPrice.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            allPriceView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
            allPriceView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 32),
            allPriceView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -32)
        ])
        
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
        
        discountAmountView.translatesAutoresizingMaskIntoConstraints = false
        discountAmountTitle.translatesAutoresizingMaskIntoConstraints = false
        discountAmount.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            discountAmountView.topAnchor.constraint(equalTo: allPriceView.bottomAnchor, constant: 10),
            discountAmountView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 32),
            discountAmountView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -32),
        ])
        
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
        
        promocodeAmountView.translatesAutoresizingMaskIntoConstraints = false
        promocodeAmountTitle.translatesAutoresizingMaskIntoConstraints = false
        promocodeAmount.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            promocodeAmountView.topAnchor.constraint(equalTo: discountAmountView.bottomAnchor, constant: 10),
            promocodeAmountView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 32),
            promocodeAmountView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -32),
        ])
        
        NSLayoutConstraint.activate([
            promocodeAmountTitle.topAnchor.constraint(equalTo: promocodeAmountView.topAnchor),
            promocodeAmountTitle.leftAnchor.constraint(equalTo: promocodeAmountView.leftAnchor),
            promocodeAmountTitle.bottomAnchor.constraint(equalTo: promocodeAmountView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            promocodeAmount.topAnchor.constraint(equalTo: promocodeAmountView.topAnchor),
            promocodeAmount.rightAnchor.constraint(equalTo: promocodeAmountView.rightAnchor),
            promocodeAmount.bottomAnchor.constraint(equalTo: promocodeAmountView.bottomAnchor)
        ])
        
        paymentAmountView.translatesAutoresizingMaskIntoConstraints = false
        paymentAmountTitle.translatesAutoresizingMaskIntoConstraints = false
        paymentAmount.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            paymentAmountView.topAnchor.constraint(equalTo: promocodeAmountView.bottomAnchor, constant: 10),
            paymentAmountView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 32),
            paymentAmountView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -32)
        ])
        
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
            separatorLine.topAnchor.constraint(equalTo: paymentAmountView.bottomAnchor, constant: 16),
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
