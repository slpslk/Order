//
//  ViewController.swift
//  Order
//
//  Created by Sofya Avtsinova on 17.10.2024.
//

import UIKit

enum Colors {
    static let darkGray = UIColor(red: 34/255, green: 34/255, blue: 34/255, alpha: 1)
    static let lightGray = UIColor(red: 122/255, green: 122/255, blue: 122/255, alpha: 1)
    static let orange = UIColor(red: 1, green: 70/255, blue: 17/255, alpha: 1)
    static let lightOrange = UIColor(red: 1, green: 70/255, blue: 17/255, alpha: 0.1)
    static let green = UIColor(red: 0, green: 183/255, blue: 117/255, alpha: 1)
    static let backgroundGray = UIColor(red: 246/255, green: 246/255, blue: 246/255, alpha: 1)
    static let separatorGray = UIColor(red: 234/255, green: 234/255, blue: 234/255, alpha: 1)
}

protocol TableViewUpdateDelegate: AnyObject {
    func reloadRow(at indexPath: IndexPath)
    func showAlert(_ message: String)
}

class ViewController: UIViewController {
    
    let viewModel = ViewModel()

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        
        tableView.register(ApplyButtonCell.self, forCellReuseIdentifier: String(describing: ApplyButtonCell.self))
        tableView.register(TitleCell.self, forCellReuseIdentifier: String(describing: TitleCell.self))
        tableView.register(PromocodeCell.self, forCellReuseIdentifier: String(describing: PromocodeCell.self))
        tableView.register(HideButtonCell.self, forCellReuseIdentifier: String(describing: HideButtonCell.self))
        tableView.register(TotalPriceCell.self, forCellReuseIdentifier: String(describing: TotalPriceCell.self))
        tableView.register(OrderPlacingCell.self, forCellReuseIdentifier: String(describing: OrderPlacingCell.self))
        
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.delegate = self
        
        view.backgroundColor = Colors.backgroundGray
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
        ])
        
        tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        do {
            try viewModel.madeData()
            tableView.reloadData()
        } catch OrderError.zeroProducts {
            showAlert("Нет продуктов в заказе")
        } catch OrderError.zeroProductPrice {
            showAlert("Стоимость продукта должна быть больше 0")
        } catch OrderError.tooBigDiscount {
            showAlert("Сумма текущей скидки не может быть больше суммы заказа")
        } catch {
            showAlert("Неизвестная ошибка")
        }
    }

}

extension ViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.cellViewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let viewModel = self.viewModel.cellViewModels[indexPath.row]
       
        switch viewModel.type {

        case .title(let titleInfo):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: TitleCell.self)) as? TitleCell else {
                return UITableViewCell()
            }

            cell.viewModel = titleInfo
            cell.selectionStyle = .none
            return cell
        case .applyButton(let buttonInfo):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ApplyButtonCell.self)) as? ApplyButtonCell else {
                return UITableViewCell()
            }
            cell.viewModel = buttonInfo
            cell.selectionStyle = .none
            return cell
        case .promocode(let promocodeInfo):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: PromocodeCell.self)) as? PromocodeCell else {
                return UITableViewCell()
            }
            cell.viewModel = promocodeInfo
            cell.selectionStyle = .none
            return cell
        case .hideButton(let hideButtonInfo):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: HideButtonCell.self)) as? HideButtonCell else {
                return UITableViewCell()
            }
            cell.viewModel = hideButtonInfo
            cell.selectionStyle = .none
            return cell
        case .totalPrice(let totalInfo):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: TotalPriceCell.self)) as? TotalPriceCell else {
                return UITableViewCell()
            }
            cell.viewModel = totalInfo
            cell.selectionStyle = .none
            return cell
        case .orderButton(let orderButtonInfo):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: OrderPlacingCell.self)) as? OrderPlacingCell else {
                return UITableViewCell()
            }
            cell.viewModel = orderButtonInfo
            cell.selectionStyle = .none
            return cell
        }
    }

}

extension ViewController: TableViewUpdateDelegate {
    func reloadRow(at indexPath: IndexPath) {
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    func showAlert(_ message: String) {
        let alert = UIAlertController(title: "Ошибка",
                                      message: message,
                                      preferredStyle: .alert)
        let okAction = UIAlertAction(title: "ОК", style: .default)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
}








