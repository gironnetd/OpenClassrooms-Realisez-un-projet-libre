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
protocol OlaRemoteDataSource {
    
    /// Retrieve an Account from its identifier UUID, from remote
    ///
    /// - Parameters:
    ///   - uuid: The identifier of the Account
    ///
    /// - Returns: A Future returning an RemoteAccount or an Error
    func findAccount(byUid uid: String) -> Future<RemoteAccount, Error>
    
    /// Save or update an Account to the cache
    ///
    /// - Parameters:
    ///   - account: An RemoteAccount
    @discardableResult
    func saveOrUpdate(account: RemoteAccount) -> AnyPublisher<Void, Error>
    
    /// Delete an Account to remote
    ///
    /// - Parameters:
    ///   - uuid: The UUID identifier of the account
    @discardableResult
    func deleteAccount(byUid uid: String) -> AnyPublisher<Void, Error>

    /// Save or update an Favourite to remote
    ///
    /// - Parameters:
    ///   - account: A RemoteFavourite
    @discardableResult
    func saveOrUpdate(favourite: RemoteFavourite) -> AnyPublisher<Void, Error>
    
    /// Delete a Favourite to the remote
    ///
    /// - Parameters:
    ///   - idDirectory: The identifier of the favourite folder
    @discardableResult
    func deleteFavourite(byIdDirectory idDirectory: String) -> AnyPublisher<Void, Error>
}
