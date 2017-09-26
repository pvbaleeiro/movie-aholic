//
//  SessionManager.swift
//  movieaholic
//
//  Created by Victor Baleeiro on 24/09/17.
//  Copyright © 2017 Victor Baleeiro. All rights reserved.
//

import Foundation
import ObjectMapper

//-------------------------------------------------------------------------------------------------------------
// MARK: CONSTANTES / ENUMS
//-------------------------------------------------------------------------------------------------------------
enum DefaultKey: String {
    case lastSearchTrending = "last-search-trending"
    case lastSearchImages = "last-search-images"
    case lastSearchDetail = "last-search-detail"
    case images = "movie-images-%d"
    case trending = "movie-tending-%d"
    case detail = "movie-detail-%d"
}

enum Time: Int {
    case intervalToSearch = 24
}


class SessionManager {
    static let sharedInstance = SessionManager()
    
    //-------------------------------------------------------------------------------------------------------------
    // MARK: Trending movies
    //-------------------------------------------------------------------------------------------------------------
    func lastDateSearchTrendingMovies() -> Date? {
        let userDefaults = UserDefaults.standard
        let lastSearchTrending = userDefaults.object(forKey: DefaultKey.lastSearchTrending.rawValue) as? Date
        NSLog("Objeto resgatado das preferencias!")
        return lastSearchTrending
    }
    
    func updateLastDateSearchTrendingMovies() {
        let userDefaults = UserDefaults.standard
        userDefaults.setValue(Date(), forKey: DefaultKey.lastSearchTrending.rawValue)
        userDefaults.synchronize()
        NSLog("Objeto armazenado nas preferencias!")
    }
    
    func saveTrendingMovies(trendingMovies: NSMutableArray!) {
        //Remove o conteudo atual
        removeTrendingMovies()
        //Armazena objetos
        let userDefaults = UserDefaults.standard
        for movieTrending in (trendingMovies as NSMutableArray as! [MovieTrending]) {
            userDefaults.setValue(movieTrending.toJSONString(), forKey: String(format:DefaultKey.trending.rawValue, (movieTrending.movie!.ids?.tmdb)!))
            userDefaults.synchronize()
            NSLog("Objeto armazenado nas preferencias!")
        }
    }
    
    func getTrendingMovies() -> NSMutableArray? {
        let userDefaults = UserDefaults.standard
        let trendingMovies: NSMutableArray = []
        for (key, value) in userDefaults.dictionaryRepresentation() {
            if (key.contains("movie-tending")) {
                let movieTrending = Mapper<MovieTrending>().map(JSONString: value as! String)
                trendingMovies.add(movieTrending as Any)
                NSLog("Objeto resgatado das preferencias!")
            }
        }
        
        return (trendingMovies.count > 0) ? trendingMovies : nil
    }
    
    func removeTrendingMovies() {
        let userDefaults = UserDefaults.standard
        for (key, _) in userDefaults.dictionaryRepresentation() {
            if (key.contains("movie-tending")) {
                userDefaults.removeObject(forKey: key)
                NSLog("Objeto removido das preferencias!")
            }
        }
    }
    
    
    //-------------------------------------------------------------------------------------------------------------
    // MARK: Imagens
    //-------------------------------------------------------------------------------------------------------------
    func lastDateSearchImagesMovies() -> Date? {
        let userDefaults = UserDefaults.standard
        let lastSearchTrending = userDefaults.object(forKey: DefaultKey.lastSearchImages.rawValue) as? Date
        NSLog("Objeto resgatado das preferencias!")
        return lastSearchTrending
    }
    
    func updateLastDateSearchImagesMovies() {
        let userDefaults = UserDefaults.standard
        userDefaults.setValue(Date(), forKey: DefaultKey.lastSearchImages.rawValue)
        userDefaults.synchronize()
        NSLog("Objeto armazenado nas preferencias!")
    }
    
    func saveImageMovies(imageMovies: MovieImage?, forId: Int!) {
        let userDefaults = UserDefaults.standard
        userDefaults.setValue(imageMovies?.toJSONString(), forKey: String(format:DefaultKey.images.rawValue, forId))
        userDefaults.synchronize()
        NSLog("Objeto armazenado nas preferencias!")
        
    }
    
    func getImageMovies(forId: Int!) -> MovieImage? {
        let userDefaults = UserDefaults.standard
        let keyValue: String? = userDefaults.value(forKey: String(format:DefaultKey.images.rawValue, forId)) as? String
        let movieImage = Mapper<MovieImage>().map(JSONString: keyValue ?? "")
        NSLog("Objeto resgatado das preferencias!")
        return movieImage
    }
    
    
    //-------------------------------------------------------------------------------------------------------------
    // MARK: Detalhes
    //-------------------------------------------------------------------------------------------------------------
    func lastDateSearchDetailMovies() -> Date? {
        let userDefaults = UserDefaults.standard
        let lastSearchDetail = userDefaults.object(forKey: DefaultKey.lastSearchDetail.rawValue) as? Date
        NSLog("Objeto resgatado das preferencias!")
        return lastSearchDetail
    }
    
    func updateLastDateDetailImagesMovies() {
        let userDefaults = UserDefaults.standard
        userDefaults.setValue(Date(), forKey: DefaultKey.lastSearchDetail.rawValue)
        userDefaults.synchronize()
        NSLog("Objeto armazenado nas preferencias!")
    }
    
    func saveDetailMovie(detailMovie: MovieDetail?, forId: Int!) {
        let userDefaults = UserDefaults.standard
        userDefaults.setValue(detailMovie?.toJSONString(), forKey: String(format:DefaultKey.detail.rawValue, forId))
        userDefaults.synchronize()
        NSLog("Objeto armazenado nas preferencias!")
    }
    
    func getDetailMovie(forId: Int!) -> MovieDetail? {
        let userDefaults = UserDefaults.standard
        let keyValue: String? = userDefaults.value(forKey: String(format:DefaultKey.detail.rawValue, forId)) as? String
        let movieDetail = Mapper<MovieDetail>().map(JSONString: keyValue ?? "")
        NSLog("Objeto resgatado das preferencias!")
        return movieDetail
    }
    
    func getFavoritesDetailMovie() -> NSMutableArray? {
        let userDefaults = UserDefaults.standard
        let favoriteMovies: NSMutableArray = []
        for (key, value) in userDefaults.dictionaryRepresentation() {
            if (key.contains("movie-detail")) {
                let favoriteMovie = Mapper<MovieDetail>().map(JSONString: value as! String)
                let trending = trendingForDetail(movieDetail: favoriteMovie!)
                favoriteMovies.add(trending as Any)
                NSLog("Objeto resgatado das preferencias!")
            }
        }
        
        return (favoriteMovies.count > 0) ? favoriteMovies : nil
    }
    
    
    //-------------------------------------------------------------------------------------------------------------
    // MARK: Auxiliares
    //-------------------------------------------------------------------------------------------------------------
    func trendingForDetail(movieDetail: MovieDetail) -> MovieTrending? {
        
        let trendingMovies: NSMutableArray? = getTrendingMovies()
        for movieTrending in (trendingMovies as NSMutableArray? as! [MovieTrending]) {
            if (movieTrending.movie?.ids?.tmdb == movieDetail.ids?.tmdb) {
                return movieTrending
            }
        }
        
        return nil
    }
    
    
    //-------------------------------------------------------------------------------------------------------------
    // MARK: Social/Others share
    //-------------------------------------------------------------------------------------------------------------
    func shareWithSocial(onController: UIViewController, activityItem: [AnyObject]) {
        
        let activityViewController = UIActivityViewController(
            activityItems: activityItem,
            applicationActivities: nil)
        
        onController.present(activityViewController, animated: true, completion: nil)
    }
}
