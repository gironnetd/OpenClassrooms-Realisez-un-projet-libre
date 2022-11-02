//
//  File.swift
//  
//
//  Created by damien on 15/09/2022.
//

import Foundation
import Quick
import Nimble
import testing
import Combine
import FirebaseCore
import FirebaseFirestore

@testable import remote

class RemoteDataSourceSpec: QuickSpec {
    
    override func spec() {
        
        var remoteDataSource: OlaRemoteDataSource!
        var firestore: Firestore!

        var user: RemoteUser!
        var userRef: DocumentReference!
        
        var firstFavourite: RemoteFavourite!
        var firstFavouriteRef: DocumentReference!
        
        var secondFavourite: RemoteFavourite!
        var secondFavouriteRef: DocumentReference!
        
        var thirdFavourite: RemoteFavourite!
        var thirdFavouriteRef: DocumentReference!
        
        var fourthFavourite: RemoteFavourite!
        var fourthFavouriteRef: DocumentReference!
        
        var fifthFavourite: RemoteFavourite!
        var fifthFavouriteRef: DocumentReference!
        
        var batch: WriteBatch!
        
        beforeSuite {
            let path = Bundle.module.url(forResource: "GoogleService-Info", withExtension: "plist")
            let firbaseOptions = FirebaseOptions(contentsOfFile: path!.path)
            
            FirebaseApp.configure(options: firbaseOptions!)
            let settings = Firestore.firestore().settings
            settings.host = "localhost:8080"
            settings.isPersistenceEnabled = false
            settings.isSSLEnabled = false
            Firestore.firestore().settings = settings
        }
        
        beforeEach {
            firestore = Firestore.firestore()
            remoteDataSource = FirestoreRemoteDataSource(firestore: firestore)
            
            user = RemoteUser.testUser()

            // Get new write batch
            batch = firestore.batch()

            userRef = firestore.collection(Constants.USER_TABLE).document(user.uid)
            batch.setData(user.dictionary as [String : Any], forDocument: userRef)

            firstFavourite = RemoteFavourite.testFavourite()
            firstFavourite.uidUser = user.uid
            firstFavourite.idParentDirectory = nil
            firstFavourite.idAuthors = [1,2]
            
            secondFavourite = RemoteFavourite.testFavourite()
            secondFavourite.uidUser = user.uid
            secondFavourite.idParentDirectory = firstFavourite.idDirectory
            
            thirdFavourite = RemoteFavourite.testFavourite()
            thirdFavourite.uidUser = user.uid
            
            thirdFavourite.idParentDirectory = firstFavourite.idDirectory
            
            fourthFavourite = RemoteFavourite.testFavourite()
            fourthFavourite.uidUser = UUID().uuidString
            
            fourthFavourite.idParentDirectory = firstFavourite.idDirectory
            
            fifthFavourite = RemoteFavourite.testFavourite()
            fifthFavourite.uidUser = user.uid
            
            fifthFavourite.idParentDirectory = secondFavourite.idDirectory
            
            firstFavouriteRef = firestore.collection(Constants.FAVOURITE_TABLE).document(firstFavourite.idDirectory)
            batch.setData(firstFavourite.dictionary as [String : Any], forDocument: firstFavouriteRef)

            secondFavouriteRef = firestore.collection(Constants.FAVOURITE_TABLE).document(secondFavourite.idDirectory)
            batch.setData(secondFavourite.dictionary as [String : Any], forDocument: secondFavouriteRef)
            
            thirdFavouriteRef = firestore.collection(Constants.FAVOURITE_TABLE).document(thirdFavourite.idDirectory)
            batch.setData(thirdFavourite.dictionary as [String : Any], forDocument: thirdFavouriteRef)
            
            fourthFavouriteRef = firestore.collection(Constants.FAVOURITE_TABLE).document(fourthFavourite.idDirectory)
            batch.setData(fourthFavourite.dictionary as [String : Any], forDocument: fourthFavouriteRef)
            
            fifthFavouriteRef = firestore.collection(Constants.FAVOURITE_TABLE).document(fifthFavourite.idDirectory)
            batch.setData(fifthFavourite.dictionary as [String : Any], forDocument: fifthFavouriteRef)
        }

        afterEach {
            batch = firestore.batch()
            
            batch.deleteDocument(userRef)
            batch.deleteDocument(firstFavouriteRef)
            batch.deleteDocument(secondFavouriteRef)
            batch.deleteDocument(thirdFavouriteRef)
            batch.deleteDocument(fourthFavouriteRef)
            batch.deleteDocument(fifthFavouriteRef)
                    
            _ = try? (batch.commit() as Future<Void, Error>).waitingCompletion()
        }
        
        describe("Find user by uid") {
            context("Found") {
                it("User is returned") {
                    _ = try (batch.commit() as Future<Void, Error>).waitingCompletion()
                    
                    secondFavourite.subDirectories?.append(fifthFavourite)
                    firstFavourite.subDirectories?.append(contentsOf: [secondFavourite, thirdFavourite])
                    user.favourites = firstFavourite
                    
                    let expectedUser = try remoteDataSource.findUser(byUid: user.uid).waitingCompletion().first
                    expect { expectedUser }.to(equal(user))
                }
            }
            
            context("Found without favourites") {
                it("User is returned") {
                    batch.deleteDocument(firstFavouriteRef)
                    batch.deleteDocument(secondFavouriteRef)
                    batch.deleteDocument(thirdFavouriteRef)
                    batch.deleteDocument(fourthFavouriteRef)
                    batch.deleteDocument(fifthFavouriteRef)
                    
                    _ = try (batch.commit() as Future<Void, Error>).waitingCompletion()
                    
                    let expectedUser = try remoteDataSource.findUser(byUid: user.uid).waitingCompletion().first
                    expect { expectedUser }.to(equal(user))
                }
            }
            
            context("Not found") {
                it("Error is thrown") {
                    _ = try (batch.commit() as Future<Void, Error>).waitingCompletion()
                    
                    expect { try remoteDataSource.findUser(byUid: DataFactory.randomString()).waitingCompletion().first }.to(throwError())
                }
            }
        }
        
        describe("Save or update user") {
            context("Saved") {
                it("Return saved succeeded") {
                    _ = try (batch.commit() as Future<Void, Error>).waitingCompletion()
                    
                    let newUser = RemoteUser.testUser()
                    
                    expect { try remoteDataSource.saveOrUpdate(user: newUser).waitingCompletion().first }.to(beVoid())
                    
                    _ = try Future <Void, Error> { promise in
                        firestore.collection(Constants.USER_TABLE)
                            .document(newUser.uid).getDocument(as: RemoteUser.self) { result in
                                switch result {
                                case .success(let user):
                                    expect { user }.to(equal(newUser))
                                    
                                    promise(.success(()))
                                case .failure (let error):
                                    promise(.failure(error))
                                }
                        }
                    }.waitingCompletion()
                    _ = try? remoteDataSource.deleteUser(byUid: newUser.uid).waitingCompletion()
                }
            }
            
            context("Updated") {
                it("Return updated succeeded") {
                    _ = try (batch.commit() as Future<Void, Error>).waitingCompletion()
                    
                    user.displayName = DataFactory.randomString()
                    
                    expect { try remoteDataSource.saveOrUpdate(user: user).waitingCompletion().first }.to(beVoid())
                    
                    _ = try Future <Void, Error> { promise in
                        firestore.collection(Constants.USER_TABLE)
                            .document(user.uid).getDocument(as: RemoteUser.self) { result in
                                switch result {
                                case .success(let updatedUser):
                                    user.favourites = nil
                                    expect { updatedUser }.to(equal(user))
                                    promise(.success(()))
                                case .failure (let error):
                                    promise(.failure(error))
                                }
                        }
                    }.waitingCompletion()
                }
            }
        }
        
        describe("Delete user by uid") {
            context("Found") {
                it("Return deletion succeeded") {
                    firstFavourite.uidUser = user.uid
                    
                    _ = try (batch.commit() as Future<Void, Error>).waitingCompletion()
                    
                    expect { try remoteDataSource.deleteUser(byUid: user.uid).waitingCompletion().first }.to(beVoid())
                    
                    _ = try Future <Void, Error> { promise in
                        firestore.collection(Constants.USER_TABLE).getDocuments() { (querySnapshot, error) in
                            
                            guard let querySnapshot = querySnapshot else {
                                if let error = error {
                                    promise(.failure(error))
                                }
                                return
                            }
                            expect { querySnapshot.documents.compactMap { document in
                                try? document.data(as: RemoteUser.self)
                                }
                            }.notTo(contain(user))
                            promise(.success(()))
                        }
                    }.waitingCompletion()
                    
                    _ = try Future<Void, Error> { promise in
                        firestore.collection(Constants.FAVOURITE_TABLE).getDocuments() { (querySnapshot, error) in
                            
                            guard let querySnapshot = querySnapshot else {
                                if let error = error {
                                    promise(.failure(error))
                                }
                                return
                            }
                            
                            let actual = querySnapshot.documents.compactMap { document in
                                try? document.data(as: RemoteFavourite.self).idDirectory
                            }
                            
                            expect { actual }.notTo(contain([firstFavourite.idDirectory, secondFavourite.idDirectory, thirdFavourite.idDirectory,
                                fifthFavourite.idDirectory
                            ]))
                            promise(.success(()))
                        }
                    }.waitingCompletion()
                }
            }
            
            context("Not found") {
                it("Error is thrown") {
                    _ = try (batch.commit() as Future<Void, Error>).waitingCompletion()
                    
                    expect { try remoteDataSource.deleteUser(byUid: DataFactory.randomString()).waitingCompletion().first }.to(throwError())
                }
            }
        }
        
        describe("Save or update Favourite") {
            context("Saved") {
                it("Return saved succeeded") {
                    _ = try (batch.commit() as Future<Void, Error>).waitingCompletion()
                    
                    let newFavourite = RemoteFavourite.testFavourite()
                    
                    expect { try remoteDataSource.saveOrUpdate(favourite: newFavourite).waitingCompletion().first }.to(beVoid())
                    
                    _ = try Future <Void, Error> { promise in
                        firestore.collection(Constants.FAVOURITE_TABLE)
                            .document(newFavourite.idDirectory).getDocument(as: RemoteFavourite.self) { result in
                                switch result {
                                case .success(let favourite):
                                    expect { favourite }.to(equal(newFavourite))
                                    
                                    promise(.success(()))
                                case .failure (let error):
                                    promise(.failure(error))
                                }
                        }
                    }.waitingCompletion()
                    _ = try? remoteDataSource.deleteFavourite(byIdDirectory: newFavourite.idDirectory).waitingCompletion()
                }
            }
            
            context("Updated") {
                it("Return updated succeeded") {
                    _ = try (batch.commit() as Future<Void, Error>).waitingCompletion()
                    
                    firstFavourite.directoryName = DataFactory.randomString()
                    
                    expect { try remoteDataSource.saveOrUpdate(favourite: firstFavourite).waitingCompletion().first }.to(beVoid())
                    
                    _ = try Future <Void, Error> { promise in
                        firestore.collection(Constants.FAVOURITE_TABLE)
                            .document(firstFavourite.idDirectory).getDocument(as: RemoteFavourite.self) { result in
                                switch result {
                                case .success(let updatedFavourite):
                                    user.favourites = nil
                                    expect { updatedFavourite }.to(equal(firstFavourite))
                                    promise(.success(()))
                                case .failure (let error):
                                    promise(.failure(error))
                                }
                        }
                    }.waitingCompletion()
                }
            }
        }
        
        describe("Delete favourite by idDirectory") {
            context("Found") {
                it("Return deletion succeeded") {
                    _ = try (batch.commit() as Future<Void, Error>).waitingCompletion()
                    
                    expect { try remoteDataSource.deleteFavourite(byIdDirectory: firstFavourite.idDirectory).waitingCompletion().first }.to(beVoid())
                    
                    _ = try Future<Void, Error> { promise in
                        firestore.collection(Constants.FAVOURITE_TABLE).getDocuments() { (querySnapshot, error) in
                            
                            guard let querySnapshot = querySnapshot else {
                                if let error = error {
                                    promise(.failure(error))
                                }
                                return
                            }
                            
                            let actual = querySnapshot.documents.compactMap { document in
                                try? document.data(as: RemoteFavourite.self).idDirectory
                            }
                            
                            expect { actual }.notTo(contain([firstFavourite.idDirectory, secondFavourite.idDirectory, thirdFavourite.idDirectory,
                                fifthFavourite.idDirectory
                            ]))
                            promise(.success(()))
                        }
                    }.waitingCompletion()
                }
            }
        }
    }
}
