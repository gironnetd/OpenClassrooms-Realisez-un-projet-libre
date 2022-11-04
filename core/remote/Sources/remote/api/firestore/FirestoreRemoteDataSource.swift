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
import FirebaseFirestoreCombineSwift

/**
 * Default Implementation for the Remote Data Protocol.
 */
public class FirestoreRemoteDataSource: OlaRemoteDataSource {
    
    private let firestore: Firestore
    
    public init(firestore: Firestore) {
        self.firestore = firestore
    }
    
    /// Retrieve an User from its identifier UUID, from remote
    ///
    /// - Parameters:
    ///   - uuid: The identifier of the user
    ///
    /// - Returns: An AnyPublisher returning an RemoteUser or an Error
    public func findUser(byUid uid: String) -> AnyPublisher<RemoteUser, Error> {
        (self.firestore.collection(Constants.USER_TABLE).document(uid)
            .getDocument() as Future<DocumentSnapshot, Error>)
            .flatMap { documentSnapshot -> AnyPublisher<RemoteUser, Error> in
                guard var user = try? documentSnapshot.data(as: RemoteUser.self) else {
                    return Fail(error: NSError(domain: "", code: 0, userInfo: nil)).eraseToAnyPublisher()
                }
                
                return (self.firestore.collection(Constants.FAVOURITE_TABLE)
                            .whereField("uidUser", isEqualTo: user.uid)
                            .getDocuments() as Future<QuerySnapshot, Error>).map { querySnapshot  in
                        guard !querySnapshot.isEmpty else { return user }
                        
                        let favourites = querySnapshot.documents.compactMap { document in try? document.data(as: RemoteFavourite.self) }
                        
                        user.favourites = favourites.reduce(into: favourites) { result, favourite in
                            result.first(where: { idParentFavourite in idParentFavourite.idDirectory == favourite.idParentDirectory })?.subDirectories?.append(favourite)
                        }.first { favourite in favourite.idParentDirectory == nil }
                        
                        return user
                    }.eraseToAnyPublisher()
            }.eraseToAnyPublisher()
    }
    
    /// Save or update an User to the cache
    ///
    /// - Parameters:
    ///   - user: An RemoteUser
    @discardableResult
    public func saveOrUpdate(user: RemoteUser) -> AnyPublisher<Void, Error> {
        (firestore.collection(Constants.USER_TABLE).document(user.uid)
            .getDocument() as Future<DocumentSnapshot, Error>)
            .flatMap { document -> Future<Void, Error> in
                if document.exists {
                    return document.reference.updateData(user.dictionary as [String : Any])
                }
                return document.reference.setData(from: user)
            }.eraseToAnyPublisher()
    }
    
    /// Delete an User to remote
    ///
    /// - Parameters:
    ///   - uuid: The UUID of the user
    @discardableResult
    public func deleteUser(byUid uid: String) -> AnyPublisher<Void, Error> {
        (firestore.collection(Constants.USER_TABLE)
            .document(uid)
            .getDocument() as Future<DocumentSnapshot, Error>)
            .flatMap { documentSnapshot -> AnyPublisher<Void, Error> in
                guard let user = try? documentSnapshot.data(as: RemoteUser.self) else {
                    return Fail(error: NSError(domain: "", code: 0, userInfo: nil)).eraseToAnyPublisher()
                }
                
                return Publishers.Zip(
                    documentSnapshot.reference.delete(),
                    (self.firestore.collection(Constants.FAVOURITE_TABLE)
                        .whereField("uidUser", isEqualTo: user.uid)
                        .getDocuments() as Future<QuerySnapshot, Error>)
                        .flatMap { querySnapshot -> AnyPublisher<Void, Error> in
                            return querySnapshot.documents.compactMap { queryDocumentSnapshot in
                                queryDocumentSnapshot.reference.delete()
                            }.publisher.setFailureType(to: Error.self).eraseToAnyPublisher()
                        }
                        .collect()
                        .map { _ in }
                        .eraseToAnyPublisher()
                )
                .map { _ in }
                .eraseToAnyPublisher()
            }.eraseToAnyPublisher()
    }
    
    /// Save or update an Favourite to remote
    ///
    /// - Parameters:
    ///   - user: A RemoteFavourite
    @discardableResult
    public func saveOrUpdate(favourite: RemoteFavourite) -> AnyPublisher<Void, Error> {
        (firestore.collection(Constants.FAVOURITE_TABLE)
            .document(favourite.idDirectory)
            .getDocument() as Future<DocumentSnapshot, Error>)
            .flatMap { document -> Future<Void, Error> in
                if document.exists {
                    return document.reference.updateData(favourite.dictionary as [String : Any])
                }
                return document.reference.setData(from: favourite)
            }
            .eraseToAnyPublisher()
    }
    
    /// Delete a Favourite to the remote
    ///
    /// - Parameters:
    ///   - idDirectory: The identifier of the favourite folder
    @discardableResult
    public func deleteFavourite(byIdDirectory idDirectory: String) -> AnyPublisher<Void, Error> {
        return Publishers.Zip(
            firestore.collection(Constants.FAVOURITE_TABLE).document(idDirectory).delete(),
            self.deleteFavourites(byIdParentDirectory: idDirectory)
        )
        .map { _ in }
        .eraseToAnyPublisher()
    }
    
    /// Delete all Favourite by idParentDirectory to the remote
    ///
    /// - Parameters:
    ///   - idParentDirectory: The identifier of the parent directory
    private func deleteFavourites(byIdParentDirectory idParentDirectory: String) -> AnyPublisher<Void, Error> {
        (firestore.collection(Constants.FAVOURITE_TABLE)
            .whereField("idParentDirectory", isEqualTo: idParentDirectory)
            .getDocuments() as Future<QuerySnapshot, Error>)
            .flatMap { querySnapshot -> AnyPublisher<Void, Error> in
                Publishers.Sequence(sequence: querySnapshot.documents)
                    .flatMap { document in
                        return document.reference.delete()
                    }.collect()
                    .append(
                        Publishers.Sequence(sequence: querySnapshot.documents.compactMap { document in try? document.data(as: RemoteFavourite.self) })
                            .flatMap { subDirectory in
                                return self.deleteFavourites(byIdParentDirectory: subDirectory.idDirectory)
                            }
                            .collect()
                            .eraseToAnyPublisher()
                    ).collect()
                    .map { _ in }
                    .eraseToAnyPublisher()
            }
            .collect()
            .map { _ in }
            .eraseToAnyPublisher()
    }
}
