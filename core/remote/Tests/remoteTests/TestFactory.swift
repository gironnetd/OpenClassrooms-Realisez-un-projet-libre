//
//  File.swift
//  
//
//  Created by damien on 30/09/2022.
//

import Foundation
import testing

@testable import remote

extension RemoteAccount {
    
    static func testAccount() -> RemoteAccount {
        RemoteAccount(uid: DataFactory.randomString(),
                      providerID: DataFactory.randomString(),
                      email: DataFactory.randomEmail(),
                      displayName: DataFactory.randomString(),
                      phoneNumber: DataFactory.randomString(),
                      photo: nil,
                      favourites: nil)
    }
}

extension RemoteFavourite {
    
    static func testFavourite() -> RemoteFavourite {
        RemoteFavourite(idDirectory: DataFactory.randomString(),
                        uuidAccount: DataFactory.randomString(),
                        idParentDirectory: DataFactory.randomString(),
                        directoryName: DataFactory.randomString(),
                        authors: nil,
                        books: nil,
                        movements: nil,
                        themes: nil,
                        quotes: nil,
                        pictures: nil,
                        presentations: nil,
                        urls: nil)
    }
}

