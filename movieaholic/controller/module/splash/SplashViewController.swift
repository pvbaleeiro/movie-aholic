//
//  SplashViewController.swift
//  Movieaholic
//
//  Created by Victor Baleeiro on 01/11/18.
//  Copyright © 2018 Victor Baleeiro. All rights reserved.
//

import Foundation
import UIKit
import Fluky

class SplashViewController: BaseViewController {
    
    // MARK: Properties
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: Setup
    override func setupLayout() {
        super.setupLayout()
        
        let images = [ UIImage(named: "icon1")!, UIImage(named: "icon2")!, UIImage(named: "icon3")!, UIImage(named: "icon4")!]
        self.view.backgroundColor = UIColor.primaryColor()
        
        let linear = Fluky.view(as: .linear, with: images)
        let flukyViews = [linear]
        
        flukyViews.forEach {
            self.view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate(
            [
                linear.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                linear.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                linear.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                linear.heightAnchor.constraint(equalToConstant: 60.0)
            ]
        )
        
        flukyViews.forEach { $0.start() }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 10, execute: { flukyViews.forEach { $0.stop() } })
    }
}
