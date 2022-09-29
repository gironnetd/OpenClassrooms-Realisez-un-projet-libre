//
//  File.swift
//  
//
//  Created by damien on 23/09/2022.
//

import Foundation
import FirebaseAuth

import model
/**
 * Remote Representation for a Account
 */
struct RemoteAccount: Codable  {
    
    var uuid: UUID
    var providerId: String
    var email: String?
    var displayName: String?
    var phoneNumber: String?
    var photo: Data?
    var favourites: RemoteFavourite?
    
    enum CodingKeys: String, CodingKey {
        case uuid
        case providerId
        case email
        case displayName
        case phoneNumber
        case photo
    }
    
    var dictionary: [String: Any?] {
        return [
            "uuid": uuid.uuidString,
            "providerId": providerId,
            "email": email,
            "displayName": displayName,
            "phoneNumber": phoneNumber,
            "photo": photo,
            "favourites": favourites
        ]
    }
}

extension RemoteAccount: DocumentSerializable {
    
    init?(dictionary: [String : Any]) {
        guard let uuid = UUID(uuidString: dictionary["uuid"] as! String),
          let providerId = dictionary["providerId"] as? String,
          let email = dictionary["email"] as? String?,
          let displayName = dictionary["displayName"] as? String?,
          let phoneNumber = dictionary["phoneNumber"] as? String?
        else { return nil }

      self.init(uuid: uuid,
                providerId: providerId,
                email: email,
                displayName: displayName,
                phoneNumber: phoneNumber)
    }
}
