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
    
    @Persisted(primaryKey: true) var uid: String
    @Persisted var providerID: String
    @Persisted var email: String?
    @Persisted var displayName: String?
    @Persisted var phoneNumber: String?
    @Persisted var photo: Data?
    @Persisted var favourites: CachedFavourite?
    
    public override init() {}
    
    public init(uid: String,
                providerID: String,
                email: String? = nil,
                displayName: String? = nil,
                phoneNumber: String? = nil,
                photo: Data? = nil,
                favourites: CachedFavourite? = nil) {
        super.init()
        self.uid = uid
        self.providerID = providerID
        self.email = email
        self.displayName = displayName
        self.phoneNumber = phoneNumber
        self.photo = photo
        self.favourites = favourites
    }
}

extension CachedAccount {
    
    public func asExternalModel() -> Account {
        Account(uid: self.uid,
                providerID: self.providerID,
                email:  self.email,
                displayName: self.displayName,
                phoneNumber: self.phoneNumber,
                photo:  self.photo,
                favourites: self.favourites?.asExternalModel())
    }
}

extension Account {
    
    public func asCached() -> CachedAccount {
        CachedAccount(uid: self.uid,
                      providerID: self.providerID,
                      email: self.email,
                      displayName: self.displayName,
                      phoneNumber: self.phoneNumber,
                      photo: self.photo,
                      favourites: nil)
    }
}
