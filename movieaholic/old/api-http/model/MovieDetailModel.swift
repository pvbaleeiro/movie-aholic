//
//  MovieDetailModel.swift
//  movieaholic
//
//  Created by Victor Baleeiro on 24/09/17.
//  Copyright © 2017 Victor Baleeiro. All rights reserved.
//

//import Foundation
//
//class MovieDetail: Mappable {
//    
//    var title: String?
//    var year: Int?
//    var ids: MoviewTrendingIds?
//    var tagline: String?
//    var overview: String?
//    var released: String?
//    var runtime: Int?
//    var trailer: String?
//    var homePage: String?
//    var rating: Double?
//    var votes: Int?
//    var updatedAt: String?
//    var language: String?
//    var availableTranslations: Array<String>?
//    var genres: Array<String>?
//    var certification: String?
//    //Não recebido do server
//    var movieImages: MovieImage?
//    var favorite: Bool?
//    
//    //-------------------------------------------------------------------------------------------------------------
//    // MARK: Construtor
//    //-------------------------------------------------------------------------------------------------------------
//    convenience required init?(map: Map) {
//        self.init()
//    }
//    
//    func mapping(map: Map) {
//        title <- map["title"]
//        year <- map["year"]
//        ids <- map["ids"]
//        tagline <- map["tagline"]
//        overview <- map["overview"]
//        released <- map["released"]
//        runtime <- map["runtime"]
//        trailer <- map["trailer"]
//        homePage <- map["homepage"]
//        rating <- map["rating"]
//        votes <- map["votes"]
//        updatedAt <- map["updated_at"]
//        language <- map["language"]
//        availableTranslations <- map["available_translations"]
//        genres <- map["genres"]
//        certification <- map["certification"]
//        favorite <- map["favorite"]
//    }
//}
