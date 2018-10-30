//
//  BaseViewController.swift
//  Movieaholic
//
//  Created by Victor Baleeiro on 30/10/18.
//  Copyright © 2018 Victor Baleeiro. All rights reserved.
//

import UIKit
import Fluky

class BaseViewController: UIViewController {
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setup
        self.setupLayout()
    }
    
    // MARK: Setup
    func setupLayout() {
        
        let images = [UIImage(named: "icon1")!, UIImage(named: "icon2")!, UIImage(named: "icon3")!, UIImage(named: "icon4")!]
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.png")!)
        
        let single = Fluky.view(as: .single, with: images)
        let linear = Fluky.view(as: .linear, with: images)
        let box = Fluky.view(as: .box, with: images)
        
        let flukyViews = [single, linear, box]
        
        flukyViews.forEach {
            self.view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate(
            [
                single.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                single.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                single.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                single.heightAnchor.constraint(equalToConstant: 60.0),
                
                linear.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                linear.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                linear.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                linear.heightAnchor.constraint(equalToConstant: 60.0),
                
                box.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                box.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                box.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                box.heightAnchor.constraint(equalToConstant: 80.0)
            ]
        )
        
        flukyViews.forEach { $0.start() }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 10, execute: { flukyViews.forEach { $0.stop() } })
    }
}
