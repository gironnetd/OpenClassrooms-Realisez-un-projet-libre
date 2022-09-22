//
//  CachedLanguage.swift
//  OnelittleAngelRealmConverter
//
//  Created by damien on 03/09/2022.
//

import Foundation
import RealmSwift

/**
 * Enum used solely for representing the caching different languages of the application
 */
public enum CachedLanguage: String, PersistableEnum {
    case none = "none"
    case english = "english"
    case french = "french"
}
