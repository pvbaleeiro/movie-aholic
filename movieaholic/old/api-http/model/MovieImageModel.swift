//
//  MovieImageModel.swift
//  movieaholic
//
//  Created by Victor Baleeiro on 23/09/17.
//  Copyright © 2017 Victor Baleeiro. All rights reserved.
//

import Foundation
import ObjectMapper

class MovieImage: Mappable {

    var id: Int?
    var backdrops: Array<MovieImageDetail>?
    var posters: Array<MovieImageDetail>?
    
    
    //-------------------------------------------------------------------------------------------------------------
    // MARK: Construtor
    //-------------------------------------------------------------------------------------------------------------
    convenience required init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        backdrops <- map["backdrops"]
        posters <- map["posters"]
    }
}

class MovieImageDetail: Mappable {
    
    var aspectRadio: Double?
    var filePath: String?
    var height: Int?
    var iso_639_1: String?
    var vote_average: Double?
    var voteCount: Int?
    var width: Int?

    //-------------------------------------------------------------------------------------------------------------
    // MARK: Construtor
    //-------------------------------------------------------------------------------------------------------------
    convenience required init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        aspectRadio <- map["aspect_ratio"]
        filePath <- map["file_path"]
        height <- map["height"]
        iso_639_1 <- map["iso_639_1"]
        vote_average <- map["vote_average"]
        voteCount <- map["vote_count"]
        width <- map["width"]
    }
}
