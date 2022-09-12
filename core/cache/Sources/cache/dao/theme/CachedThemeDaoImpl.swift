//
//  CachedThemeDaoImpl.swift
//  cache
//
//  Created by damien on 27/08/2022.
//  Copyright © 2022 damien. All rights reserved.
//

import Foundation
import RealmSwift
import Combine

/**
 * Implementation for the CachedTheme Dao Protocol
 */
public class CachedThemeDaoImpl : CachedThemeDao {
    
    /// Retrieve a theme from its identifier, from the cache
    ///
    /// - Parameters:
    ///   - idTheme: The identifier of the theme
    ///
    /// - Returns: An AnyPublisher returning a CachedTheme or an Error
    func findTheme(byIdTheme idTheme: Int) -> AnyPublisher<CachedTheme, Error> {
        if let theme = try? Realm().objects(CachedTheme.self)
            .where({ theme in theme.idTheme == idTheme }).first {
            return Just(theme).setFailureType(to:Error.self).eraseToAnyPublisher()
        }
        return Fail(error: Realm.Error.init(Realm.Error.fail)).eraseToAnyPublisher()
    }
    
    /// Retrieve a theme from its name, from the cache
    ///
    /// - Parameters:
    ///   - name: The identifier of the name
    ///
    /// - Returns: An AnyPublisher returning an Array of CachedTheme or an Error
    func findThemes(byName name: String) -> AnyPublisher<[CachedTheme], Error> {
        guard let themes = try? Realm().objects(CachedTheme.self)
            .where({ theme in theme.name == name }) else {
            return Fail(error: Realm.Error.init(Realm.Error.fail)).eraseToAnyPublisher()
        }
        
        if themes.count == 1, let theme = themes.first {
            return Just(
                theme.idRelatedThemes
                    .reduce(into: [CachedTheme](arrayLiteral: theme)) { result, idTheme in
                          if let theme = try? Realm().objects(CachedTheme.self)
                              .where({ theme in theme.idTheme == idTheme }).first {
                              result.append(theme)
                          }
                }
            ).setFailureType(to:Error.self).eraseToAnyPublisher()
        }
        return Just(themes.toArray()).setFailureType(to:Error.self).eraseToAnyPublisher()
    }
    
    /// Retrieve a list of themes containing with same parent identifier, from the cache
    ///
    /// - Parameters:
    ///   - idParent: The identifier of the parent theme
    ///
    /// - Returns: An AnyPublisher returning an Array of CachedTheme or an Error
    func findThemes(byIdParent idParent: Int) -> AnyPublisher<[CachedTheme], Error> {
        if let themes = try? Realm().objects(CachedTheme.self)
            .where({ theme in theme.idTheme == idParent }).first?.themes {
            return Just(themes.toArray()).setFailureType(to:Error.self).eraseToAnyPublisher()
        }
        return Fail(error: Realm.Error.init(Realm.Error.fail)).eraseToAnyPublisher()
    }
    
    /// Retrieve a list of main themes containing with sub themes, from the cache
    ///
    /// - Returns: An AnyPublisher returning an Array of CachedTheme or an Error
    func findMainThemes() -> AnyPublisher<[CachedTheme], Error> {
        if let themes = try? Realm().objects(CachedTheme.self)
            .where({ theme in theme.idParentTheme == nil }).first?.themes {
            return Just(themes.toArray()).setFailureType(to:Error.self).eraseToAnyPublisher()
        }
        return Fail(error: Realm.Error.init(Realm.Error.fail)).eraseToAnyPublisher()
    }
    
    /// Retrieve all themes, from the cache
    ///
    /// - Returns: An AnyPublisher returning an Array of CachedTheme or an Error
    func findAllThemes() -> AnyPublisher<[CachedTheme], Error> {
        if let themes = try? Realm().objects(CachedTheme.self) {
            return Just(themes.toArray()).setFailureType(to:Error.self).eraseToAnyPublisher()
        }
        return Fail(error: Realm.Error.init(Realm.Error.fail)).eraseToAnyPublisher()
    }
}
