//
//  File.swift
//  
//
//  Created by damien on 26/09/2022.
//

import Foundation
import Combine
import FirebaseCore
import FirebaseFirestore
import FirebaseFirestoreSwift

/**
 * Default Implementation for the Remote Data Protocol.
 */
class FirestoreRemoteDataSource: OlaRemoteDataSource {
    
    private let firestore: Firestore
    
    init() {
        firestore = Firestore.firestore()
    }
    
    /// Retrieve an Account from its identifier UUID, from remote
    ///
    /// - Parameters:
    ///   - uuid: The UUID of the account
    ///
    /// - Returns: A Future returning an RemoteAccount or an Error
    func findAccount(byUuid uuid: UUID) -> Future<RemoteAccount, Error> {
        Future { [self] promise in
            let docRef = firestore.collection(Constants.ACCOUNT_TABLE).document(uuid.uuidString)
            
            docRef.getDocument(as: RemoteAccount.self) { result in
                switch result {
                case .success(var account):
                    firestore.collection(Constants.FAVOURITE_TABLE)
                        .whereField("uuidAccount", isEqualTo: account.uuid.uuidString)
                        .getDocuments() { (querySnapshot, err) in
                            guard let querySnapshot = querySnapshot, !querySnapshot.isEmpty else {
                                return promise(.success(account))
                            }
                            
                            let favourites = querySnapshot.documents.compactMap { document in try? document.data(as: RemoteFavourite.self) }
                            
                            account.favourites = favourites.reduce(into: favourites) { result, favourite in
                                result.first(where: { idParentFavourite in idParentFavourite.idDirectory == favourite.idParentDirectory })?.subDirectories?.append(favourite)
                            }.first { favourite in favourite.idParentDirectory == nil }
                            
                            promise(.success(account))
                        }
                case .failure(let error):
                    promise(.failure(error))
                }
            }
        }
    }
    
    /// Save or update an Account to the cache
    ///
    /// - Parameters:
    ///   - account: An RemoteAccount
    @discardableResult
    func saveOrUpdate(account: RemoteAccount) -> AnyPublisher<Void, Error> {
        Future { [self] promise in
            do {
                let docRef = firestore.collection(Constants.ACCOUNT_TABLE).document(account.uuid.uuidString)
                docRef.getDocument { (document, error) in
                    if let document = document, document.exists {
                        docRef.updateData(account.dictionary as [AnyHashable : Any]) { error in
                            if let error = error {
                                promise(.failure(error))
                            } else {
                                promise(.success(()))
                            }
                        }
                    } else {
                        do {
                            try firestore.collection(Constants.ACCOUNT_TABLE).document(account.uuid.uuidString).setData(from: account)
                            promise(.success(()))
                        } catch let error {
                            promise(.failure(error))
                        }
                    }
                }
            }
        }.eraseToAnyPublisher()
    }
    
    /// Delete an Account to remote
    ///
    /// - Parameters:
    ///   - uuid: The UUID of the account
    @discardableResult
    func deleteAccount(byUuid uuid: UUID) -> AnyPublisher<Void, Error> {
        Future { [self] promise in
            firestore.collection(Constants.ACCOUNT_TABLE).document(uuid.uuidString).delete() { error in
                if let error = error {
                    promise(.failure(error))
                } else {
                    promise(.success(()))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    /// Save or update an Favourite to remote
    ///
    /// - Parameters:
    ///   - account: A RemoteFavourite
    @discardableResult
    func saveOrUpdate(favourite: RemoteFavourite) -> AnyPublisher<Void, Error> {
        Future { [self] promise in
            do {
                let docRef = firestore.collection(Constants.FAVOURITE_TABLE).document(favourite.idDirectory)
                docRef.getDocument { [self] (document, error) in
                    if let document = document, document.exists {
                        docRef.updateData(favourite.dictionary as [AnyHashable : Any]) { error in
                            if let error = error {
                                promise(.failure(error))
                            } else {
                                promise(.success(()))
                            }
                        }
                    } else {
                        do {
                            try firestore.collection(Constants.FAVOURITE_TABLE).document(favourite.idDirectory).setData(from: favourite)
                            promise(.success(()))
                        } catch let error {
                            promise(.failure(error))
                        }
                    }
                }
            }
        }.eraseToAnyPublisher()
    }
    
    /// Delete a Favourite to the remote
    ///
    /// - Parameters:
    ///   - idDirectory: The identifier of the favourite folder
    @discardableResult
    func deleteFavourite(byIdDirectory idDirectory: String) -> AnyPublisher<Void, Error> {
        Future { [self] promise in
            firestore.collection(Constants.FAVOURITE_TABLE).document(idDirectory).delete() { error in
                if let error = error {
                    promise(.failure(error))
                } else {
                    promise(.success(()))
                }
            }
        }.eraseToAnyPublisher()
    }
}
