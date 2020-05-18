//
//  ErrorModel.swift
//  Marvel
//
//  Created by MarvelDev on 13/05/2020.
//  Copyright © 2020 MarvelDev. All rights reserved.
//

import Foundation

public struct ErrorModel: Decodable {
    let code: String
    let message: String
    let httpCode: Int
    

    public init(code: String, message: String, httpCode:Int) {
        self.code = code
        self.message = message
        self.httpCode = httpCode
    }
}
