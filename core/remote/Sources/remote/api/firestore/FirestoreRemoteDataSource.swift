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
    ///   - uuid: The identifier of the account
    ///
    /// - Returns: A Future returning an RemoteAccount or an Error
    func findAccount(byUid uid: String) -> Future<RemoteAccount, Error> {
        Future { [self] promise in
            let docRef = firestore.collection(Constants.ACCOUNT_TABLE).document(uid)
            
            docRef.getDocument(as: RemoteAccount.self) { result in
                switch result {
                case .success(var account):
                    firestore.collection(Constants.FAVOURITE_TABLE)
                        .whereField("uidAccount", isEqualTo: account.uid)
                        .getDocuments() { (querySnapshot, err) in
                            guard let querySnapshot = querySnapshot, !querySnapshot.isEmpty else {
                                return promise(.success(account))
                            }
                            
                            let favourites = querySnapshot.documents.compactMap { document in try? document.data(as: RemoteFavourite.self) }
                            
                            account.favourites = favourites.reduce(into: favourites) { result, favourite in
                                result.first(where: { idParentFavourite in idParentFavourite.idDirectory == favourite.idParentDirectory })?.subDirectories.append(favourite)
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
                let docRef = firestore.collection(Constants.ACCOUNT_TABLE).document(account.uid)
                docRef.getDocument { (document, error) in
                    guard let document = document, document.exists else {
                        firestore.collection(Constants.ACCOUNT_TABLE).document(account.uid).setData(account.dictionary as [String : Any])
                            return promise(.success(()))
                    }
                    docRef.updateData(account.dictionary as [AnyHashable : Any])
                    promise(.success(()))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    /// Delete an Account to remote
    ///
    /// - Parameters:
    ///   - uuid: The UUID of the account
    @discardableResult
    func deleteAccount(byUid uid: String) -> AnyPublisher<Void, Error> {
        Future { [self] promise in
            let accountRef = firestore.collection(Constants.ACCOUNT_TABLE).document(uid)
            
            accountRef.getDocument(as: RemoteAccount.self) { result in
                switch result {
                case .success:
                    accountRef.delete()
                    promise(.success(()))
                case .failure(let error):
                    promise(.failure(error))
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
                docRef.getDocument { (document, error) in
                    guard let document = document, document.exists else {
                        firestore.collection(Constants.FAVOURITE_TABLE).document(favourite.idDirectory).setData(favourite.dictionary as [String : Any])
                            return promise(.success(()))
                    }
                    docRef.updateData(favourite.dictionary as [AnyHashable : Any])
                    promise(.success(()))
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
            let favouriteRef = firestore.collection(Constants.FAVOURITE_TABLE).document(idDirectory)
            
            favouriteRef.getDocument(as: RemoteFavourite.self) { result in
                switch result {
                case .success:
                    favouriteRef.delete()
                    promise(.success(()))
                case .failure(let error):
                    promise(.failure(error))
                }
            }
        }.eraseToAnyPublisher()
    }
}
