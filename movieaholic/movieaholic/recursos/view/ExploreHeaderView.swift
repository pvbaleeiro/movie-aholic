//
//  ExploreHeaderView.swift
//  movieaholic
//
//  Created by Victor Baleeiro on 24/09/17.
//  Copyright © 2017 Victor Baleeiro. All rights reserved.
//

import UIKit

//-------------------------------------------------------------------------------------------------------------
// MARK: Delegate
//-------------------------------------------------------------------------------------------------------------
protocol ExploreHeaderViewDelegate {
    func didSelect(viewController: UIViewController, completion: (() -> Void)?)
    func didCollapseHeader(completion: (() -> Void)?)
    func didExpandHeader(completion: (() -> Void)?)
}

class ExploreHeaderView: UIView {
    
    //-------------------------------------------------------------------------------------------------------------
    // MARK: Propriedades
    //-------------------------------------------------------------------------------------------------------------
    override var bounds: CGRect {
        didSet {
            backgroundGradientLayer.frame = bounds
        }
    }
    
    var delegate: UIViewController? {
        didSet {
        }
    }
    
    lazy var backgroundGradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.startPoint = CGPoint(x: 0, y: 0.5)
        layer.endPoint = CGPoint(x: 1, y: 0.5)
        layer.colors = self.backgroundGradient
        return layer
    }()
    
    var whiteOverlayView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.white
        view.alpha = 0
        return view
    }()
    
    var backgroundGradient: [CGColor] = [UIColor.primaryColor().cgColor, UIColor.primaryColorDark().cgColor]
    
    var pageTabDelegate: ExploreHeaderViewDelegate?
    var pageTabControllers = [UIViewController]() {
        didSet {
            setupPagers()
        }
    }
    let pageTabHeight: CGFloat = 50
    
    let headerInputHeight: CGFloat = 50
    
    var minHeaderHeight: CGFloat {
        return 20 // status bar
            + pageTabHeight
    }
    var midHeaderHeight: CGFloat {
        return 20 + 10 // status bar + spacing
            + headerInputHeight // input 1
            + pageTabHeight
    }
    var maxHeaderHeight: CGFloat {
        return 20 + 10 // status bar + spacing
            + 50 // collapse button
            + 50 + 10 // input 1 + spacing
            + 50 + 10 // input 2 + spacing
            + 50 // input 3
            + 50 // page tabs
    }
    
    let collapseButtonHeight: CGFloat = 40
    let collapseButtonMaxTopSpacing: CGFloat = 20 + 10
    let collapseButtonMinTopSpacing: CGFloat = 0
    
    var collapseButtonTopConstraint: NSLayoutConstraint?
    
    lazy var collapseButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "collapse"), for: .normal)
        button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.contentHorizontalAlignment = .center
        button.addTarget(self, action: #selector(ExploreHeaderView.handleCollapse), for: .touchUpInside)
        return button
    }()
    
    var destinationFilterTopConstraint: NSLayoutConstraint?
    
    lazy var summaryFilter: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.backgroundColor = UIColor.primaryColor()
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
        btn.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        btn.adjustsImageWhenHighlighted = false
        btn.addTarget(self, action: #selector(ExploreHeaderView.handleExpand), for: .touchUpInside)
        
        let img = UIImage(named: "Search")
        btn.setImage(img, for: .normal)
        btn.imageView?.contentMode = .scaleAspectFit
        
        btn.setTitle("Search • Places • News", for: .normal)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        btn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        btn.titleLabel?.lineBreakMode = .byTruncatingTail
        return btn
    }()
    
    lazy var searchBarFilter: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.backgroundColor = UIColor.primaryColor()
        searchBar.showsCancelButton = true
        return searchBar
    }()
    
    lazy var btnNews: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.backgroundColor = UIColor.primaryColor()
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
        btn.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        btn.adjustsImageWhenHighlighted = false
        btn.addTarget(self, action: #selector(ExploreHeaderView.funcNotImplemented), for: .touchUpInside)
        btn.imageView?.contentMode = .scaleAspectFit
        
        btn.setTitle("News", for: .normal)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        btn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        btn.titleLabel?.lineBreakMode = .byTruncatingTail
        return btn
    }()
    
    lazy var btnPrincipal: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.backgroundColor = UIColor.primaryColor()
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
        btn.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        btn.adjustsImageWhenHighlighted = false
        btn.imageView?.contentMode = .scaleAspectFit
        
        btn.setTitle("Principal", for: .normal)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        btn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        btn.titleLabel?.lineBreakMode = .byTruncatingTail
        return btn
    }()
    
    var pagerView: PageTabNavigationView = {
        let view = PageTabNavigationView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    init() {
        super.init(frame: CGRect.zero)
        
        backgroundColor = UIColor.primaryColorDark()
        
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        
        addSubview(collapseButton)
        
        collapseButton.heightAnchor.constraint(equalToConstant: collapseButtonHeight).isActive = true
        collapseButtonTopConstraint = collapseButton.topAnchor.constraint(equalTo: topAnchor, constant: collapseButtonMaxTopSpacing)
        collapseButtonTopConstraint?.isActive = true
        collapseButton.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
        collapseButton.widthAnchor.constraint(equalToConstant: collapseButtonHeight).isActive = true
        
        addSubview(searchBarFilter)
        
        searchBarFilter.heightAnchor.constraint(equalToConstant: 50).isActive = true
        destinationFilterTopConstraint = searchBarFilter.topAnchor.constraint(equalTo: topAnchor, constant: collapseButtonHeight + collapseButtonMaxTopSpacing + 10)
        destinationFilterTopConstraint?.isActive = true
        searchBarFilter.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        searchBarFilter.widthAnchor.constraint(equalTo: widthAnchor, constant: -20).isActive = true
        
        addSubview(summaryFilter)
        
        summaryFilter.heightAnchor.constraint(equalToConstant: 50).isActive = true
        summaryFilter.topAnchor.constraint(equalTo: searchBarFilter.topAnchor).isActive = true
        summaryFilter.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        summaryFilter.widthAnchor.constraint(equalTo: widthAnchor, constant: -20).isActive = true
        summaryFilter.alpha = 0
        
        addSubview(btnNews)
        
        btnNews.heightAnchor.constraint(equalToConstant: 50).isActive = true
        btnNews.topAnchor.constraint(equalTo: searchBarFilter.bottomAnchor, constant: 10).isActive = true
        btnNews.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        btnNews.widthAnchor.constraint(equalTo: widthAnchor, constant: -20).isActive = true
        
        addSubview(btnPrincipal)
        
        btnPrincipal.heightAnchor.constraint(equalToConstant: 50).isActive = true
        btnPrincipal.topAnchor.constraint(equalTo: btnNews.bottomAnchor, constant: 10).isActive = true
        btnPrincipal.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        btnPrincipal.widthAnchor.constraint(equalTo: widthAnchor, constant: -20).isActive = true
        
        addSubview(whiteOverlayView)
        
        whiteOverlayView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        whiteOverlayView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        whiteOverlayView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        whiteOverlayView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
    }
    
    func setupPagers() {
        // TODO: remove all subviews
        
        addSubview(pagerView)
        
        pagerView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        pagerView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        pagerView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        pagerView.heightAnchor.constraint(equalToConstant: pageTabHeight).isActive = true
        
        for vc in pageTabControllers {
            pagerView.appendPageTabItem(withTitle: vc.title ?? "")
            pagerView.navigationDelegate = self
            if (searchBarFilter.delegate == nil) {
                searchBarFilter.delegate = vc as? UISearchBarDelegate
            }
        }
    }
    
    override func layoutSubviews() {
    }
    
    public func updateHeader(newHeight: CGFloat, offset: CGFloat) {
        let headerBottom = newHeight - pageTabHeight
        
        let midMaxPercentage = (newHeight - midHeaderHeight) / (maxHeaderHeight - midHeaderHeight)
        btnNews.alpha = midMaxPercentage
        
        var datePickerPercentage3 = (headerBottom - btnPrincipal.frame.origin.y) / btnPrincipal.frame.height
        datePickerPercentage3 = max(0, min(1, datePickerPercentage3)) // capped between 0 and 1
        btnPrincipal.alpha = datePickerPercentage3
        
        collapseButton.alpha = datePickerPercentage3
        
        var collapseButtonTopSpacingPercentage = (headerBottom - searchBarFilter.frame.origin.y) / (btnPrincipal.frame.origin.y + btnPrincipal.frame.height - searchBarFilter.frame.origin.y)
        collapseButtonTopSpacingPercentage = max(0, min(1, collapseButtonTopSpacingPercentage))
        collapseButtonTopConstraint?.constant = collapseButtonTopSpacingPercentage * collapseButtonMaxTopSpacing
        
        summaryFilter.setTitle("\("Search") • \(btnNews.titleLabel!.text!) • \(btnPrincipal.titleLabel!.text!)", for: .normal)
        
        if newHeight > midHeaderHeight {
            searchBarFilter.alpha = collapseButtonTopSpacingPercentage
            destinationFilterTopConstraint?.constant = max(UIApplication.shared.statusBarFrame.height + 10,collapseButtonTopSpacingPercentage * (collapseButtonHeight + collapseButtonMaxTopSpacing + 10))
            summaryFilter.alpha = 1 - collapseButtonTopSpacingPercentage
            whiteOverlayView.alpha = 0
            
            pagerView.backgroundColor = UIColor.primaryColorDark()
            pagerView.titleColor = UIColor.white
            pagerView.selectedTitleColor = UIColor.white
            
        } else if newHeight == midHeaderHeight {
            destinationFilterTopConstraint?.constant = UIApplication.shared.statusBarFrame.height + 10
            searchBarFilter.alpha = 0
            summaryFilter.alpha = 1
            whiteOverlayView.alpha = 0
            
            pagerView.backgroundColor = UIColor.primaryColorDark()
            pagerView.titleColor = UIColor.white
            pagerView.selectedTitleColor = UIColor.white
            
        } else {
            destinationFilterTopConstraint?.constant = destinationFilterTopConstraint!.constant - offset
            let minMidPercentage = (newHeight - minHeaderHeight) / (midHeaderHeight - minHeaderHeight)
            searchBarFilter.alpha = 0
            summaryFilter.alpha = minMidPercentage
            
            whiteOverlayView.alpha = 1 - minMidPercentage
            pagerView.backgroundColor = UIColor.fade(fromColor: UIColor.primaryColorDark(), toColor: UIColor.white, withPercentage: 1 - minMidPercentage)
            pagerView.titleColor = UIColor.fade(fromColor: UIColor.white, toColor: UIColor.darkGray, withPercentage: 1 - minMidPercentage)
            pagerView.selectedTitleColor = UIColor.fade(fromColor: UIColor.white, toColor: UIColor.primaryColor(), withPercentage: 1 - minMidPercentage)
        }
    }
    
    @objc func handleCollapse() {
        pageTabDelegate?.didCollapseHeader(completion: nil)
    }
    
    @objc func handleExpand() {
        pageTabDelegate?.didExpandHeader(completion: nil)
    }
    
    @objc func funcNotImplemented() {
        let alertView = UIAlertController(title: "Aviso", message: "Essa funcionalidade ainda não foi implementada", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: { (alert) in
            NSLog("OK clicado")
        })
        alertView.addAction(action)
        
        //Exibe alerta
        let controller = delegate
        controller?.present(alertView, animated: true, completion: nil)
    }
}


//-------------------------------------------------------------------------------------------------------------
// MARK: PageTabNavigationViewDelegate
//-------------------------------------------------------------------------------------------------------------
extension ExploreHeaderView: PageTabNavigationViewDelegate {
    func didSelect(tabItem: PageTabItem, atIndex index: Int, completion: (() -> Void)?) {
        if index >= 0, index < pageTabControllers.count {
            pageTabDelegate?.didSelect(viewController: pageTabControllers[index]) {
                if let handler = completion {
                    handler()
                }
            }
        }
    }
    
    func animatePageTabSelection(toIndex index: Int) {
        pagerView.animatePageTabSelection(toIndex: index)
    }
}

