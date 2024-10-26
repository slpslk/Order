//
//  ApplyPromocodeViewController.swift
//  Order
//
//  Created by Sofya Avtsinova on 23.10.2024.
//

import Foundation
import UIKit

class ApplyPromocodeViewController: UIViewController {
    
    let viewModel = ApplyPromocodeViewModel()
    
    private lazy var backButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "backButton"), for: .normal)
        button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var textField: PaddedTextField = {
        let textField = PaddedTextField()
        
        textField.padding = UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 36)
        textField.textColor = Colors.darkGray
        
        textField.layer.cornerRadius = 12
        textField.layer.borderWidth = 1
        textField.layer.borderColor = Colors.darkGray.cgColor

        textField.clearButtonMode = .whileEditing
        textField.tintColor = UIColor.orange
        
        textField.delegate = self
        textField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        return textField
    }()
    
    private lazy var errorLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Roboto-Regular", size: 12)
        label.textColor = Colors.red
        label.text = "К сожалению, данного промокода не существует"
        return label
    }()
    
    private lazy var errorLabelWrapper: UIView = {
        let wrapper = UIView()
        wrapper.addSubview(errorLabel)
        return wrapper
    }()
    
    private lazy var applyButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = Colors.orange
        button.layer.cornerRadius = 12
        button.addTarget(self, action: #selector(applyButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var applyButtonWrapper: UIView = {
        let wrapper = UIView()
        wrapper.addSubview(applyButton)
        return wrapper
    }()
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fill
        stack.spacing = 4
        stack.addArrangedSubview(textField)
        stack.addArrangedSubview(errorLabelWrapper)
        stack.addArrangedSubview(applyButtonWrapper)
        return stack
    }()
    
    private lazy var attributes = AttributeContainer.init([
        NSAttributedString.Key.font: UIFont(name: "Roboto-Regular", size: 16) ?? UIFont.systemFont(ofSize: 16)
    ])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Применить промокод"
        
        setupNavigationBar()
        setupUI()
    }
    
    init(find: @escaping (String) -> String?, add: @escaping (String) -> Void) {
        super.init(nibName: nil, bundle: nil)
        viewModel.findPromocode = find
        viewModel.applyPromocode = add
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ApplyPromocodeViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

private extension ApplyPromocodeViewController {
    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func textFieldChanged() {
        textField.defaultStyle()
        errorLabelWrapper.isHidden = true
        viewModel.promocodeTitle = textField.text ?? ""
    }
    
    @objc func applyButtonTapped() {
        if let promoID = viewModel.findPromocode?(viewModel.promocodeTitle) {
            navigationController?.popViewController(animated: true)
            viewModel.applyPromocode?(promoID)
        } else {
            promocodeDontExist()
        }
    }
    
    func promocodeDontExist() {
        textField.errorStyle()
        errorLabelWrapper.isHidden = false
    }
    
    func setupNavigationBar() {
        let backButtonItem = UIBarButtonItem(customView: backButton)
        navigationItem.leftBarButtonItem = backButtonItem
    }
    
    func setupUI() {
        view.addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            stackView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 16),
            stackView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -16),
        ])
        
        setupTextField()
        setupErrorLabel()
        setupButton()
    }
    
    func setupTextField() {
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            textField.heightAnchor.constraint(equalToConstant: 54)
        ])
    }
    
    func setupErrorLabel() {
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        errorLabelWrapper.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            errorLabel.topAnchor.constraint(equalTo: errorLabelWrapper.topAnchor),
            errorLabel.leftAnchor.constraint(equalTo: errorLabelWrapper.leftAnchor, constant: 12),
            errorLabel.rightAnchor.constraint(equalTo: errorLabelWrapper.rightAnchor, constant: -12),
            errorLabel.bottomAnchor.constraint(equalTo: errorLabelWrapper.bottomAnchor)
        ])

        errorLabelWrapper.isHidden = true
    }
    
    func setupButton() {
        var config = UIButton.Configuration.plain()
        
        let titleAttributedString = AttributedString("Применить", attributes: attributes)
        
        config.attributedTitle = titleAttributedString
        config.baseForegroundColor = .white
        config.titleAlignment = .center
        applyButton.configuration = config
        
        applyButton.translatesAutoresizingMaskIntoConstraints = false
        applyButtonWrapper.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            applyButton.heightAnchor.constraint(equalToConstant: 54),
            applyButton.topAnchor.constraint(equalTo: applyButtonWrapper.topAnchor, constant: 12),
            applyButton.leftAnchor.constraint(equalTo: applyButtonWrapper.leftAnchor),
            applyButton.rightAnchor.constraint(equalTo: applyButtonWrapper.rightAnchor),
            applyButton.bottomAnchor.constraint(equalTo: applyButtonWrapper.bottomAnchor)
        ])
    }
}
