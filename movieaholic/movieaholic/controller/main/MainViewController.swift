//
//  MainViewController.swift
//  movieaholic
//
//  Created by Victor Baleeiro on 23/09/17.
//  Copyright © 2017 Victor Baleeiro. All rights reserved.
//
import UIKit

class MainViewController: UITabBarController {
    
    //-------------------------------------------------------------------------------------------------------------
    // MARK: Propriedades
    //-------------------------------------------------------------------------------------------------------------
    var tabBarHeight: CGFloat = 60
    var tabBarTextAttributesNormal = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 8), NSAttributedStringKey.foregroundColor: UIColor.black]
    var tabBarTextAttributesSelected = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 8), NSAttributedStringKey.foregroundColor: UIColor(r: 255, g: 90, b: 95)]
    
    
    //-------------------------------------------------------------------------------------------------------------
    // MARK: Views
    //-------------------------------------------------------------------------------------------------------------
    var tabBarSeparator: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.lightGray
        return view
    }()
    
    var exploreTabItem: UITabBarItem = {
        let icon =  UIImage(named: "Search")
        let tab = UITabBarItem(title: "EXPLORE", image: icon?.tint(with: .black).withRenderingMode(.alwaysOriginal), selectedImage: icon)
        tab.titlePositionAdjustment = UIOffsetMake(0, -5)
        return tab
    }()
    
    lazy var exploreController: ExploreViewController = {
        let controller = ExploreViewController()
        controller.tabBarItem = self.exploreTabItem
        return controller
    }()
    
    
    //-------------------------------------------------------------------------------------------------------------
    // MARK: Ciclo de vida
    //-------------------------------------------------------------------------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLayout()
        setData()
        setText()
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return selectedViewController?.preferredStatusBarUpdateAnimation ?? .fade
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return selectedViewController?.preferredStatusBarStyle ?? .default
    }
    
    override var prefersStatusBarHidden: Bool {
        return selectedViewController?.prefersStatusBarHidden ?? false
    }
    
    
    //-------------------------------------------------------------------------------------------------------------
    // MARK: Sets
    //-------------------------------------------------------------------------------------------------------------
    func setLayout() {
        
        //Define layout tab bar
        // add separator line
        tabBar.clipsToBounds = true // hide default top border
        tabBar.addSubview(tabBarSeparator)
        
        tabBarSeparator.widthAnchor.constraint(equalTo: tabBar.widthAnchor).isActive = true
        tabBarSeparator.heightAnchor.constraint(equalToConstant: 1).isActive = true
        tabBarSeparator.centerXAnchor.constraint(equalTo: tabBar.centerXAnchor).isActive = true
        tabBarSeparator.topAnchor.constraint(equalTo: tabBar.topAnchor).isActive = true
        
        tabBar.tintColor = UIColor.redClear()
        tabBar.barTintColor = UIColor.white
        tabBar.isTranslucent = false
        
        UITabBarItem.appearance().setTitleTextAttributes(tabBarTextAttributesNormal, for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes(tabBarTextAttributesSelected, for: .selected)
    }
    
    func setData() {
        //Controllers da tab bar
        viewControllers = [exploreController]
    }
    
    func setText() {
        
    }
}
