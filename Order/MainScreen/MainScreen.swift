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
        .init(imagePath: "https://s3-alpha-sig.figma.com/img/0107/0af6/3297f40e81f4a6e2f72d2ce876867dac?Expires=1735516800&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=jlN3AOxUTMoxNUVWw2jRYqO54YeCDbGHBE9O-9SIkJ9xCQD-3sTL5Zj0lgffWQhE4zVhEcaVapmJS9qOHoSEYR6oWHsXqtD75f6Xq~7dma5mUMT48vm70l8jeXgKrCBj2qmzASxXROsJYDrAoEG8dWhug3TtJowrskcpQXQP-BWbfpBc4RSL9-j2BsRS9XaUtZ4J9gucWshA17BeH0dT5X0NX0BFnicD5ynrZKrIVrkUupXjZxKkBc96Zy2o6BNOg1hutrXGL6la747TbBHFYahcIZrAaUPdAtw1wZkReygCAIz1wyOc9Yt4-VbPQqNxKenFMSBTJ~J359QbNXcDEA__",
              title: "Золотое плоское обручальное кольцо 4 мм",
              count: 1,
              size: 17,
              price: 32000,
              discount: 10),
        .init(imagePath: "https://s3-alpha-sig.figma.com/img/0107/0af6/3297f40e81f4a6e2f72d2ce876867dac?Expires=1735516800&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=jlN3AOxUTMoxNUVWw2jRYqO54YeCDbGHBE9O-9SIkJ9xCQD-3sTL5Zj0lgffWQhE4zVhEcaVapmJS9qOHoSEYR6oWHsXqtD75f6Xq~7dma5mUMT48vm70l8jeXgKrCBj2qmzASxXROsJYDrAoEG8dWhug3TtJowrskcpQXQP-BWbfpBc4RSL9-j2BsRS9XaUtZ4J9gucWshA17BeH0dT5X0NX0BFnicD5ynrZKrIVrkUupXjZxKkBc96Zy2o6BNOg1hutrXGL6la747TbBHFYahcIZrAaUPdAtw1wZkReygCAIz1wyOc9Yt4-VbPQqNxKenFMSBTJ~J359QbNXcDEA__",
              title: "Золотое плоское обручальное кольцо 4 мм",
              count: 1,
              size: nil,
              price: 32000,
              discount: 10),
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
        .init(imagePath: "sber",
              title: "SberPay",
              discount: 5,
              subtitle: "Через приложение СберБанк",
              isActive: false),
        .init(imagePath: "card",
              title: "Банковской картой",
              discount: 5,
              subtitle: "Visa, Master Card, МИР",
              isActive: false),
        .init(imagePath: "yandex",
              title: "Яндекс Пэй со Сплитом",
              discount: 5,
              subtitle: "Оплата частями",
              isActive: false),
        .init(imagePath: "tinkoff",
              title: "Рассрочка Тинькофф",
              discount: 5,
              subtitle: "На 3 месяца без переплат",
              isActive: false),
        .init(imagePath: "tpay",
              title: "Tinkoff Pay",
              discount: 5,
              subtitle: "Через приложение Тинькофф",
              isActive: false),
        .init(imagePath: "wallet",
              title: "Оплатить при получении",
              discount: nil,
              subtitle: "Наличными или картой",
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
    
    private lazy var backButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "backButton"), for: .normal)
        button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let titleAttributes = [NSAttributedString.Key.foregroundColor: Colors.darkGray]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        view.backgroundColor = .white
        title = "Выберите экран"
        navigationController?.navigationBar.titleTextAttributes = titleAttributes
        
        setupUI()
        setupNavigationBar()
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
    func setupNavigationBar() {
        let backButtonItem = UIBarButtonItem(customView: backButton)
        navigationItem.leftBarButtonItem = backButtonItem
    }
    
    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
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




