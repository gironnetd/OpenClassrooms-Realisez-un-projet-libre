//
//  File.swift
//  
//
//  Created by damien on 30/09/2022.
//

import Foundation
import testing

@testable import remote

extension RemoteUser {
    
    static func testUser() -> RemoteUser {
        RemoteUser(uid: DataFactory.randomString(),
                   providerID: DataFactory.randomString(),
                   email: DataFactory.randomEmail(),
                   displayName: DataFactory.randomString(),
                   phoneNumber: DataFactory.randomString(),
                   photo: DataFactory.randomData(),
                   favourites: RemoteFavourite.testFavourite()
        )
    }
}

extension RemoteFavourite {
    
    static func testFavourite() -> RemoteFavourite {
        RemoteFavourite(idDirectory: DataFactory.randomString(),
                        uidUser: DataFactory.randomString(),
                        idParentDirectory: DataFactory.randomString(),
                        directoryName: DataFactory.randomString(),
                        idAuthors: [DataFactory.randomInt(), DataFactory.randomInt()],
                        idBooks: [DataFactory.randomInt(), DataFactory.randomInt()],
                        idMovements: [DataFactory.randomInt(), DataFactory.randomInt()],
                        idThemes: [DataFactory.randomInt(), DataFactory.randomInt()],
                        idQuotes: [DataFactory.randomInt(), DataFactory.randomInt()],
                        idPictures: [DataFactory.randomInt(), DataFactory.randomInt()],
                        idPresentations: [DataFactory.randomInt(), DataFactory.randomInt()],
                        idUrls: [DataFactory.randomInt(), DataFactory.randomInt()]
        )
    }
}

