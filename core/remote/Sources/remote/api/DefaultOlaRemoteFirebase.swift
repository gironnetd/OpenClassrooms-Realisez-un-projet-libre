//
//  File.swift
//  
//
//  Created by damien on 24/10/2022.
//

import Foundation
import Combine
import FirebaseAuth

public class DefaultOlaRemoteFirebase: OlaRemoteFirebase {
    
    private var currentUser: User?
    
    private let authentication: OlaRemoteAuthentication
    private let firestore: OlaRemoteDataSource
    
    init(authentication: OlaRemoteAuthentication, firestore: OlaRemoteDataSource) {
        self.authentication = authentication
        self.firestore = firestore
    }
    
    public func signIn(with credential: AuthCredential) -> AnyPublisher<RemoteUser, Error> {
        self.authentication.signIn(with: credential)
            .flatMap { user -> AnyPublisher<RemoteUser, Error> in
                self.currentUser = user
                
                var currentUser = RemoteUser(uid: user.uid,
                                             providerID: user.providerID,
                                             email: user.email,
                                             displayName: user.displayName,
                                             phoneNumber: user.phoneNumber,
                                             photo: nil,
                                             favourites: nil)
                
                guard let photoUrl = user.photoURL else {
                    return Just(currentUser).setFailureType(to: Error.self).eraseToAnyPublisher()
                }
                
                return URLSession.shared.dataTaskPublisher(for: photoUrl)
                    .tryMap() { element -> RemoteUser in
                        currentUser.photo = element.data
                        return currentUser
                    }.eraseToAnyPublisher()
            }.eraseToAnyPublisher()
    }
    
    public func signIn(withEmail email: String, password: String) -> AnyPublisher<RemoteUser, Error> {
        self.authentication.signIn(withEmail: email, password: password)
            .flatMap { user -> AnyPublisher<RemoteUser, Error> in
                self.currentUser = user
                
                var currentUser = RemoteUser(uid: user.uid,
                                             providerID: user.providerID,
                                             email: user.email,
                                             displayName: user.displayName,
                                             phoneNumber: user.phoneNumber,
                                             photo: nil,
                                             favourites: nil)
                
                guard let photoUrl = user.photoURL else {
                    return Just(currentUser).setFailureType(to: Error.self).eraseToAnyPublisher()
                }
                
                return URLSession.shared.dataTaskPublisher(for: photoUrl)
                    .tryMap() { element -> RemoteUser in
                        currentUser.photo = element.data
                        return currentUser
                    }.eraseToAnyPublisher()
            }.eraseToAnyPublisher()
    }
    
    public func signOut() -> AnyPublisher<Void, Error> {
        self.authentication.signOut()
            .handleEvents(receiveCompletion: { completion in
                self.currentUser = nil
            }).eraseToAnyPublisher()
    }
    
    public func createUser(withEmail email: String, password: String) -> AnyPublisher<RemoteUser, Error> {
        self.authentication.createUser(withEmail: email, password: password)
            .flatMap { user -> AnyPublisher<RemoteUser, Error> in
                self.currentUser = user
                
                var currentUser = RemoteUser(uid: user.uid,
                                             providerID: user.providerID,
                                             email: user.email,
                                             displayName: user.displayName,
                                             phoneNumber: user.phoneNumber,
                                             photo: nil,
                                             favourites: nil)
                
                guard let photoUrl = user.photoURL else {
                    return Just(currentUser).setFailureType(to: Error.self).eraseToAnyPublisher()
                }
                
                return URLSession.shared.dataTaskPublisher(for: photoUrl)
                    .tryMap() { element -> RemoteUser in
                        currentUser.photo = element.data
                        return currentUser
                    }.eraseToAnyPublisher()
            }
            .map { user in
                self.firestore.saveOrUpdate(user: user)
                return user
            }
            .eraseToAnyPublisher()
    }
    
    public func deleteCurrentUser() -> AnyPublisher<Void, Error> {
        guard let currentUser = self.currentUser else {
            return Fail(error: NSError(domain: "", code: 0, userInfo: nil)).eraseToAnyPublisher()
        }
        
        return self.authentication.deleteUser(byUser: currentUser)
            .append(self.firestore.deleteUser(byUid: currentUser.uid))
            .handleEvents(receiveCompletion: { completion in
                self.currentUser = nil
            })
            .eraseToAnyPublisher()
    }
    
    @discardableResult
    public func saveOrUpdate(favourite: RemoteFavourite) -> AnyPublisher<Void, Error> {
        guard let currentUser = self.currentUser else {
            return Fail(error: NSError(domain: "", code: 0, userInfo: nil)).eraseToAnyPublisher()
        }
        favourite.uidUser = currentUser.uid
        return self.firestore.saveOrUpdate(favourite: favourite)
    }
    
    @discardableResult
    public func deleteFavourite(byIdDirectory idDirectory: String) -> AnyPublisher<Void, Error> {
        self.firestore.deleteFavourite(byIdDirectory: idDirectory)
    }
}
