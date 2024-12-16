//
//  PaddedTextField.swift
//  Order
//
//  Created by Sofya Avtsinova on 24.10.2024.
//

import Foundation
import UIKit

final class PaddedTextField: UITextField, UITextFieldDelegate {
    
    var padding: UIEdgeInsets? {
        didSet {
            layoutSubviews()
        }
    }
    var setCustomPlaceholder: Bool = false
    let placeholderHeight: CGFloat = 16
    
    private lazy var placeholderLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.Roboto.regularWithSize(12)
        label.textColor = Colors.lightGray
        label.text = "Введите код"
        return label
    }()
    
    private lazy var clearButton: UIButton = {
        let button = UIButton()
        button.frame = CGRect(x: 0, y: 0, width: 15, height: 15)
        button.setImage(UIImage(named: "clear"), for: .normal)
        button.addTarget(self, action: #selector(clearClicked), for: .touchUpInside)
        return button
    }()
    
    convenience init(setCustomPlaceholder: Bool) {
        self.init(frame: .zero)
        self.setCustomPlaceholder = setCustomPlaceholder
        
        if setCustomPlaceholder {
            setupPlaceholderLabel()
        } else {
            self.delegate = self
        }
        
        self.rightView = clearButton
        self.clearButtonMode = .never
        self.rightViewMode = .whileEditing
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        if setCustomPlaceholder {
            setupPlaceholderLabel()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if let padding {
            placeholderLabel.frame = CGRect(x: self.bounds.minX + padding.left,
                                            y: self.bounds.minY + padding.top,
                                            width: self.bounds.width,
                                            height: placeholderHeight)
        }
    }
    
    func errorStyle() {
        self.layer.borderColor = Colors.red.cgColor
        placeholderLabel.textColor = Colors.red
    }
    
    func defaultStyle() {
        self.layer.borderColor = Colors.darkGray.cgColor
        placeholderLabel.textColor = Colors.lightGray
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        updatePlaceholder()
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        if let padding {
            return bounds.inset(by: UIEdgeInsets(top: padding.top + (setCustomPlaceholder ? placeholderHeight : 0),
                                                 left: padding.left,
                                                 bottom: padding.bottom,
                                                 right: padding.right))
        }
        
        return super.textRect(forBounds: bounds)
    }
    
    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        if let padding {
            return bounds.inset(by: UIEdgeInsets(top: padding.top,
                                                 left: bounds.width - padding.right,
                                                 bottom: padding.bottom,
                                                 right: 0))
        }
        
        return super.rightViewRect(forBounds: bounds)
    }

    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        if let padding {
            return bounds.inset(by: UIEdgeInsets(top: padding.top + (setCustomPlaceholder ? placeholderHeight : 0),
                                                 left: padding.left,
                                                 bottom: padding.bottom,
                                                 right: padding.right))
        }
        
        return super.editingRect(forBounds: bounds)
    }
}

private extension PaddedTextField {
    @objc func clearClicked() {
        self.text = ""
    }
    
    func updatePlaceholder() {
        placeholderLabel.text = self.placeholder
        placeholderLabel.isHidden = !self.text!.isEmpty
    }
    
    func setupPlaceholderLabel() {
        addSubview(placeholderLabel)
        self.delegate = self
    }
}


