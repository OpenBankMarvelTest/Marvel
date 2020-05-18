//
//  ConnectionsManager.swift
//  Marvel
//
//  Created by MarvelDev on 13/05/2020.
//  Copyright © 2020 MarvelDev. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireImage

protocol BaseUrlProtocol {
    var baseUrlDEV: String {get}
}

public class BaseServiceHandler: NSObject, BaseUrlProtocol {
    
    let baseUrlDEV = "https://gateway.marvel.com:443/v1/public/"
    
    func getBaseUrl(_ path: String) -> String {
        return baseUrlDEV + path
    }
}

public enum ResultResponse<T> {
    case success(T)
    case error(ErrorModel)
}

class ConnectionsManager: NSObject {
    
    static let shared: ConnectionsManager = {
        return ConnectionsManager()
    }()
    
    func request(_ url: URLConvertible, method: HTTPMethod, parameters: Parameters? = nil, encoding: ParameterEncoding = JSONEncoding.default, headers: HTTPHeaders? = nil, completion: @escaping(ResultResponse<Data?>) -> ()) {
        AF.request(url, method: method, parameters: parameters, encoding: encoding, headers: headers).response { (response) in
            switch response.result {
            case .success(let data):
                if response.response?.statusCode == 401 || response.response?.statusCode == 403 || response.response?.statusCode == 405 || response.response?.statusCode == 409 || response.response?.statusCode == 429 {
                    var code = ""
                    var message = ""
                    do {
                        if let json = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any] {
                            if let codeString = json["code"] as? String {
                                code = codeString
                            }
                            if let messageString = json["message"] as? String {
                                message = messageString
                            } else if let messageString = json["status"] as? String {
                                message = messageString
                            }
                        }
                    } catch let error as NSError {
                        message = error.localizedDescription
                    }
                    completion(ResultResponse.error(ErrorModel(code: code, message: message, httpCode: response.response?.statusCode ?? 0)))
                    return
                }
                completion(ResultResponse.success(data))
                break
            case .failure(let error):
                completion(ResultResponse.error(ErrorModel(code: error.responseContentType ?? "", message: error.errorDescription ?? "", httpCode: response.response?.statusCode ?? 0)))
                break
            }
        }
    }
    
    func requestImage(imageURL: String, completion: @escaping(ResultResponse<UIImage?>) -> ()) {
        AF.request(imageURL, method: .get).responseImage{ response in
           switch response.result {
            case .success(let responseData):
                completion(ResultResponse.success(responseData))
            case .failure(let error):
                completion(ResultResponse.error(ErrorModel(code: error.responseContentType ?? "", message: error.errorDescription ?? "", httpCode: response.response?.statusCode ?? 0)))
            break
            }
        }
    }
}
