//
//  CategoryTableViewCell.swift
//  movieaholic
//
//  Created by Victor Baleeiro on 23/09/17.
//  Copyright © 2017 Victor Baleeiro. All rights reserved.
//

import UIKit

//-------------------------------------------------------------------------------------------------------------
// MARK: Delegate
//-------------------------------------------------------------------------------------------------------------
protocol CategoryTableViewCellDelegate {
    func categoryTableCell(_ tableCell: CategoryTableViewCell, collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
}

class CategoryTableViewCell: BaseTableViewCell {
    
    //-------------------------------------------------------------------------------------------------------------
    // MARK: Propriedades
    //-------------------------------------------------------------------------------------------------------------
    let cellID = "cellID"
    var indexPath: IndexPath?
    var layoutSubviewFirstTime: Bool = true
    var delegate: CategoryTableViewCellDelegate?
    var items: [MovieTrending] = [MovieTrending]() {
        didSet {
            collectionView.reloadData()
        }
    }
    var title: String? {
        didSet {
            titleLabel.text = title
        }
    }
    
    
    //-------------------------------------------------------------------------------------------------------------
    // MARK: Views
    //-------------------------------------------------------------------------------------------------------------
    var titleLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.boldSystemFont(ofSize: 16)
        return view
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.itemSize = CGSize(width: 280, height: 230)
        
        let view = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.white
        view.register(HomeItemCell.self, forCellWithReuseIdentifier: self.cellID)
        view.showsHorizontalScrollIndicator = false
        view.dataSource = self
        view.delegate = self
        return view
    }()
    
    
    //-------------------------------------------------------------------------------------------------------------
    // MARK: Ciclo de vida
    //-------------------------------------------------------------------------------------------------------------
    override func setupViews() {
        super.setupViews()
        
        addSubview(titleLabel)
        
        titleLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        titleLabel.widthAnchor.constraint(equalTo: widthAnchor, constant: -30).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        addSubview(collectionView)
        
        collectionView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor).isActive = true
        collectionView.heightAnchor.constraint(equalToConstant: 250).isActive = true
        collectionView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if layoutSubviewFirstTime {
            layoutSubviewFirstTime = false
        }
    }
}


//-------------------------------------------------------------------------------------------------------------
// MARK: UICollectionViewDataSource
//-------------------------------------------------------------------------------------------------------------
extension CategoryTableViewCell: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! HomeItemCell
        
        cell.movie = items[indexPath.item]
        cell.viewLoading.startShimmering()
        cell.loadImage()
        return cell
    }
}


//-------------------------------------------------------------------------------------------------------------
// MARK: UICollectionViewDelegate
//-------------------------------------------------------------------------------------------------------------
extension CategoryTableViewCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let del = delegate {
            del.categoryTableCell(self, collectionView: collectionView, didSelectItemAt: indexPath)
        }
    }
}
