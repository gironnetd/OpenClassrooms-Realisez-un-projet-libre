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
    /// - Returns: A Future returning a CachedTheme or an Error
    func findTheme(byIdTheme idTheme: Int) -> Future<CachedTheme, Error> {
        Future { promise in
            guard let theme = try? Realm().objects(CachedTheme.self)
                    .where({ theme in theme.idTheme == idTheme }).first else {
                return promise(.failure(Realm.Error(Realm.Error.fail)))
            }
            promise(.success(theme))
        }
    }
    
    /// Retrieve a theme from its name, from the cache
    ///
    /// - Parameters:
    ///   - name: The identifier of the name
    ///
    /// - Returns: A Future returning an Array of CachedTheme or an Error
    func findThemes(byName name: String) -> Future<[CachedTheme], Error> {
        Future { promise in
            guard let themes = try? Realm().objects(CachedTheme.self)
                    .where({ theme in theme.name == name }), !themes.isEmpty else {
                return promise(.failure(Realm.Error(Realm.Error.fail)))
            }
            
            guard themes.count == 1, let theme = themes.first,
                  !theme.idRelatedThemes.isEmpty else {
                return promise(.success(themes.toArray()))
            }
            
            promise(
                .success(
                    theme.idRelatedThemes
                        .reduce(into: [CachedTheme](arrayLiteral: theme)) { result, idTheme in
                            if let theme = try? Realm().objects(CachedTheme.self)
                                .where({ theme in theme.idTheme == idTheme }).first {
                                result.append(theme)
                            }
                        }
                )
            )
        }
    }
    
    /// Retrieve a list of themes containing with same parent identifier, from the cache
    ///
    /// - Parameters:
    ///   - idParent: The identifier of the parent theme
    ///
    /// - Returns: A Future returning an Array of CachedTheme or an Error
    func findThemes(byIdParent idParent: Int) -> Future<[CachedTheme], Error> {
        Future { promise in
            guard let themes = try? Realm().objects(CachedTheme.self)
                    .where({ theme in theme.idTheme == idParent }).first?.themes, !themes.isEmpty else {
                return promise(.failure(Realm.Error(Realm.Error.fail)))
            }
            promise(.success(themes.toArray()))
        }
    }
    
    /// Retrieve a list of main themes containing with sub themes, from the cache
    ///
    /// - Returns: A Future returning an Array of CachedTheme or an Error
    func findMainThemes() -> Future<[CachedTheme], Error> {
        Future { promise in
            guard let themes = try? Realm().objects(CachedTheme.self)
                    .where({ theme in theme.idParentTheme == nil }), !themes.isEmpty else {
                return promise(.failure(Realm.Error(Realm.Error.fail)))
            }
            promise(.success(themes.toArray()))
        }
    }
    
    /// Retrieve all themes, from the cache
    ///
    /// - Returns: A Future returning an Array of CachedTheme or an Error
    func findAllThemes() -> Future<[CachedTheme], Error> {
        Future { promise in
            guard let themes = try? Realm().objects(CachedTheme.self), !themes.isEmpty else {
                return promise(.failure(Realm.Error(Realm.Error.fail)))
            }
            promise(.success(themes.toArray()))
        }
    }
}
