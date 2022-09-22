//
//  Account.swift
//  model
//
//  Created by damien on 13/09/2022.
//

import Foundation

/**
 * Representation for a Account fetched from an external layer data source
 */
public struct Account : Equatable {
    
    public var uuid: UUID
    public var providerId: String
    public var email: String?
    public var displayName: String?
    public var phoneNumber: String?
    public var photo: Data?
    public var favourites: Favourite?
    
    public init(uuid: UUID,
                providerId: String,
                email: String? = nil,
                displayName: String? = nil,
                phoneNumber: String? = nil,
                photo: Data? = nil,
                favourites: Favourite? = nil) {
        self.uuid = uuid
        self.providerId = providerId
        self.email = email
        self.displayName = displayName
        self.phoneNumber = phoneNumber
        self.photo = photo
        self.favourites = favourites
    }
}
