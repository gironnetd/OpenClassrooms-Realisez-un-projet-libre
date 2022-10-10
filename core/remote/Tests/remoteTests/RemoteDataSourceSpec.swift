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

        var account: RemoteAccount!
        var accountRef: DocumentReference!
        
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
            remoteDataSource = FirestoreRemoteDataSource()
            
            do {
                _ = try Future<Void, Error> { promise in
                    account = RemoteAccount.testAccount()

                    // Get new write batch
                    let batch = firestore.batch()

                    accountRef = firestore.collection(Constants.ACCOUNT_TABLE).document(account.uid)
                    batch.setData(account.dictionary as [String : Any], forDocument: accountRef)

                    firstFavourite = RemoteFavourite.testFavourite()
                    firstFavourite.uidAccount = account.uid
                    firstFavourite.idParentDirectory = nil
                    firstFavourite.idAuthors = [1,2]
                    
                    secondFavourite = RemoteFavourite.testFavourite()
                    secondFavourite.uidAccount = account.uid
                    secondFavourite.idParentDirectory = firstFavourite.idDirectory
                    
                    thirdFavourite = RemoteFavourite.testFavourite()
                    thirdFavourite.uidAccount = account.uid
                    
                    thirdFavourite.idParentDirectory = firstFavourite.idDirectory
                    
                    fourthFavourite = RemoteFavourite.testFavourite()
                    fourthFavourite.uidAccount = UUID().uuidString
                    
                    fourthFavourite.idParentDirectory = firstFavourite.idDirectory
                    
                    fifthFavourite = RemoteFavourite.testFavourite()
                    fifthFavourite.uidAccount = account.uid
                    
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

                    batch.commit() { err in
                        if let err = err {
                            print("Error writing batch \(err)")
                            promise(.failure(err))
                        } else {
                            print("Batch write succeeded.")
                            promise(.success(()))
                            
                        }
                    }
                }.waitingCompletion()
            } catch( let error) {
                print(error)
            }
        }

        afterEach {
            do {
                _ = try Future<Void, Error> { promise in
                    let batch = firestore.batch()
                    
                    batch.deleteDocument(accountRef)
                    batch.deleteDocument(firstFavouriteRef)
                    batch.deleteDocument(secondFavouriteRef)
                    batch.deleteDocument(thirdFavouriteRef)
                    batch.deleteDocument(fourthFavouriteRef)
                    batch.deleteDocument(fifthFavouriteRef)
                    
                    batch.commit() { err in
                        if let err = err {
                            print("Error writing batch \(err)")
                            promise(.failure(err))
                        } else {
                            print("Batch write succeeded.")
                            promise(.success(()))
                        }
                    }
                }.waitingCompletion()
            } catch( let error) {
                print(error)
            }
        }
        
        describe("Find Account by Uuid") {
            context("Found") {
                it("Account is returned") {
                    secondFavourite.subDirectories.append(fifthFavourite)
                    firstFavourite.subDirectories.append(contentsOf: [secondFavourite, thirdFavourite])
                    account.favourites = firstFavourite
                    
                    let expectedAccount = try remoteDataSource.findAccount(byUid: account.uid).waitingCompletion().first
                    expect { expectedAccount }.to(equal(account))
                }
            }
            
            context("Found without Favourites") {
                it("Account is returned") {
                    do {
                        _ = try Future<Void, Error> { promise in
                            let batch = firestore.batch()
                            
                            batch.deleteDocument(firstFavouriteRef)
                            batch.deleteDocument(secondFavouriteRef)
                            batch.deleteDocument(thirdFavouriteRef)
                            batch.deleteDocument(fourthFavouriteRef)
                            batch.deleteDocument(fifthFavouriteRef)
                            
                            batch.commit() { err in
                                print("Batch write succeeded.")
                                promise(.success(()))
                            }
                        }.waitingCompletion()
                    } catch( let error) {
                        print(error)
                    }
                    
                    let expectedAccount = try remoteDataSource.findAccount(byUid: account.uid).waitingCompletion().first
                    expect { expectedAccount }.to(equal(account))
                }
            }
            
            context("Not Found") {
                it("Error is thrown") {
                    expect { try remoteDataSource.findAccount(byUid: DataFactory.randomString()).waitingCompletion().first }.to(throwError())
                }
            }
        }
        
        describe("Save or Update Account") {
            context("Saved") {
                it("Return saved succeeded") {
                    let newAccount = RemoteAccount.testAccount()
                    
                    expect { try remoteDataSource.saveOrUpdate(account: newAccount).waitingCompletion().first }.to(beVoid())
                    
                    _ = try Future <Void, Error> { promise in
                        firestore.collection(Constants.ACCOUNT_TABLE)
                            .document(newAccount.uid).getDocument(as: RemoteAccount.self) { result in
                                switch result {
                                case .success(let account):
                                    expect { account }.to(equal(newAccount))
                                    
                                    promise(.success(()))
                                case .failure (let error):
                                    promise(.failure(error))
                                }
                        }
                    }.waitingCompletion()
                    _ = try? remoteDataSource.deleteAccount(byUid: newAccount.uid).waitingCompletion()
                }
            }
            
            context("Updated") {
                it("Return updated succeeded") {
                    account.displayName = DataFactory.randomString()
                    
                    expect { try remoteDataSource.saveOrUpdate(account: account).waitingCompletion().first }.to(beVoid())
                    
                    _ = try Future <Void, Error> { promise in
                        firestore.collection(Constants.ACCOUNT_TABLE)
                            .document(account.uid).getDocument(as: RemoteAccount.self) { result in
                                switch result {
                                case .success(let updatedAccount):
                                    account.favourites = nil
                                    expect { updatedAccount }.to(equal(account))
                                    promise(.success(()))
                                case .failure (let error):
                                    promise(.failure(error))
                                }
                        }
                    }.waitingCompletion()
                }
            }
        }
        
        describe("Delete Account by Uuid") {
            context("Found") {
                it("Return deletion succeeded") {
                    
                    expect { try remoteDataSource.deleteAccount(byUid: account.uid).waitingCompletion().first }.to(beVoid())
                    
                    _ = try Future <Void, Error> { promise in
                        firestore.collection(Constants.ACCOUNT_TABLE).getDocuments() { (querySnapshot, error) in
                            
                            guard let querySnapshot = querySnapshot else {
                                if let error = error {
                                    promise(.failure(error))
                                }
                                return
                            }
                            expect { querySnapshot.documents }.to(beEmpty())
                            promise(.success(()))
                        }
                    }.waitingCompletion()
                }
            }
            
            context("Not Found") {
                it("Error is thrown") {
                    expect { try remoteDataSource.deleteAccount(byUid: DataFactory.randomString()).waitingCompletion().first }.to(throwError())
                }
            }
        }
        
        describe("Save or Update Favourite") {
            context("Saved") {
                it("Return saved succeeded") {
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
                    firstFavourite.directoryName = DataFactory.randomString()
                    
                    expect { try remoteDataSource.saveOrUpdate(favourite: firstFavourite).waitingCompletion().first }.to(beVoid())
                    
                    _ = try Future <Void, Error> { promise in
                        firestore.collection(Constants.FAVOURITE_TABLE)
                            .document(firstFavourite.idDirectory).getDocument(as: RemoteFavourite.self) { result in
                                switch result {
                                case .success(let updatedFavourite):
                                    account.favourites = nil
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
        
        describe("Delete Favourite by idDirectory") {
            context("Found") {
                it("Return deletion succeeded") {
                    
                    expect { try remoteDataSource.deleteFavourite(byIdDirectory: firstFavourite.idDirectory).waitingCompletion().first }.to(beVoid())
                    
                    _ = try Future <Void, Error> { promise in
                        firestore.collection(Constants.FAVOURITE_TABLE).getDocuments() { (querySnapshot, error) in
                            
                            guard let querySnapshot = querySnapshot else {
                                if let error = error {
                                    promise(.failure(error))
                                }
                                return
                            }
                            expect { querySnapshot.documents.compactMap { document in
                                try? document.data(as: RemoteFavourite.self)
                                }
                            }.notTo(contain(firstFavourite))
                            promise(.success(()))
                        }
                    }.waitingCompletion()
                }
            }
            
            context("Not Found") {
                it("Error is thrown") {
                    expect { try remoteDataSource.deleteFavourite(byIdDirectory: DataFactory.randomString()).waitingCompletion().first }.to(throwError())
                }
            }
        }
    }
}
