//
//  HomeItemCell.swift
//  movieaholic
//
//  Created by Victor Baleeiro on 23/09/17.
//  Copyright © 2017 Victor Baleeiro. All rights reserved.
//

import UIKit

class HomeItemCell: BaseCollectionViewCell {
    
    //-------------------------------------------------------------------------------------------------------------
    // MARK: Propriedades
    //-------------------------------------------------------------------------------------------------------------
    var movie: MovieTrending? {
        didSet {
            let year : Int = (movie?.movie?.year)!
            lblYear.text = String(year)
            lblDescription.text = movie?.movie?.title
            let watchers : Int = (movie?.watchers)!
            lblWatchers.text = String(watchers) + " Watchers"
        }
    }
    
    var homeDescription: String? {
        didSet {
            lblDescription.text = homeDescription
        }
    }
    
    
    //-------------------------------------------------------------------------------------------------------------
    // MARK: Viewa
    //-------------------------------------------------------------------------------------------------------------
    var imgPoster: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        return view
    }()
    
    var viewLoading: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        return view
    }()
    
    var lblYear: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.boldSystemFont(ofSize: 14)
        view.textColor = UIColor.black
        return view
    }()
    
    var lblDescription: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.systemFont(ofSize: 14)
        view.textColor = UIColor.gray
        return view
    }()
    
    var lblWatchers: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.boldSystemFont(ofSize: 10)
        view.textColor = UIColor.darkGray
        return view
    }()
    
    
    //-------------------------------------------------------------------------------------------------------------
    // MARK: Ciclo de vida
    //-------------------------------------------------------------------------------------------------------------
    override func setLayout() {
   
        addSubview(imgPoster)
        imgPoster.topAnchor.constraint(equalTo: topAnchor).isActive = true
        imgPoster.heightAnchor.constraint(equalToConstant: 180).isActive = true
        imgPoster.leftAnchor.constraint(equalTo: leftAnchor, constant: 15).isActive = true
        imgPoster.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        imgPoster.addSubview(viewLoading)
        
        addSubview(lblYear)
        lblYear.topAnchor.constraint(equalTo: imgPoster.bottomAnchor, constant: 10).isActive = true
        lblYear.heightAnchor.constraint(equalToConstant: 20).isActive = true
        lblYear.leftAnchor.constraint(equalTo: leftAnchor, constant: 15).isActive = true
        lblYear.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        addSubview(lblDescription)
        lblDescription.topAnchor.constraint(equalTo: imgPoster.bottomAnchor, constant: 10).isActive = true
        lblDescription.heightAnchor.constraint(equalToConstant: 20).isActive = true
        lblDescription.leftAnchor.constraint(equalTo: lblYear.rightAnchor).isActive = true
        lblDescription.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        
        addSubview(lblWatchers)
        lblWatchers.topAnchor.constraint(equalTo: lblYear.bottomAnchor, constant: 0).isActive = true
        lblWatchers.heightAnchor.constraint(equalToConstant: 20).isActive = true
        lblWatchers.leftAnchor.constraint(equalTo: lblYear.leftAnchor, constant: 0).isActive = true
        lblWatchers.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
    }
    
    //-------------------------------------------------------------------------------------------------------------
    // MARK: Carrega dados web
    //-------------------------------------------------------------------------------------------------------------
    func loadImage() {
        
        //Buscando a imagem...
        let tmdbId : Int = (self.movie?.movie?.ids?.tmdb)!
        APIMovie.getImagesMovies(tmdbId: tmdbId) {
            (response) in
            
            switch response {
            case .onSuccess(let imageDetail as MovieImageDetail):
                
                //Obtem imagem
                let url = URL(string: Url.endpointTheMovieDbImage.rawValue + imageDetail.filePath!)
                self.viewLoading.stopShimmering()
                APIMovie.getImage(fromUrl: url!, forImageView: self.imgPoster)
                break
                
            case .onError(let erro):
                self.viewLoading.stopShimmering()
                print(erro)
                break
                
            case .onNoConnection():
                self.viewLoading.stopShimmering()
                print("Sem conexão")
                break
                
            default: break
            }
        }
    }
}

