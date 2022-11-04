//
//  File.swift
//  
//
//  Created by damien on 06/10/2022.
//

import Foundation
import Combine
import model

public protocol ThemeRepository {
    
    /// Retrieve a theme from its identifier
    ///
    /// - Parameters:
    ///   - idTheme: The identifier of the theme
    ///
    /// - Returns: An AnyPublisher returning a Theme or an Error
    func findTheme(byIdTheme idTheme: Int) -> AnyPublisher<Theme, Error>
    
    /// Retrieve a theme from its name
    ///
    /// - Parameters:
    ///   - name: The identifier of the name
    ///
    /// - Returns: An AnyPublisher returning an Array of Theme or an Error
    func findThemes(byName name: String) -> AnyPublisher<[Theme], Error>
    
    /// Retrieve a list of themes containing with same parent identifier
    ///
    /// - Parameters:
    ///   - idParent: The identifier of the parent theme
    ///
    /// - Returns: An AnyPublisher returning an Array of Theme or an Error
    func findThemes(byIdParent idParent: Int) -> AnyPublisher<[Theme], Error>
    
    /// Retrieve a list of main themes containing with sub themes
    ///
    /// - Returns: An AnyPublisher returning an Array of Theme or an Error
    func findMainThemes() -> AnyPublisher<[Theme], Error>
    
    /// Retrieve all themes
    ///
    /// - Returns: An AnyPublisher returning an Array of Theme or an Error
    func findAllThemes() -> AnyPublisher<[Theme], Error>
}
