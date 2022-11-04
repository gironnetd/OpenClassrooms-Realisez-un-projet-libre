//
//  Account.swift
//  model
//
//  Created by damien on 13/09/2022.
//

import Foundation

/**
 * Representation for a User fetched from an external layer data source
 */
public struct User: Equatable {
    
    public var uid: String
    public var providerID: String
    public var email: String?
    public var displayName: String?
    public var phoneNumber: String?
    public var photo: Data?
    public var favourites: Favourite?
    
    public init(uid: String,
                providerID: String,
                email: String? = nil,
                displayName: String? = nil,
                phoneNumber: String? = nil,
                photo: Data? = nil,
                favourites: Favourite? = nil) {
        self.uid = uid
        self.providerID = providerID
        self.email = email
        self.displayName = displayName
        self.phoneNumber = phoneNumber
        self.photo = photo
        self.favourites = favourites
    }
}
