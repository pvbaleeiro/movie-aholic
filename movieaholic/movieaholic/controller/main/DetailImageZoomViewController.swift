//
//  DetailImageZoomViewController.swift
//  movieaholic
//
//  Created by Victor Baleeiro on 24/09/17.
//  Copyright © 2017 Victor Baleeiro. All rights reserved.
//

import UIKit

class DetailImageZoomViewController: UIViewController {
    
    //-------------------------------------------------------------------------------------------------------------
    // MARK: Propriedades
    //-------------------------------------------------------------------------------------------------------------
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var imgZoom: UIImageView!
    @IBOutlet weak var scrContent: UIScrollView!
    var imgReference: UIImage?

    
    //-------------------------------------------------------------------------------------------------------------
    // MARK: Ciclo de vida
    //-------------------------------------------------------------------------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLayout()
        setData()
        setText()
    }
    
    
    //-------------------------------------------------------------------------------------------------------------
    // MARK: Sets
    //-------------------------------------------------------------------------------------------------------------
    func setLayout() {
        
        //Define zoom max e min para scroll
        self.scrContent.minimumZoomScale = 1.0
        self.scrContent.maximumZoomScale = 6.0
        self.imgZoom.image = imgReference
    }
    
    func setData() {
        
        //Seta os dados
        
    }
    
    func setText() {
        
    }
    
    
    //-------------------------------------------------------------------------------------------------------------
    // MARK: Acoes
    //-------------------------------------------------------------------------------------------------------------
    @IBAction func closeScreen(sender:UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension DetailImageZoomViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imgZoom
    }
}
