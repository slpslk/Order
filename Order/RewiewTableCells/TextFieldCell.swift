//
//  TextFieldCell.swift
//  Order
//
//  Created by Sofya Avtsinova on 31.10.2024.
//

import Foundation
import UIKit

final class TextFieldCell: UITableViewCell {
    var viewModel: RewiewTableCellViewModel.CellViewModelType.TextFieldInfo? {
        didSet {
            updateUI()
        }
    }

     private lazy var textField: PaddedTextField = {
        let textField = PaddedTextField(setCustomPlaceholder: false)
        textField.padding = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 36)
        
        textField.backgroundColor = Colors.backgroundGray
        textField.textColor = Colors.darkGray
        
        textField.layer.cornerRadius = 12
        textField.clearButtonMode = .whileEditing
        textField.tintColor = UIColor.orange
        
        textField.delegate = self
        textField.returnKeyType = .next
    
        return textField
    }()
    
    private lazy var attributes = [
        NSAttributedString.Key.font: UIFont.Roboto.regularWithSize(16) ?? UIFont.systemFont(ofSize: 16),
        NSAttributedString.Key.foregroundColor: Colors.lightGray
    ]
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        NotificationCenter.default.addObserver(self, selector: #selector(shouldBecomeFirstResponder(_:)), name: .textFieldShouldBecomeFirstResponder, object: nil)
    }
    
    override func prepareForReuse() {
        textField.attributedPlaceholder = nil
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .textFieldShouldBecomeFirstResponder, object: nil)
    }
}

extension TextFieldCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nextClicked()
        return true
    }
}

private extension TextFieldCell {
    @objc private func shouldBecomeFirstResponder(_ notification: Notification) {
         guard let info = notification.userInfo?["info"] as? TextFieldNotificationInfo else {
             return
         }
        
        guard let currentId = info.currentId else {
            textField.resignFirstResponder()
            return
        }
         
         if viewModel?.id == currentId {
             makeFirstResponder()
         }
     }
    
    func nextClicked() {
        guard let viewModel else {
            return
        }
        viewModel.next?(viewModel.id)
    }
    
    func updateUI() {
        guard let viewModel else {
            return
        }
        
        textField.attributedPlaceholder = NSAttributedString(string: viewModel.placeholder,
                                                             attributes: attributes)
        if viewModel.isLast {
            textField.returnKeyType = .done
        }
    }
    
   
    func setupUI() {
        contentView.backgroundColor = .white
        contentView.addSubview(textField)
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            textField.heightAnchor.constraint(equalToConstant: 54),
            textField.topAnchor.constraint(equalTo: contentView.topAnchor),
            textField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            textField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            textField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }
    
    func makeFirstResponder() {
            if textField.isFirstResponder {
                return
            }
            textField.becomeFirstResponder()
        }
}
