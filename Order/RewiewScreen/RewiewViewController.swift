//
//  RewiewViewController.swift
//  Order
//
//  Created by Sofya Avtsinova on 29.10.2024.
//

import Foundation
import UIKit

class RewiewViewController: UIViewController {
    
    private var viewModel: RewiewViewModel
    private var tableViewBottomConstraint: NSLayoutConstraint?
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        
        tableView.register(RewiewProductCell.self, forCellReuseIdentifier: String(describing: RewiewProductCell.self))
        tableView.register(StarsCell.self, forCellReuseIdentifier: String(describing: StarsCell.self))
        tableView.register(SendRewiewCell.self, forCellReuseIdentifier: String(describing: SendRewiewCell.self))
        tableView.register(CheckboxCell.self, forCellReuseIdentifier: String(describing: CheckboxCell.self))
        tableView.register(TextFieldCell.self, forCellReuseIdentifier: String(describing: TextFieldCell.self))
        tableView.register(AddFilesCell.self, forCellReuseIdentifier: String(describing: AddFilesCell.self))
        tableView.register(ErrorCell.self, forCellReuseIdentifier: String(describing: ErrorCell.self))
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        return tableView
    }()
    
    override func viewDidLoad() {
        view.backgroundColor = .white
        
        viewModel.reloadRow = { [weak self] indexPath in
            self?.tableView.reloadRows(at: [indexPath], with: .none)
        }
        
        viewModel.addRow = { [weak self] indexPath in
            self?.tableView.insertRows(at: [indexPath], with: .automatic)
        }
        
        viewModel.deleteRow = { [weak self] indexPath in
            self?.tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        
        viewModel.reloadTable = { [weak self] in
            self?.tableView.reloadData()
        }
    
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableViewBottomConstraint = tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        tableViewBottomConstraint?.isActive = true
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            tableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 16),
            tableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -16),
        ])
        tableView.reloadData()
    }
    
    init(product: RewiewTableCellViewModel) {
        self.viewModel = RewiewViewModel(product: product)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
           NotificationCenter.default.removeObserver(tableView)
       }
}

extension RewiewViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.rewiewCells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let viewModel = viewModel.rewiewCells[indexPath.row]
       
        switch viewModel.type {
            
        case .product(let productInfo):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: RewiewProductCell.self)) as? RewiewProductCell else {
                return UITableViewCell()
            }
            cell.viewModel = productInfo
            cell.selectionStyle = .none
            return cell
        case .stars(let starsInfo):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: StarsCell.self)) as? StarsCell else {
                return UITableViewCell()
            }
            cell.viewModel = starsInfo
            cell.selectionStyle = .none
            return cell
        case .sendButton(let sendButtonInfo):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: SendRewiewCell.self)) as? SendRewiewCell else {
                return UITableViewCell()
            }
            cell.viewModel = sendButtonInfo
            cell.selectionStyle = .none
            return cell
        case .checkbox(let checkboxInfo):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: CheckboxCell.self)) as? CheckboxCell else {
                return UITableViewCell()
            }
            cell.viewModel = checkboxInfo
            cell.selectionStyle = .none
            return cell
        case .textField(let textFieldInfo):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: TextFieldCell.self)) as? TextFieldCell else {
                return UITableViewCell()
            }
            cell.viewModel = textFieldInfo
            cell.selectionStyle = .none
            return cell
        case .addFiles(let addFilesInfo):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: AddFilesCell.self)) as? AddFilesCell else {
                return UITableViewCell()
            }
            cell.viewModel = addFilesInfo
            cell.selectionStyle = .none
            return cell
        case .error(let errorInfo):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ErrorCell.self)) as? ErrorCell else {
                return UITableViewCell()
            }
            cell.viewModel = errorInfo
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }
}

private extension RewiewViewController {
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        let keyboardHeight = keyboardFrame.height
        
        tableView.contentInset.bottom = keyboardHeight/2
        tableView.verticalScrollIndicatorInsets.bottom = keyboardHeight/2
        
        if let activeTextField = UIResponder.currentFirstResponder as? UITextField,
           let cell = activeTextField.superview?.superview as? UITableViewCell,
           let indexPath = tableView.indexPath(for: cell) {
            tableView.scrollToRow(at: indexPath, at: .middle, animated: true)
        }
        
    }
      
    @objc func keyboardWillHide(notification: NSNotification) {
        tableView.contentInset.bottom = 0
        tableView.verticalScrollIndicatorInsets.bottom = 0
    }
}
