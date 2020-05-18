//
//  MarvelServiceHandler.swift
//  Marvel
//
//  Created by MarvelDev on 13/05/2020.
//  Copyright © 2020 MarvelDev. All rights reserved.
//

import Foundation
import UIKit
import CommonCrypto

protocol CharactersServiceHandlerProtocol {
    func getCharacters(offset: String?, limit: String?, completion: @escaping (ResultResponse<CharactersModel?>) -> ())
    func getDetailCharacter(characterId: String, completion: @escaping (ResultResponse<CharactersModel?>) -> ())
    func getImageCharacter(url: String, completion: @escaping (ResultResponse<UIImage?>) -> ())
}

final class CharactersServiceHandler: BaseServiceHandler {
    private let baseServiceUrl = "characters"
    private let apikey = "8b32f2fc7c43f1f44399784d59fb3e4b"
    private let privateApikey = "20000c5ccd6c0ea2823e04977bfd9304f91dab9d"
}

//MARK: - CharactersServiceHandlerProtocol
extension CharactersServiceHandler: CharactersServiceHandlerProtocol {
    
    func getCharacters(offset: String? = nil, limit: String? = nil, completion: @escaping (ResultResponse<CharactersModel?>) -> ()) {
        ConnectionsManager.shared.request(getUrl(offset: offset, limit: limit), method: .get) { (result) in
            switch result {
            case .success(let data):
                guard let data = data else {
                    completion(ResultResponse.success(nil))
                    return
                }
                completion(ResultResponse.success(CharactersModel.getModelFrom(data)))
                break
                
            case .error(let error):
                completion(ResultResponse.error(error))
                break
            }
        }
    }
    
    func getDetailCharacter(characterId: String, completion: @escaping (ResultResponse<CharactersModel?>) -> ()) {
        ConnectionsManager.shared.request(getUrl(characterId: characterId), method: .get) { (result) in
            switch result {
            case .success(let data):
                guard let data = data else {
                    completion(ResultResponse.success(nil))
                    return
                }
                completion(ResultResponse.success(CharactersModel.getModelFrom(data)))
                break
                
            case .error(let error):
                completion(ResultResponse.error(error))
                break
            }
        }
    }
    
    func getImageCharacter(url: String, completion: @escaping (ResultResponse<UIImage?>) -> ()) {
        ConnectionsManager.shared.requestImage(imageURL: url) { (result) in
        switch result {
        case .success(let data):
            guard let data = data else {
                completion(ResultResponse.success(nil))
                return
            }
            completion(ResultResponse.success(data))
            break
            
        case .error(let error):
            completion(ResultResponse.error(error))
            break
        }

        }
    }
}

//MARK: - private methods -
extension CharactersServiceHandler {
    private func getUrl(offset: String? = nil, limit: String? = nil, characterId: String? = nil) -> String {
        return getBaseUrl(baseServiceUrl + getPathURL(characterId) + getParameters(offset: offset, limit: limit))
    }
    
    private func getPathURL(_ characterId: String?) -> String {
        if let characterId = characterId {
            return "/" + characterId
        }
        return ""
    }
    
    private func getParameters(offset: String? = nil, limit: String? = nil) -> String {
        let ts = getTS()
        return "?apikey=" + apikey + "&ts=" + ts + "&hash=" + getHash(ts) + (offset != nil ? ("&offset=" + offset!) : "") + (limit != nil ? ("&limit=" + limit!) : "")
    }
    
    private func getTS() -> String {
        return String(Date().timeIntervalSince1970 * 1000000)
    }
    
    private func getHash(_ ts: String) -> String {
        return md5(ts + privateApikey + apikey)
    }
    
    private func md5(_ string: String) -> String {
        let length = Int(CommonCrypto.CC_MD5_DIGEST_LENGTH)
        let messageData = string.data(using:.utf8)!
        var digestData = Data(count: length)

        _ = digestData.withUnsafeMutableBytes { digestBytes -> UInt8 in
            messageData.withUnsafeBytes { messageBytes -> UInt8 in
                if let messageBytesBaseAddress = messageBytes.baseAddress, let digestBytesBlindMemory = digestBytes.bindMemory(to: UInt8.self).baseAddress {
                    let messageLength = CC_LONG(messageData.count)
                    CC_MD5(messageBytesBaseAddress, messageLength, digestBytesBlindMemory)
                }
                return 0
            }
        }
        return digestData.map {
                String(format: "%02hhx", $0)
            }.joined()
    }
}

