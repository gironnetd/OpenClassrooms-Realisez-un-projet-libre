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
 * Model used solely for the caching of a user
 */
public class CachedUser: Object {
    
    @Persisted(primaryKey: true) public var uid: String
    @Persisted public var providerID: String
    @Persisted public var email: String?
    @Persisted public var displayName: String?
    @Persisted public var phoneNumber: String?
    @Persisted public var photo: Data?
    @Persisted public var favourites: CachedFavourite?
    
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
    
    public override func isEqual(_ object: Any?) -> Bool {
        guard let account = object as? CachedUser else {
            return false
        }
        
        return self.uid == account.uid &&
            self.providerID == account.providerID &&
            self.email == account.email &&
            self.displayName == account.displayName &&
            self.phoneNumber == account.phoneNumber &&
            self.favourites == account.favourites
    }
}

extension CachedUser {
    
    public func asExternalModel() -> model.User {
        User(uid: self.uid,
                providerID: self.providerID,
                email:  self.email,
                displayName: self.displayName,
                phoneNumber: self.phoneNumber,
                photo:  self.photo,
                favourites: self.favourites?.asExternalModel())
    }
}

extension model.User {
    
    public func asCached() -> CachedUser {
        CachedUser(uid: self.uid,
                      providerID: self.providerID,
                      email: self.email,
                      displayName: self.displayName,
                      phoneNumber: self.phoneNumber,
                      photo: self.photo,
                      favourites: self.favourites?.asCached())
    }
}
