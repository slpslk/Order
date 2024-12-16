//
//  MainScreen.swift
//  Order
//
//  Created by Sofya Avtsinova on 11.12.2024.
//

import Foundation
import UIKit
import SwiftUI

final class MainViewController: UIViewController {
    let products: [Order.Product] = [
        .init(imagePath: "https://images.unsplash.com/photo-1731700327903-824b789564f1?q=80&w=2787&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
              title: "Товар 1",
              count: 1,
              size: nil,
              price: 32000,
              discount: 10)
    ]

    let promocodes: [Order.Promocode] = [
        .init(title: "HELLOHELLOHELLOHELLOHELLOHELLOHELLOHELLOHELLOHELLOHELLO",
              percent: 70,
              endDate: nil,
              info: "Промокод действует на первый заказ в приложении",
              isActive: false),
        .init(title: "NSK2024",
              percent: 20,
              endDate: Date(timeIntervalSince1970: 1732924800),
              info: "Промокод действует для заказов от 3000 ₽",
              isActive: false),
        .init(title: "New Year",
              percent: 15,
              endDate: Date(timeIntervalSince1970: 1735603200),
              info: nil,
              isActive: true),
        .init(title: "New Year",
              percent: 15,
              endDate: Date(timeIntervalSince1970: 1735603200),
              info: nil,
              isActive: true),

     ]

    let availablePromocodes: [Order.Promocode] = [
        .init(title: "Secret50",
              percent: 50,
              endDate: nil,
              info: "Промокод действует на первый заказ в приложении",
              isActive: false),
        .init(title: "v8dskutevs76",
              percent: 15,
              endDate: Date(timeIntervalSince1970: 1735603200),
              info: nil,
              isActive: false),
    ]
    
    let paymentMethods: [Order.PaymentMethod] = [
        .init(imagePath: "",
              title: "SberPay",
              discount: 5,
              subtitle: "Через приложение СберБанк",
              isActive: false),
        .init(imagePath: "",
              title: "SberPay",
              discount: 5,
              subtitle: "Через приложение СберБанк",
              isActive: false),
    ]
    
    private lazy var promocodesScreenButton: UIButton = {
       let button = UIButton()
        button.backgroundColor = Colors.orange
        button.setTitle("Промокоды", for: .normal)
        button.layer.cornerRadius = 12
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(promocodesTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var rewiewScreenButton: UIButton = {
       let button = UIButton()
        button.backgroundColor = Colors.orange
        button.setTitle("Отзыв", for: .normal)
        button.layer.cornerRadius = 12
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(rewiewsTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var rejectScreenButton: UIButton = {
       let button = UIButton()
        button.backgroundColor = Colors.orange
        button.setTitle("Отмена заказа", for: .normal)
        button.layer.cornerRadius = 12
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(rejectTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var purchaseScreenButton: UIButton = {
       let button = UIButton()
        button.backgroundColor = Colors.orange
        button.setTitle("Оплата заказа", for: .normal)
        button.layer.cornerRadius = 12
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(purchaseTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var buttonStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 10
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.addArrangedSubview(promocodesScreenButton)
        stack.addArrangedSubview(rewiewScreenButton)
        stack.addArrangedSubview(rejectScreenButton)
        stack.addArrangedSubview(purchaseScreenButton)
        return stack
    }()
    
    private let titleAttributes = [NSAttributedString.Key.foregroundColor: Colors.darkGray]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        view.backgroundColor = .white
        title = "Выберите экран"
        navigationController?.navigationBar.titleTextAttributes = titleAttributes
        
        setupUI()
    }
}

private extension MainViewController {
    func setupUI() {
        view.addSubview(buttonStack)
        
        NSLayoutConstraint.activate([
            buttonStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            buttonStack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            buttonStack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
        ])
    }
    
    @objc func promocodesTapped() {
        do {
            let order = try Order(promocodes: promocodes,
                              availableForActive: availablePromocodes,
                              paymentMethods: [],
                              products: products)
            let orderService = try OrderService(order: order)
            let viewModel = PromocodesScreenViewModel(orderService: orderService)
            let promocodesView = PromocodesScreenViewController(viewModel: viewModel)
            navigationController?.pushViewController(promocodesView, animated: true)
        } catch  OrderError.zeroProducts {
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
    
    func showAlert(_ message: String) {
        let alert = UIAlertController(title: "Ошибка",
                                      message: message,
                                      preferredStyle: .alert)
        let okAction = UIAlertAction(title: "ОК", style: .default)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func rewiewsTapped() {
        let rewiewsView = ProductsViewController()
        navigationController?.pushViewController(rewiewsView, animated: true)
    }
    
    @objc func rejectTapped() {
        let rejectView = RejectOrderView()
        let newVC = UIHostingController<RejectOrderView>(rootView: rejectView)
        navigationController?.pushViewController(newVC, animated: true)
    }
    
    @objc func purchaseTapped() {
        do {
            let order = try Order(promocodes: promocodes,
                              availableForActive: availablePromocodes,
                              paymentMethods: paymentMethods,
                              products: products)
            let orderService = try OrderService(order: order)
            let viewModel = PurchaseViewModel(orderService: orderService)
            let purchaseView = PurchaseView(viewModel: viewModel)
            
            let newVC = UIHostingController<PurchaseView>(rootView: purchaseView)
            navigationController?.pushViewController(newVC, animated: true)
        } catch  OrderError.zeroProducts {
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




