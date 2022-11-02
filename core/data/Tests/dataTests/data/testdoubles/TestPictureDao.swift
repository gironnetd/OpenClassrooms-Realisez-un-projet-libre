//
//  File.swift
//  
//
//  Created by damien on 11/10/2022.
//

import Foundation
import Combine
import cache

class TestPictureDao: PictureDao {
    
    internal var pictures: [CachedPicture] = []
    internal var author: CachedAuthor = CachedAuthor()
    internal var book: CachedBook = CachedBook()
    internal var movement: CachedMovement = CachedMovement()
    internal var theme: CachedTheme = CachedTheme()
    
    func findPicture(byIdPicture idPicture: Int) -> Future<CachedPicture, Error> {
        Future { promise in
            guard let picture = self.pictures.filter({ picture in picture.idPicture == idPicture }).first else {
                return promise(.failure(NSError(domain: "", code: 0, userInfo: nil)))
            }
            promise(.success(picture))
        }
    }
    
    func findPictures(byIdAuthor idAuthor: Int) -> Future<[CachedPicture], Error> {
        Future { promise in
            guard !self.author.pictures.isEmpty else {
                return promise(.failure(NSError(domain: "", code: 0, userInfo: nil)))
            }
            promise(.success(self.author.pictures.toArray()))
        }
    }
    
    func findPictures(byIdBook idBook: Int) -> Future<[CachedPicture], Error> {
        Future { promise in
            guard !self.book.pictures.isEmpty else {
                return promise(.failure(NSError(domain: "", code: 0, userInfo: nil)))
            }
            promise(.success(self.book.pictures.toArray()))
        }
    }
    
    func findPictures(byIdMovement idMovement: Int) -> Future<[CachedPicture], Error> {
        Future { promise in
            guard !self.movement.pictures.isEmpty else {
                return promise(.failure(NSError(domain: "", code: 0, userInfo: nil)))
            }
            promise(.success(self.movement.pictures.toArray()))
        }
    }
    
    func findPictures(byIdTheme idTheme: Int) -> Future<[CachedPicture], Error> {
        Future { promise in
            guard !self.theme.pictures.isEmpty else {
                return promise(.failure(NSError(domain: "", code: 0, userInfo: nil)))
            }
            promise(.success(self.theme.pictures.toArray()))
        }
    }
    
    func findPictures(byNameSmall nameSmall: String) -> Future<[CachedPicture], Error> {
        Future { promise in
            guard let pictures = Optional(self.pictures.filter({ picture in picture.nameSmall == nameSmall })),
                  !pictures.isEmpty else {
                return promise(.failure(NSError(domain: "", code: 0, userInfo: nil)))
            }
            promise(.success(pictures))
        }
    }
    
    func findAllPictures() -> Future<[CachedPicture], Error> {
        Future { promise in
            guard !self.pictures.isEmpty else {
                return promise(.failure(NSError(domain: "", code: 0, userInfo: nil)))
            }
            promise(.success(self.pictures))
        }
    }
}
