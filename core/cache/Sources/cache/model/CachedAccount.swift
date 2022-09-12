//
//  CachedAccount.swift
//  cache
//
//  Created by damien on 27/08/2022.
//  Copyright © 2022 damien. All rights reserved.
//

import Foundation
import RealmSwift
import model

/**
 * Model used solely for the caching of a account
 */
public class CachedAccount: Object {
    
    @Persisted(primaryKey: true) var uuid: UUID
    @Persisted var providerId: String
    @Persisted var email: String?
    @Persisted var displayName: String?
    @Persisted var phoneNumber: String?
    @Persisted var photo: Data?
    @Persisted var favourites: CachedFavourite?
    
    public init(uuid: UUID,
                providerId: String,
                email: String? = nil,
                displayName: String? = nil,
                phoneNumber: String? = nil,
                photo: Data? = nil,
                favourites: CachedFavourite? = nil) {
        super.init()
        self.uuid = uuid
        self.providerId = providerId
        self.email = email
        self.displayName = displayName
        self.phoneNumber = phoneNumber
        self.photo = photo
        self.favourites = favourites
    }
}

extension CachedAccount {
    
    func asExternalModel() -> Account {
        Account(uuid: uuid,
                providerId: providerId,
                email:  email,
                displayName: displayName,
                phoneNumber: phoneNumber,
                photo:  photo,
                favourites: favourites?.asExternalModel())
    }
}
