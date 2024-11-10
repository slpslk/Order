//
//  ViewController.swift
//  Order
//
//  Created by Sofya Avtsinova on 17.10.2024.
//

import UIKit

enum Colors {
    static let darkGray = UIColor(red: 34/255, green: 34/255, blue: 34/255, alpha: 1)
    static let snackBarGray = UIColor(red: 34/255, green: 34/255, blue: 34/255, alpha: 0.6)
    static let lightGray = UIColor(red: 122/255, green: 122/255, blue: 122/255, alpha: 1)
    static let orange = UIColor(red: 1, green: 70/255, blue: 17/255, alpha: 1)
    static let lightOrange = UIColor(red: 1, green: 70/255, blue: 17/255, alpha: 0.1)
    static let green = UIColor(red: 0, green: 183/255, blue: 117/255, alpha: 1)
    static let backgroundGray = UIColor(red: 246/255, green: 246/255, blue: 246/255, alpha: 1)
    static let separatorGray = UIColor(red: 234/255, green: 234/255, blue: 234/255, alpha: 1)
    static let red = UIColor(red: 244/255, green: 45/255, blue: 45/255, alpha: 1)
    static let lightRed = UIColor(red: 255/255, green: 236/255, blue: 236/255, alpha: 1)
    static let starGray = UIColor(red: 217/255, green: 217/255, blue: 217/255, alpha: 1)
    static let starYellow = UIColor(red: 248/255, green: 198/255, blue: 35/255, alpha: 1)
}

protocol TableViewUpdateDelegate: AnyObject {
    func reloadTable()
    func addRow(at indexPath: IndexPath)
    func reloadRow(at indexPath: IndexPath)
    func showAlert(_ message: String)
    func showSnackBar()
    func changeShowingCells()
}

final class ViewController: UIViewController {
    
    let viewModel = ViewModel()
    var cellsIsHidden = false

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
    
    private lazy var snackBarText: UILabel = {
        let label = UILabel()
        label.text = "Промокод применен"
        label.textColor = .white
        label.font =  UIFont.Roboto.regularWithSize(14)
        return label
    }()
    
    private lazy var snackBar: UIView = {
        let view = UIView()
        view.backgroundColor = Colors.snackBarGray
        view.layer.cornerRadius = 20
        view.addSubview(snackBarText)
        return view
    }()
    
    private let titleAttributes = [NSAttributedString.Key.foregroundColor: Colors.darkGray]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.delegate = self
        viewModel.applyButtonHandler = { [weak self] in
            let applyPromococdeView = ApplyPromocodeViewController(find: { title in
                self?.viewModel.findPromocodeByTitle(title: title)
            }, add: { id in
                self?.viewModel.addPromococdeByID(id: id)
            })
            
            self?.navigationController?.pushViewController(applyPromococdeView, animated: true)
        }
        
        view.backgroundColor = .white
        title = "Оформление заказа"
        navigationController?.navigationBar.titleTextAttributes = titleAttributes
        
        view.addSubview(snackBar)
        view.addSubview(tableView)
        
        setupUI()
        
        reloadTable()
        viewModel.madeData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        do {
            try viewModel.checkData()
            reloadTable()
        } catch OrderError.zeroProducts {
            showAlert("Нет продуктов в заказе")
        } catch OrderError.zeroProductPrice {
            showAlert("Стоимость продукта должна быть больше 0")
        } catch OrderError.tooBigDiscount {
            showAlert("Сумма текущей скидки не может быть больше суммы заказа")
        } catch OrderError.moreThanTwoPromocodes{
            showAlert("Вы не можете использовать более двух промокодов за раз")
        } catch {
            showAlert("Ошибка данных промокода")
        }
    }
}

private extension ViewController {
    func setupUI() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
        ])
        
        snackBar.translatesAutoresizingMaskIntoConstraints = false
        snackBarText.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            snackBar.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 96),
            snackBar.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -96),
            snackBar.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 100),
            snackBar.heightAnchor.constraint(equalToConstant: 40),
        ])
        
        NSLayoutConstraint.activate([
            snackBarText.centerYAnchor.constraint(equalTo: snackBar.centerYAnchor),
            snackBarText.centerXAnchor.constraint(equalTo: snackBar.centerXAnchor)
        ])
        
        view.bringSubviewToFront(snackBar)
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.allCells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let viewModel = viewModel.allCells[indexPath.row]
       
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
            if !promocodeInfo.isHidden{
                guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: PromocodeCell.self)) as? PromocodeCell else {
                    return UITableViewCell()
                }
                cell.viewModel = promocodeInfo
                cell.selectionStyle = .none
                return cell
            }
            return UITableViewCell()
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
    func reloadTable(){
        tableView.reloadData()
    }
    
    func addRow(at indexPath: IndexPath) {
        tableView.insertRows(at: [indexPath], with: .automatic)
    }
    
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
    
    func showSnackBar() {
        view.layoutIfNeeded()
        
        UIView.animate(withDuration: 0.5, animations: {
            self.snackBar.transform = CGAffineTransform(translationX: 0, y: -200)
            self.view.layoutIfNeeded()
        }) { _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                UIView.animate(withDuration: 0.5) {
                    self.snackBar.transform = .identity
                    self.view.layoutIfNeeded()
                }
            }
        }
    }
    
    func changeShowingCells() {
        cellsIsHidden = !cellsIsHidden
        viewModel.changeDisplayedCells(cellsIsHidden)
    }
}








