//
//  ScrollView+Util.swift
//  movieaholic
//
//  Created by Victor Baleeiro on 25/09/17.
//  Copyright © 2017 Victor Baleeiro. All rights reserved.
//

import UIKit

extension UIScrollView {
    
    // Exposes a _refreshControl property to iOS versions anterior to iOS 10
    // Use _refreshControl and refreshControl intercheangeably in a UIScrollView (get + set)
    //
    // All iOS versions: `bounces` is always required if `contentSize` is smaller than `frame`
    // Pre iOS 10 versions: `alwaysBounceVertical` is also required for small content
    // Only iOS 10 allows the refreshControl to work without drifting when pulled to refresh
    var _refreshControl : UIRefreshControl? {
        get {
            if #available(iOS 10.0, *) {
                return refreshControl
            } else {
                return subviews.first(where: { (view: UIView) -> Bool in
                    view is UIRefreshControl
                }) as? UIRefreshControl
            }
        }
        
        set {
            if #available(iOS 10.0, *) {
                refreshControl = newValue
            } else {
                // Unique instance of UIRefreshControl added to subviews
                if let oldValue = _refreshControl {
                    oldValue.removeFromSuperview()
                }
                if let newValue = newValue {
                    insertSubview(newValue, at: 0)
                }
            }
        }
    }
    
    // Creates and adds a UIRefreshControl to this UIScrollView
    func addRefreshControl(target: Any?, action: Selector) -> UIRefreshControl {
        let control = UIRefreshControl()
        addRefresh(control: control, target: target, action: action)
        return control
    }
    
    // Adds the UIRefreshControl passed as parameter to this UIScrollView
    func addRefresh(control: UIRefreshControl, target: Any?, action: Selector) {
        if #available(iOS 9.0, *) {
            control.addTarget(target, action: action, for: .primaryActionTriggered)
        } else {
            control.addTarget(target, action: action, for: .valueChanged)
        }
        _refreshControl = control
    }
}
