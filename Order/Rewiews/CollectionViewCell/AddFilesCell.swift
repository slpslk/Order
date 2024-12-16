//
//  AddFilesCell.swift
//  Order
//
//  Created by Sofya Avtsinova on 30.10.2024.
//

import Foundation
import UIKit

final class AddFilesCell: UITableViewCell {
    enum Constants {
        static let padding: CGFloat = 8
        static let number: CGFloat = 4
        static let maxImagesCount: Int = 7
    }
    
    var viewModel: RewiewTableCellViewModel.CellViewModelType.AddFilesInfo? {
        didSet {
            updateUI()
        }
    }
    
    private var collectionViewModel = CollectionViewModel()

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isScrollEnabled = false
        collectionView.register(MainCollectionCell.self, forCellWithReuseIdentifier: String(describing: MainCollectionCell.self))
        collectionView.register(ImageCollectionCell.self, forCellWithReuseIdentifier: String(describing: ImageCollectionCell.self))
        collectionView.register(AddFileCollectionCell.self, forCellWithReuseIdentifier: String(describing: AddFileCollectionCell.self))
        
        return collectionView
    }()
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    static func getCellHeight(viewModel: RewiewTableCellViewModel.CellViewModelType.AddFilesInfo) -> CGFloat {
        let cellHeight: CGFloat = 80.25
        let padding = Constants.padding
        let bottomOffset: CGFloat = 17
        
        let numberOfCompleteRows = viewModel.visibleCellsCount / 4
        let hasPartialRow = viewModel.visibleCellsCount % 4 > 0
        
        let paddingCount = max(0, numberOfCompleteRows - 1 + (hasPartialRow ? 1 : 0))
        
        let totalHeight = (CGFloat(numberOfCompleteRows + (hasPartialRow ? 1 : 0)) * cellHeight) +
                          (CGFloat(paddingCount) * padding) +
                          bottomOffset
        
        return totalHeight
    }
}

extension AddFilesCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        collectionViewModel.visibleImagePaths.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionViewModel.visibleImagePaths[indexPath.row].type {
        case .main(let mainInfo) :
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: MainCollectionCell.self), for: indexPath) as! MainCollectionCell
            cell.viewModel = mainInfo
            return cell
            
        case .addFile(let addFileInfo) :
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: AddFileCollectionCell.self), for: indexPath) as! AddFileCollectionCell
            cell.viewModel = addFileInfo
            return cell
            
        case .image(let imageInfo) :
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ImageCollectionCell.self), for: indexPath) as! ImageCollectionCell
            
            cell.viewModel = imageInfo
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionViewModel.visibleImagePaths.count == 1 {
            return .init(width: collectionView.bounds.width, height: 80)
        } else {
            let width = (collectionView.bounds.width - Constants.padding * (Constants.number + 1)) / Constants.number
            return .init(width: width, height: width)
        }
    }
    
}

private extension AddFilesCell {
    func updateUI() {
        guard let viewModel else {
            return
        }
       
        collectionViewModel = CollectionViewModel(addItem: { [weak self] indexPath in
            self?.collectionView.insertItems(at: [indexPath])
            self?.updateCollectionViewHeight()
        },
                                                  deleteItem: { [weak self] indexPath in
            self?.collectionView.deleteItems(at: [indexPath])
            self?.updateCollectionViewHeight()
        },
                                                  reload: { [weak self] in
            self?.collectionView.reloadData()
            self?.updateCollectionViewHeight()
        },
                                                  main: viewModel.mainInfo,
                                                  images: viewModel.imagePaths)
        
        collectionView.reloadData()
    }
    
    func updateCollectionViewHeight() {
        viewModel?.reload?(collectionView.numberOfItems(inSection: 0))
    }

    func setupUI() {
        contentView.backgroundColor = .white
        contentView.addSubview(collectionView)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: contentView.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
        updateCollectionViewHeight()
    }
}



