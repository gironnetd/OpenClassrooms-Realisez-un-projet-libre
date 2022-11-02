//
//  File.swift
//  
//
//  Created by damien on 11/10/2022.
//

import Foundation
import Combine
import cache

class TestThemeDao: ThemeDao {
    
    internal var themes: [CachedTheme] = []
    
    func findTheme(byIdTheme idTheme: Int) -> Future<CachedTheme, Error> {
        Future { promise in
            guard let theme = self.themes.filter({ theme in theme.idTheme == idTheme }).first else {
                return promise(.failure(NSError(domain: "", code: 0, userInfo: nil)))
            }
            promise(.success(theme))
        }
    }
    
    func findThemes(byName name: String) -> Future<[CachedTheme], Error> {
        Future { promise in
            guard let themes = Optional(self.themes.filter({ theme in theme.name == name })), !themes.isEmpty else {
                return promise(.failure(NSError(domain: "", code: 0, userInfo: nil)))
            }
            
            guard themes.count == 1, let theme = themes.first,
                  !theme.idRelatedThemes.isEmpty else {
                return promise(.success(themes))
            }
            
            promise(
                .success(
                    theme.idRelatedThemes
                        .reduce(into: [CachedTheme](arrayLiteral: theme)) { result, idTheme in
                            if let theme = self.themes.filter({ theme in theme.idTheme == idTheme }).first {
                                result.append(theme)
                            }
                        }
                )
            )
        }
    }
    
    func findThemes(byIdParent idParent: Int) -> Future<[CachedTheme], Error> {
        Future { promise in
            guard let themes = self.themes.filter({ theme in theme.idTheme == idParent }).first?.themes,
                  !themes.isEmpty else {
                return promise(.failure(NSError(domain: "", code: 0, userInfo: nil)))
            }
            promise(.success(themes.toArray()))
        }
    }
    
    func findMainThemes() -> Future<[CachedTheme], Error> {
        Future { promise in
            guard let themes = Optional(self.themes.filter({ theme in theme.idParentTheme == nil })),
                  !themes.isEmpty else {
                return promise(.failure(NSError(domain: "", code: 0, userInfo: nil)))
            }
            promise(.success(themes))
        }
    }
    
    func findAllThemes() -> Future<[CachedTheme], Error> {
        Future { promise in
            guard !self.themes.isEmpty else {
                return promise(.failure(NSError(domain: "", code: 0, userInfo: nil)))
            }
            promise(.success(self.themes))
        }
    }
}
