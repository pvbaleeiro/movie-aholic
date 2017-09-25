//
//  DetailMovieViewController.swift
//  movieaholic
//
//  Created by Victor Baleeiro on 24/09/17.
//  Copyright © 2017 Victor Baleeiro. All rights reserved.
//

import UIKit

class DetailMovieViewController: UIViewController {
    
    
    //-------------------------------------------------------------------------------------------------------------
    // MARK: Propriedades
    //-------------------------------------------------------------------------------------------------------------
    var tableIndexPath: IndexPath?
    var cellIndexPath: IndexPath?
    var movieDetail: MovieDetail?
    var movieImages: MovieImage?
    @IBOutlet weak var lblReleaseDate: UILabel!
    @IBOutlet weak var lblRuntime: UILabel!
    @IBOutlet weak var lblTagline: UILabel!
    @IBOutlet weak var lblOverview: UILabel!
    @IBOutlet weak var lblRating: UILabel!
    @IBOutlet weak var lblGenres: UILabel!
    @IBOutlet weak var scrContent: UIScrollView!
    @IBOutlet weak var scrGalery: UIScrollView!
    @IBOutlet weak var viewMovieName: UIView!
    @IBOutlet weak var lblMovieName: UILabel!
    @IBOutlet weak var btnFechar: UIButton!
    @IBOutlet weak var btnFavoritar: UIButton!
    
    
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
        
        //Define layout geral
        self.view.backgroundColor = UIColor.white
    }
    
    func setData() {
        
        //Seta os dados
        lblReleaseDate.text = Dateutil.friendlyDate(date: (movieDetail?.released)!)
        let runtime: Int = (movieDetail?.runtime)!
        lblRuntime.text = String(runtime)
        lblTagline.text = movieDetail?.tagline
        lblOverview.text = movieDetail?.overview
        let rating: Double = (movieDetail?.rating)!
        lblRating.text = String(format: "%.2f", rating)
        let genreText: String! = String.joinedString(withArray: (movieDetail?.genres)!)
        lblGenres.text = genreText
        lblMovieName.text = movieDetail?.title
        makeGalleryImages()
    }
    
    func setText() {
        
    }
    
    
    //-------------------------------------------------------------------------------------------------------------
    // MARK: Acoes
    //-------------------------------------------------------------------------------------------------------------
    @IBAction func closeScreen(_ sender: UIButton?) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func clickOnImage(tapGestureRecognizer: UITapGestureRecognizer) {
        
        //Verifica se o click foi na imagem
        if let imageView = tapGestureRecognizer.view as? UIImageView {
            
            //Vai para a tela de zoom da imagem
            let mainStoryboard = UIStoryboard.init(name: "Main", bundle: nil)
            let zoomController = mainStoryboard.instantiateViewController(withIdentifier: "DetailImageZoomViewController") as! DetailImageZoomViewController
            zoomController.imgReference = imageView.image

            self.present(zoomController, animated: true, completion: nil)
        }
    }
    
    
    //-------------------------------------------------------------------------------------------------------------
    // MARK: Auxiliares
    //-------------------------------------------------------------------------------------------------------------
    func makeGalleryImages() {
        
        //Posição inicial da primeira imagem
        var positionImage = 0
        
        //Varre a lista de posters
        DispatchQueue.global().async {
        for poster in (self.movieImages?.posters)! {
            
            let url = URL(string: Url.endpointTheMovieDbImage.rawValue + poster.filePath!)
                let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
                DispatchQueue.main.async {
                    
                    //Cria gesto de tap para acessar a tela de zoom
                    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.clickOnImage(tapGestureRecognizer:)))
                    
                    //Cria uma ImageView para adicionar
                    let imgGallery = UIImageView(frame: CGRect(x: positionImage, y: 0, width: 300, height: Int(self.scrGalery.frame.height)))
                    imgGallery.image = UIImage(data: data!)
                    imgGallery.contentMode = UIViewContentMode.scaleAspectFill
                    imgGallery.isUserInteractionEnabled = true
                    
                    //Adiciona o gesto
                    imgGallery.addGestureRecognizer(tapGesture)
                    
                    //Adicona a imagem na scroll
                    self.scrGalery.addSubview(imgGallery)
                    self.view.bringSubview(toFront: imgGallery)
                    
                    //Incrementa espacamento
                    positionImage += Int(imgGallery.frame.width)+8
                }
            }
        }
        
        //Define tamanho para a Scroll de acordo com as imagens adicionadas
        self.scrGalery.contentSize = CGSize(width: (self.movieImages?.posters?.count)! * 308, height: Int(self.scrGalery.frame.height))
    }
}


//-------------------------------------------------------------------------------------------------------------
// MARK: ImageExpandAnimationControllerProtocol
//-------------------------------------------------------------------------------------------------------------
extension DetailMovieViewController: ImageExpandAnimationControllerProtocol {
    func getImageDestinationFrame() -> CGRect {
        view.layoutIfNeeded()
        return self.view.frame
    }
}


//-------------------------------------------------------------------------------------------------------------
// MARK: ImageShrinkAnimationControllerProtocol
//-------------------------------------------------------------------------------------------------------------
extension DetailMovieViewController: ImageShrinkAnimationControllerProtocol {
    func getInitialImageFrame() -> CGRect {
        view.layoutIfNeeded()
        return self.view.frame
    }
}
