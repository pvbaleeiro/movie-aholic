//
//  BasePageTabItemView.swift
//  movieaholic
//
//  Created by Victor Baleeiro on 24/09/17.
//  Copyright © 2017 Victor Baleeiro. All rights reserved.
//

import UIKit

class BasePageTabItemView: UIView {
    
    //-------------------------------------------------------------------------------------------------------------
    // MARK: Ciclo de vida
    //-------------------------------------------------------------------------------------------------------------
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    override func layoutSubviews() {
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        
    }
}

