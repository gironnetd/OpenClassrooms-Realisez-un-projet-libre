//
//  File.swift
//  
//
//  Created by damien on 04/10/2022.
//

import Foundation
import cache
import remote

extension RemoteAccount {
   
    func asCached() -> CachedAccount {
        CachedAccount(uid: self.uid,
                      providerID: self.providerID,
                      email: self.email,
                      displayName: self.displayName,
                      phoneNumber: self.phoneNumber,
                      photo: self.photo,
                      favourites: self.favourites?.asCached())
    }
}


