//
//  UserPreferences.swift
//  Marvel
//
//  Created by MarvelDev on 15/05/2020.
//  Copyright © 2020 MarvelDev. All rights reserved.
//

import Foundation

public class UserPreferences {
    
    public static let shared: UserPreferences = UserPreferences()
    private let preferences = UserDefaults.standard
    
    public func save(object: Data, forKey: Key) {
        preferences.set(object, forKey: forKey.rawValue)
        preferences.synchronize()
    }
    
    public func load(forKey: Key) -> Data? {
        return preferences.data(forKey: forKey.rawValue)
    }
    
    public func delete(forKey: Key) {
        preferences.set(nil, forKey: forKey.rawValue)
        preferences.synchronize()
    }
}

extension UserPreferences {
    public enum Key: String {
        case charactersMarvel = "charactersMarvle"
    }
}
