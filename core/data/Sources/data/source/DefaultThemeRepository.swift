//
//  File.swift
//  
//
//  Created by damien on 06/10/2022.
//

import Foundation
import Combine
import model
import cache

public class DefaultThemeRepository: ThemeRepository {
    
    private let themeDao: ThemeDao
    
    public init(themeDao: ThemeDao) {
        self.themeDao = themeDao
    }
    
    /// Retrieve a theme from its identifier
    ///
    /// - Parameters:
    ///   - idTheme: The identifier of the theme
    ///
    /// - Returns: An AnyPublisher returning a Theme or an Error
    public func findTheme(byIdTheme idTheme: Int) -> AnyPublisher<Theme, Error> {
        self.themeDao.findTheme(byIdTheme: idTheme).map { theme in theme.asExternalModel() }.eraseToAnyPublisher()
    }
    
    /// Retrieve a theme from its name
    ///
    /// - Parameters:
    ///   - name: The identifier of the name
    ///
    /// - Returns: An AnyPublisher returning an Array of Theme or an Error
    public func findThemes(byName name: String) -> AnyPublisher<[Theme], Error> {
        self.themeDao.findThemes(byName: name).map { themes in
            themes.map { theme in theme.asExternalModel() }
        }.eraseToAnyPublisher()
    }
    
    /// Retrieve a list of themes containing with same parent identifier
    ///
    /// - Parameters:
    ///   - idParent: The identifier of the parent theme
    ///
    /// - Returns: An AnyPublisher returning an Array of Theme or an Error
    public func findThemes(byIdParent idParent: Int) -> AnyPublisher<[Theme], Error> {
        self.themeDao.findThemes(byIdParent: idParent).map { themes in
            themes.map { theme in theme.asExternalModel() }
        }.eraseToAnyPublisher()
    }
    
    /// Retrieve a list of main themes containing with sub themes
    ///
    /// - Returns: An AnyPublisher returning an Array of Theme or an Error
    public func findMainThemes() -> AnyPublisher<[Theme], Error> {
        self.themeDao.findMainThemes().map { themes in
            themes.map { theme in theme.asExternalModel() }
        }.eraseToAnyPublisher()
    }
    
    /// Retrieve all themes
    ///
    /// - Returns: An AnyPublisher returning an Array of Theme or an Error
    public func findAllThemes() -> AnyPublisher<[Theme], Error> {
        self.themeDao.findAllThemes().map { themes in
            themes.map { theme in theme.asExternalModel() }
        }.eraseToAnyPublisher()
    }
}
