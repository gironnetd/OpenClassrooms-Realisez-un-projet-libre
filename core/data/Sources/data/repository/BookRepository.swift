//
//  File.swift
//  
//
//  Created by damien on 06/10/2022.
//

import Foundation
import Combine
import model

public protocol BookRepository {
    
    /// Retrieve an book from its identifier
    ///
    /// - Parameters:
    ///   - idBook: The identifier of the book
    ///
    /// - Returns: An AnyPublisher returning a Book or an Error
    func findBook(byIdBook idBook: Int) -> AnyPublisher<Book, Error>
    
    /// Retrieve  books from a name
    ///
    /// - Parameters:
    ///   - name: The name of the book
    ///
    /// - Returns: An AnyPublisher returning an Array of Book or an Error
    func findBooks(byName name: String) -> AnyPublisher<[Book], Error>
    
    /// Retrieve a list of books from its identifier movement
    ///
    /// - Parameters:
    ///   - idMovement: The identifier of the movement of the book
    ///
    /// - Returns: An AnyPublisher returning an Array of Book or an Error
    func findBooks(byIdMovement idMovement: Int) -> AnyPublisher<[Book], Error>
    
    /// Retrieve a list of books containing in a theme
    ///
    /// - Parameters:
    ///   - idTheme: The identifier of the theme containing the book
    ///
    /// - Returns: An AnyPublisher returning an Array of Book or an Error
    func findBooks(byIdTheme idTheme: Int) -> AnyPublisher<[Book], Error>
    
    /// Retrieve a book from its identifier presentation
    ///
    /// - Parameters:
    ///   - idPresentation: The identifier of the presentation
    ///
    /// - Returns: An AnyPublisher returning a Book or an Error
    func findBook(byIdPresentation idPresentation: Int) -> AnyPublisher<Book, Error>
    
    /// Retrieve a book from a identifier picture
    ///
    /// - Parameters:
    ///   - idPicture: The identifier of the picture
    ///
    /// - Returns: An AnyPublisher returning a Book or an Error
    func findBook(byIdPicture idPicture: Int) -> AnyPublisher<Book, Error>
    
    /// Retrieve all books
    ///
    /// - Returns: An AnyPublisher returning a Book or an Error
    func findAllBooks() -> AnyPublisher<[Book], Error>
}
