//
//  File.swift
//  
//
//  Created by damien on 11/10/2022.
//

import Foundation
import Combine
import cache


class TestBookDao: BookDao {
    
    internal var books: [CachedBook] = []
    internal var themes: [CachedTheme] = []
    
    func findBook(byIdBook idBook: Int) -> Future<CachedBook, Error> {
        Future { promise in
            guard let book = self.books.filter({ book in book.idBook == idBook }).first else {
                return promise(.failure(NSError(domain: "", code: 0, userInfo: nil)))
            }
            promise(.success(book))
        }
    }
    
    func findBooks(byName name: String) -> Future<[CachedBook], Error> {
        Future { promise in
            guard let books = Optional(self.books.filter({ book in book.name == name })), !books.isEmpty else {
                return promise(.failure(NSError(domain: "", code: 0, userInfo: nil)))
            }
            
            guard books.count == 1, let book = books.first, !book.idRelatedBooks.isEmpty else {
                return promise(.success(books))
            }
            
            promise(
                .success(
                    book.idRelatedBooks
                        .reduce(into: [CachedBook](arrayLiteral: book)) { result, idBook in
                            if let book = self.books.filter({ book in book.idBook == idBook }).first {
                                result.append(book)
                            }
                        }
                )
            )
        }
    }
    
    func findBooks(byIdMovement idMovement: Int) -> Future<[CachedBook], Error> {
        Future { promise in
            guard let books = Optional(self.books.filter({ book in book.idMovement == idMovement })), !books.isEmpty else {
                return promise(.failure(NSError(domain: "", code: 0, userInfo: nil)))
            }
            promise(.success(books))
        }
    }
    
    func findBooks(byIdTheme idTheme: Int) -> Future<[CachedBook], Error> {
        Future { promise in
            guard let books = Optional(self.themes.filter({ theme in theme.idTheme == idTheme}))?.first?.books, !books.isEmpty else {
                return promise(.failure(NSError(domain: "", code: 0, userInfo: nil)))
            }
            promise(.success(books.toArray()))
        }
    }
    
    func findBook(byIdPresentation idPresentation: Int) -> Future<CachedBook, Error> {
        Future { promise in
            guard let presentations = Optional(self.books.compactMap({ author in author.presentation })),
                  let presentation = presentations.filter({ presentation in presentation.idPresentation == idPresentation }).first,
                  let book = self.books.filter({ book in book.presentation == presentation }).first
            else {
                return promise(.failure(NSError(domain: "", code: 0, userInfo: nil)))
            }
            promise(.success(book))
        }
    }
    
    func findBook(byIdPicture idPicture: Int) -> Future<CachedBook, Error> {
        Future { promise in
            guard let pictures = Optional(self.books.flatMap { book in book.pictures }),
                  let picture = pictures.filter({ picture in picture.idPicture == idPicture }).first,
                  let book = self.books.filter({ book in book.pictures.contains(picture)}).first else {
                return promise(.failure(NSError(domain: "", code: 0, userInfo: nil)))
            }
            promise(.success(book))
        }
    }
    
    func findAllBooks() -> Future<[CachedBook], Error> {
        Future { promise in
            guard !self.books.isEmpty else {
                return promise(.failure(NSError(domain: "", code: 0, userInfo: nil)))
            }
            promise(.success(self.books))
        }
    }
}
