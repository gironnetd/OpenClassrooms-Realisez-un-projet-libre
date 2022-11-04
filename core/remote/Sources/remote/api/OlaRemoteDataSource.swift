//
//  File.swift
//  
//
//  Created by damien on 26/09/2022.
//

import Foundation
import Combine

/**
 * Protocol defining methods for the Remote Data.
 */
public protocol OlaRemoteDataSource {
    
    /// Retrieve an User from its identifier UUID, from remote
    ///
    /// - Parameters:
    ///   - uuid: The identifier of the User
    ///
    /// - Returns: An AnyPublisher returning an RemoteUser or an Error
    func findUser(byUid uid: String) -> AnyPublisher<RemoteUser, Error>
    
    /// Save or update an User to the cache
    ///
    /// - Parameters:
    ///   - user: An RemoteUser
    @discardableResult
    func saveOrUpdate(user: RemoteUser) -> AnyPublisher<Void, Error>
    
    /// Delete a User
    ///
    /// - Parameters:
    ///   - uid: The user to delete
    @discardableResult
    func deleteUser(byUid uid: String) -> AnyPublisher<Void, Error>
    
    /// Save or update an Favourite to remote
    ///
    /// - Parameters:
    ///   - user: A RemoteFavourite
    @discardableResult
    func saveOrUpdate(favourite: RemoteFavourite) -> AnyPublisher<Void, Error>
    
    /// Delete a Favourite to the remote
    ///
    /// - Parameters:
    ///   - idDirectory: The identifier of the favourite folder
    @discardableResult
    func deleteFavourite(byIdDirectory idDirectory: String) -> AnyPublisher<Void, Error>
}
