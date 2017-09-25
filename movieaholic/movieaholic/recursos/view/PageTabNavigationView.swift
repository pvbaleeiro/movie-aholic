//
//  PageTabNavigationView.swift
//  movieaholic
//
//  Created by Victor Baleeiro on 24/09/17.
//  Copyright © 2017 Victor Baleeiro. All rights reserved.
//

import UIKit

protocol PageTabNavigationViewDelegate {
    func didSelect(tabItem: PageTabItem, atIndex index: Int, completion: (() -> Void)?)
}

class PageTabNavigationView: UIScrollView {
    var navigationDelegate: PageTabNavigationViewDelegate?
    var pageTabItems = [PageTabItem]()
    
    var titleColor: UIColor = UIColor.white {
        didSet {
            for item in pageTabItems {
                item.titleColor = titleColor
            }
        }
    }
    var selectedTitleColor: UIColor = UIColor.white {
        didSet {
            for item in pageTabItems {
                item.selectedTitleColor = selectedTitleColor
            }
            selectedLineView.backgroundColor = selectedTitleColor
        }
    }
    
    var selectedTabItem: PageTabItem? {
        didSet {
            pageTabSelected()
        }
    }
    var selectedLineCenterXAnchor: NSLayoutConstraint?
    var selectedLineWidthAnchor: NSLayoutConstraint?
    var selectedLineView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.white
        return view
    }()
    
    var backgroundGradientLayer: CAGradientLayer {
        let gradient = CAGradientLayer()
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1, y: 0.5)
        gradient.colors = [UIColor.primaryColor().cgColor, UIColor.primaryColorDark().cgColor]
        return gradient
    }
    
    override var bounds: CGRect {
        didSet {
            backgroundGradientLayer.frame = bounds
        }
    }
    
    init() {
        super.init(frame: CGRect.zero)
        
        backgroundColor = UIColor.primaryColorDark()
        
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
        //        if backgroundGradientLayer.superlayer == nil {
        //            layer.insertSublayer(backgroundGradientLayer, at: 0)
        //        }
    }
    
    func setupViews() {
        showsHorizontalScrollIndicator = false
        alwaysBounceHorizontal = true
        
        addSubview(selectedLineView)
        
        selectedLineView.heightAnchor.constraint(equalToConstant: 2).isActive = true
        // TODO: figure out why using bottomAnchor does not work
        selectedLineView.topAnchor.constraint(equalTo: topAnchor, constant: 50 - 2).isActive = true
        selectedLineCenterXAnchor = selectedLineView.centerXAnchor.constraint(equalTo: centerXAnchor)
        selectedLineCenterXAnchor?.isActive = true
        selectedLineWidthAnchor = selectedLineView.widthAnchor.constraint(equalTo: widthAnchor)
        selectedLineWidthAnchor?.isActive = true
    }
    
    func appendPageTabItem(withTitle title: String) {
        
        let prevTabItem: PageTabItem? = pageTabItems.last
        
        let tabItem = PageTabItem()
        tabItem.translatesAutoresizingMaskIntoConstraints = false
        tabItem.title = title
        tabItem.delegate = self
        
        addSubview(tabItem)
        
        tabItem.leftAnchor.constraint(equalTo: prevTabItem != nil ? prevTabItem!.rightAnchor : leftAnchor).isActive = true
        tabItem.topAnchor.constraint(equalTo: topAnchor).isActive = true
        tabItem.heightAnchor.constraint(equalTo: heightAnchor, constant: -2).isActive = true
        let width = tabItem.title.width(withConstrainedHeight: frame.size.height, font: tabItem.titleButton.titleLabel!.font)
        tabItem.widthAnchor.constraint(equalToConstant: ceil(width) + 50).isActive = true
        
        pageTabItems.append(tabItem)
    }
}

extension PageTabNavigationView: PageTabItemDelegate {
    func didSelect(tabItem: PageTabItem, completion: (() -> Void)?) {
        if let index = pageTabItems.index(of: tabItem) {
            navigationDelegate?.didSelect(tabItem: tabItem, atIndex: index) {
                
                self.animatePageTabSelection(toIndex: index)
                
                if let handler = completion {
                    handler()
                }
            }
        }
    }
    
    func animatePageTabSelection(toIndex index: Int) {
        if index >= 0, index < self.pageTabItems.count {
            selectedTabItem = self.pageTabItems[index]
        }
    }
    
    func pageTabSelected() {
        for item in pageTabItems {
            if item != selectedTabItem {
                item.isSelected = false
            }
        }
        
        selectedTabItem?.isSelected = true
        
        if  selectedTabItem != nil {
            self.layoutIfNeeded()
            UIView.animate(withDuration: 0.2, animations: {
                self.selectedLineCenterXAnchor?.isActive = false
                self.selectedLineCenterXAnchor = self.selectedLineView.centerXAnchor.constraint(equalTo: self.selectedTabItem!.centerXAnchor)
                self.selectedLineCenterXAnchor?.isActive = true
                
                self.selectedLineWidthAnchor?.isActive = false
                self.selectedLineWidthAnchor = self.selectedLineView.widthAnchor.constraint(equalTo: self.selectedTabItem!.widthAnchor, constant: -30)
                self.selectedLineWidthAnchor?.isActive = true
                
                self.layoutIfNeeded()
            })
        }
    }
}

