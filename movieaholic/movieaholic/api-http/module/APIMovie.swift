//
//  APIMovie.swift
//  movieaholic
//
//  Created by Victor Baleeiro on 22/09/17.
//  Copyright © 2017 Victor Baleeiro. All rights reserved.
//

import Foundation
import ObjectMapper
import Alamofire

class APIMovie {
    
    //-------------------------------------------------------------------------------------------------------------
    // MARK: Métodos
    //-------------------------------------------------------------------------------------------------------------
    class func getTrendingMovies(completion: ((Response<Any>)->())? = nil) {
        
        //Primeiro verifica se há mesmo a necessidade da busca dos dados
        let trendingStoredList = SessionManager.sharedInstance.getTrendingMovies()
        let lastSearch = SessionManager.sharedInstance.lastDateSearchTrendingMovies()
        if (lastSearch == nil || trendingStoredList == nil || Date.hoursBetween(initialDate: lastSearch, finalDate: Date()) > Time.intervalToSearch.rawValue) {
            
            //Monta url a ser chamada
            let url: URLConvertible = URL(string: String(Url.endpointTrackt.rawValue + Movies.trending.rawValue))!
            
            //Faz a chamada web
            APIManager.sharedInstance.customRequest(httpMethod: .get, url: url, parameters: nil, headers: ConfigManager.sharedInstance.getDefaultHeaders()) { (response) -> () in
                
                //Sem conexão, avisar para a tela
                if (!response.connected) {
                    completion!(Response.onNoConnection())
                    
                } else if (response.objectFromServer != nil) {
                    
                    //Conversões
                    let trendingList: NSArray = response.objectFromServer as! NSArray
                    let trendingFinalList: NSMutableArray = []
                    for moviesTrending in trendingList {
                        let movie = Mapper<MovieTrending>().map(JSONObject: moviesTrending)
                        trendingFinalList.add(movie!)
                    }
                    
                    //Armazena a lista e horário em "cache"
                    SessionManager.sharedInstance.saveTrendingMovies(trendingMovies: trendingFinalList)
                    SessionManager.sharedInstance.updateLastDateSearchTrendingMovies()
                    
                    //Responde para a tela
                    completion!(Response.onSuccess(trendingFinalList))
                    
                } else {
                    completion!(Response.onError(response))
                }
            }
        } else {
            
            //Responde para a tela utilizando a lista armazenada
            completion!(Response.onSuccess(trendingStoredList as Any))
        }
    }
    
    class func getImagesMovies(tmdbId:Int, completion: ((Response<Any>)->())? = nil) {
        
        //Primeiro verifica se há mesmo a necessidade da busca dos dados
        let imagesStoredList = SessionManager.sharedInstance.getImageMovies(forId: tmdbId)
        let lastSearch = SessionManager.sharedInstance.lastDateSearchImagesMovies()
        if (lastSearch == nil || imagesStoredList == nil || Date.hoursBetween(initialDate: lastSearch, finalDate: Date()) > Time.intervalToSearch.rawValue) {
            
            //Monta url a ser chamada
            let url: URLConvertible = URL(string: String(format: Url.endpointTheMovieDb.rawValue, tmdbId, TheMovieDb.theMovieDbKey.rawValue))!
            
            //Faz a chamada web
            APIManager.sharedInstance.customRequest(httpMethod: .get, url: url, parameters: nil, headers: ConfigManager.sharedInstance.getDefaultHeaders()) { (response) -> () in
                
                //Sem conexão, avisar para a tela
                if (!response.connected) {
                    completion!(Response.onNoConnection())
                    
                } else if (response.objectFromServer != nil) {
                    
                    //Conversões
                    let movieImages: MovieImage = Mapper<MovieImage>().map(JSONObject: response.objectFromServer)!
                    
                    //Armazena o objeto e horário em "cache"
                    SessionManager.sharedInstance.saveImageMovies(imageMovies: movieImages, forId: tmdbId)
                    SessionManager.sharedInstance.updateLastDateSearchImagesMovies()
                    
                    //Responde para a tela
                    let movieImage: MovieImageDetail = (movieImages.posters?.first)!
                    completion!(Response.onSuccess(movieImage))
                    
                } else {
                    completion!(Response.onError(response))
                }
            }
        } else {
            
            //Responde para a tela utilizando o objeto armazenado
            let movieImage: MovieImageDetail = (imagesStoredList!.posters?.first)!
            completion!(Response.onSuccess(movieImage))
        }
    }
    
    class func getDetailsMovies(traktId: Int, completion: ((Response<Any>)->())? = nil) {
        
        //Monta url a ser chamada
        let plusUrl = String(format: Movies.details.rawValue, traktId)
        let url: URLConvertible = URL(string: String(Url.endpointTrackt.rawValue + plusUrl))!
        
        //Faz a chamada web
        APIManager.sharedInstance.customRequest(httpMethod: .get, url: url, parameters: nil, headers: ConfigManager.sharedInstance.getDefaultHeaders()) { (response) -> () in
            
            //Sem conexão, avisar para a tela
            if (!response.connected) {
                completion!(Response.onNoConnection())
                
            } else if (response.objectFromServer != nil) {
                
                //Conversões
                let movieDetails: MovieDetail = Mapper<MovieDetail>().map(JSONObject: response.objectFromServer)!
                completion!(Response.onSuccess(movieDetails))
                
            } else {
                completion!(Response.onError(response))
            }
        }
    }
}
