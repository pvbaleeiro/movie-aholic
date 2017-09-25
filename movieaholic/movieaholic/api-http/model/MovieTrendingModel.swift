//
//  MovieTrendingModel.swift
//  movieaholic
//
//  Created by Victor Baleeiro on 23/09/17.
//  Copyright © 2017 Victor Baleeiro. All rights reserved.
//

import Foundation
import ObjectMapper

class MovieTrending: Mappable {
    
    var watchers: Int?
    var movie: MoviewTrendingDetail?
    
    //-------------------------------------------------------------------------------------------------------------
    // MARK: Construtor
    //-------------------------------------------------------------------------------------------------------------
    convenience required init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        watchers <- map["watchers"]
        movie <- map["movie"]
    }
}

class MoviewTrendingDetail: Mappable {
    
    var title: String?
    var year: Int?
    var ids: MoviewTrendingIds?
    
    //-------------------------------------------------------------------------------------------------------------
    // MARK: Construtor
    //-------------------------------------------------------------------------------------------------------------
    convenience required init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        title <- map["title"]
        year <- map["year"]
        ids <- map["ids"]
    }
}

class MoviewTrendingIds: Mappable {
    
    var trakt: Int?
    var slug: String?
    var imdb: String?
    var tmdb: Int?
    
    //-------------------------------------------------------------------------------------------------------------
    // MARK: Construtor
    //-------------------------------------------------------------------------------------------------------------
    convenience required init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        trakt <- map["trakt"]
        slug <- map["slug"]
        imdb <- map["imdb"]
        tmdb <- map["tmdb"]
    }
}
