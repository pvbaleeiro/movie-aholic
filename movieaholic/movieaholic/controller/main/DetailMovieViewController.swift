//
//  DetailMovieViewController.swift
//  movieaholic
//
//  Created by Victor Baleeiro on 24/09/17.
//  Copyright © 2017 Victor Baleeiro. All rights reserved.
//

import UIKit

//-------------------------------------------------------------------------------------------------------------
// MARK: Enum / Constantes
//-------------------------------------------------------------------------------------------------------------
enum DetailMovieViewControllerText: String {
    case favoritar = "FAVORITAR"
    case desfavoritar = "DESFAVORITAR"
}


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
    @IBOutlet weak var imgFavorite: UIImageView!
    
    //-------------------------------------------------------------------------------------------------------------
    // MARK: Ciclo de vida
    //-------------------------------------------------------------------------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLayout()
        setData()
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
        if let value = movieDetail?.favorite, value {
            imgFavorite.image = imgFavorite.image?.tint(with: UIColor.red)
            btnFavoritar.setTitle(DetailMovieViewControllerText.desfavoritar.rawValue, for: UIControlState.normal)
        } else {
            imgFavorite.image = imgFavorite.image?.tint(with: UIColor.white)
            btnFavoritar.setTitle(DetailMovieViewControllerText.favoritar.rawValue, for: UIControlState.normal)
        }
        makeGalleryImages()
    }
    
    
    //-------------------------------------------------------------------------------------------------------------
    // MARK: Acoes
    //-------------------------------------------------------------------------------------------------------------
    @IBAction func closeScreen(_ sender: UIButton?) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func favoriteMovie(_sender: UIButton?) {
        
        if let value = movieDetail?.favorite, value {
            //Inverte
            imgFavorite.image = imgFavorite.image?.tint(with: UIColor.white)
            btnFavoritar.setTitle(DetailMovieViewControllerText.favoritar.rawValue, for: UIControlState.normal)
            movieDetail?.favorite = false
            SessionManager.sharedInstance.saveDetailMovie(detailMovie: movieDetail, forId: movieDetail!.ids?.trakt)
        } else {
            imgFavorite.image = imgFavorite.image?.tint(with: UIColor.red)
            btnFavoritar.setTitle(DetailMovieViewControllerText.desfavoritar.rawValue, for: UIControlState.normal)
            movieDetail?.favorite = true
            SessionManager.sharedInstance.saveDetailMovie(detailMovie: movieDetail, forId: movieDetail!.ids?.trakt)
        }
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
        for poster in (self.movieImages?.posters)! {
            
            //Cria gesto de tap para acessar a tela de zoom
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.clickOnImage(tapGestureRecognizer:)))
            
            //Cria uma ImageView para adicionar
            let imgGallery = UIImageView(frame: CGRect(x: positionImage, y: 0, width: 300, height: Int(self.scrGalery.frame.height)))
            let url = URL(string: Url.endpointTheMovieDbImage.rawValue + poster.filePath!)
            APIMovie.getImage(fromUrl: url!, forImageView: imgGallery)
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
