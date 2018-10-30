//
//  APIManager.swift
//  movieaholic
//
//  Created by Victor Baleeiro on 22/09/17.
//  Copyright © 2017 Victor Baleeiro. All rights reserved.
//

//import UIKit
//import Foundation
//
////-------------------------------------------------------------------------------------------------------------
//// MARK: Constantes / Enums
////-------------------------------------------------------------------------------------------------------------
//public enum Response<T> {
//    case onSuccess(T)
//    case onError(T)
//    case onNoConnection()
//}
//
//class APIManager {
//    static let sharedInstance = APIManager()
//    
//    
//    //-------------------------------------------------------------------------------------------------------------
//    // MARK: Main
//    //-------------------------------------------------------------------------------------------------------------
//    func customRequest(httpMethod: HTTPMethod, url: URLConvertible, parameters: [String: Any]?, headers: HTTPHeaders, completion: @escaping (_ apiResponse: APIResponse)->()) {
//        
//        //Loga a url chamada
//        LogUtil.log(title: "Url chamada", forClass: String(describing: APIManager.self), method: #function, line: #line, description: String(describing: url))
//        
//        //Obtem status da conexão
//        let httpResponse = APIResponse()
//        httpResponse.connected = ConnectionUtil.isConnected()
//        
//        //Verifica se está conectado
//        if (httpResponse.connected) {
//        
//            //Tenta realizar o request
//            Alamofire.request(url, method: httpMethod, parameters: parameters, encoding: JSONEncoding.default, headers: headers).validate().responseJSON {
//                (response) in
//                
//                switch response.result {
//                case .success:
//                    httpResponse.objectFromServer = response.result.value
//                    httpResponse.httpCode = (response.response?.statusCode)!
//                    break
//                    
//                case .failure(let error):
//                    httpResponse.objectFromServer = error
//                    httpResponse.httpCode = (response.response?.statusCode)!
//                    break
//                }
//                
//                completion(httpResponse)
//            }
//        } else {
//            completion(httpResponse)
//        }
//    }
//}
