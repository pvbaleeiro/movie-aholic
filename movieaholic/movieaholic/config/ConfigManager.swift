//
//  ConfigManager.swift
//  movieaholic
//
//  Created by Victor Baleeiro on 22/09/17.
//  Copyright © 2017 Victor Baleeiro. All rights reserved.
//

import Foundation
import Alamofire

//-------------------------------------------------------------------------------------------------------------
// MARK: Configuracoes API Trakt
//-------------------------------------------------------------------------------------------------------------
enum Trakt: String {
    case clientId = "5158dabcfe70ca050383b4e42c76b4b1688c1bec03149250dc9ed8b90f45b7e7"
    case secret = "6f3ecdbbbd00d6a6adfcd093dee7bf8c338116a2560ad1317642036d797477c0"
    case redirectURI = "urn:ietf:wg:oauth:2.0:oob"
}

enum TheMovieDb: String {
    case theMovieDbKey = "270f2c64327de86c3c355e6b667b9889"
}

public enum Url: String {
    case endpointTrackt = "https://api.trakt.tv/"
    case endpointTheMovieDb = "https://api.themoviedb.org/3/movie/%d/images?api_key=%@"
    case endpointTheMovieDbImage  = "https://image.tmdb.org/t/p/w1000"

    //case OauthUrl = "oauth/authorize?response_type=code"
}

public enum Movies: String {
    case trending = "movies/trending"
    case details = "movies/%d?extended=full"
}


class ConfigManager {
    static let sharedInstance = ConfigManager()

    //-------------------------------------------------------------------------------------------------------------
    // MARK: Métodos
    //-------------------------------------------------------------------------------------------------------------
    func getDefaultHeaders() -> HTTPHeaders {
        var headers:HTTPHeaders = HTTPHeaders()
        headers["Content-Type"] = "application/json"
        headers["trakt-api-version"] = "2"
        headers["trakt-api-key"] = Trakt.clientId.rawValue
        return headers
    }
}

