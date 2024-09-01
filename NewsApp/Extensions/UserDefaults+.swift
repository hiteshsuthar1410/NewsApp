//
//  UserDefaults+.swift
//  NewsApp
//
//  Created by NovoTrax Dev1 on 01/09/24.
//

import Foundation
extension UserDefaults {
    private enum Keys {
        static let layoutOption = "layoutOption"
    }
    
    var layoutOption: LayoutOption {
        get {
            if let rawValue = string(forKey: Keys.layoutOption),
               let option = LayoutOption(rawValue: rawValue) {
                return option
            }
            return .list // default value
        }
        set {
            set(newValue.rawValue, forKey: Keys.layoutOption)
        }
    }
}
