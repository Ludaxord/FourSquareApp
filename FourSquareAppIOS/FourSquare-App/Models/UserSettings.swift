//
//  UserPreferences.swift
//  FourSquare-App
//
//  Created by Konrad Uciechowski on 02/10/2018.
//  Copyright © 2018 Konrad Uciechowski. All rights reserved.
//

import Foundation

class UserSettings {
  
        let defaults = UserDefaults.standard
        
        func setPreferences(key: String, value: String) {
            let userKey = key
            defaults.set(value, forKey: userKey)
            defaults.synchronize()
        }
        
        func getPreferences(key: String) -> String? {
            let userKey = key
            guard let value = defaults.object(forKey: userKey)
                else { return nil }
            return value as? String
        }
        
        func clearPreference(key: String) {
            let userKey = key
            defaults.removeObject(forKey: userKey)
            defaults.synchronize()
        }
        
        func clearAllPreferences() {
            let domain = Bundle.main.bundleIdentifier!
            defaults.removePersistentDomain(forName: domain)
            defaults.synchronize()
        }
}

