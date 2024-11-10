//
//  Checkbox.swift
//  Order
//
//  Created by Sofya Avtsinova on 31.10.2024.
//

import Foundation
import UIKit

final class Checkbox: UIButton {

    private lazy var checkedImage: UIImageView = {
        return UIImageView(image: UIImage(named: "checked"))
    }()

    var isChecked: Bool = true {
        didSet {
            isChecked ? checked() : unchecked()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.commonInit()
    }
}

private extension Checkbox {
    func checked() {
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = Colors.orange
        self.configuration = config
        
        checkedImage.contentMode = .center
        checkedImage.translatesAutoresizingMaskIntoConstraints = false
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(checkedImage)
        
        NSLayoutConstraint.activate([
            checkedImage.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            checkedImage.centerYAnchor.constraint(equalTo: self.centerYAnchor),
        ])
    }

    func unchecked() {
        checkedImage.removeFromSuperview()
        
        var config = UIButton.Configuration.plain()
        config.baseBackgroundColor = .clear
        config.image = nil
        config.background.strokeColor = Colors.lightGray
        config.background.strokeWidth = 2
        self.configuration = config
    }
    
    func commonInit() {
        self.addTarget(self, action: #selector(checkBoxTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            self.widthAnchor.constraint(equalToConstant: self.frame.width),
            self.heightAnchor.constraint(equalToConstant: self.frame.height)
        ])
        
    }

    @objc func checkBoxTapped() {
        self.isChecked.toggle()
    }
}
