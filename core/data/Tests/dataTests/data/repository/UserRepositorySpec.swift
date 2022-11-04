//
//  File.swift
//  
//
//  Created by damien on 11/10/2022.
//

import Foundation
import Quick
import Nimble
import testing
import remote
import cache
import model
import FirebaseAuth

@testable import data

class UserRepositorySpec: QuickSpec {
    
    override func spec() {
        
        var userRepository: DefaultUserRepository!
        var userDao: UserDao!
        var remoteFirebase: OlaRemoteFirebase!
        
        var currentUser: RemoteUser!
        
        beforeEach {
            userDao = TestUserDao()
            remoteFirebase = TestOlaRemoteFirebase()
            userRepository = DefaultUserRepository(userDao: userDao, remoteFirebase: remoteFirebase)
        
            currentUser = RemoteUser.testUser()
        }
        
        describe("Signin with credential") {
            context("Found") {
                it("Return user succeeded") {
                    let email = DataFactory.randomEmail()
                    currentUser.email = email
                    
                    (remoteFirebase as? TestOlaRemoteFirebase)?.currentUser = currentUser
                    
                    let credential = EmailAuthProvider.credential(withEmail: email, password: DataFactory.randomString())
                    
                    expect {
                        try userRepository.signIn(with: credential).waitingCompletion().first
                    }.to(equal(currentUser.asCached().asExternalModel()))
                }
            }
            
            context("Not found") {
                it("Error is thrown") {
                    let email = DataFactory.randomEmail()
                    currentUser.email = email
                    
                    let credential = EmailAuthProvider.credential(withEmail: email, password: DataFactory.randomString())
                    
                    expect {
                        try userRepository.signIn(with: credential).waitingCompletion().first
                    }.to(throwError())
                }
            }
        }
        
        describe("Signin with email and password") {
            context("Found") {
                it("Return user succeeded") {
                    let email = DataFactory.randomEmail()
                    let password = DataFactory.randomString()
                    currentUser.email = email
                    
                    (remoteFirebase as? TestOlaRemoteFirebase)?.currentUser = currentUser
                    
                    expect {
                        try userRepository.signIn(withEmail: email, password: password).waitingCompletion().first
                    }.to(equal(currentUser.asCached().asExternalModel()))
                }
            }
            
            context("Not found") {
                it("Error is thrown") {
                    let email = DataFactory.randomEmail()
                    let password = DataFactory.randomString()
                    currentUser.email = email
                    
                    expect {
                        try userRepository.signIn(withEmail: email, password: password).waitingCompletion().first
                    }.to(throwError())
                }
            }
        }
        
        describe("Signout") {
            context("Succeeded") {
                it("Return signout succeeded") {
                    (remoteFirebase as? TestOlaRemoteFirebase)?.currentUser = currentUser
                    (userDao as? TestUserDao)?.currentUser = currentUser.asCached()
                    
                    expect {
                        try userRepository.signOut().waitingCompletion().first
                    }.to(beVoid())
                }
            }
            
            context("Already signout") {
                it("Error is thrown") {
                    expect {
                        try userRepository.signOut().waitingCompletion().first
                    }.to(throwError())
                }
            }
        }
        
        describe("Create user with email and password") {
            context("Saved") {
                it("Return user succeeded") {
                    let email = DataFactory.randomEmail()
                    let password = DataFactory.randomString()
                    
                    expect {
                        try userRepository.createUser(withEmail: email, password: password).waitingCompletion().first!.email
                    }.to(equal(email))
                }
            }
        }
        
        describe("Find current user") {
            context("Found") {
                it("Return user succeeded") {
                    (userDao as? TestUserDao)?.currentUser = currentUser.asCached()
                    
                    expect {
                        try userRepository.findCurrentUser().waitingCompletion().first
                    }.to(equal(currentUser.asCached().asExternalModel()))
                }
            }
            
            context("Not found") {
                it("Error is thrown") {
                    expect {
                        try userRepository.findCurrentUser().waitingCompletion().first
                    }.to(throwError())
                }
            }
        }
        
        describe("Delete current user") {
            context("Found") {
                it("Return user deleted") {
                    (remoteFirebase as? TestOlaRemoteFirebase)?.currentUser = currentUser
                    (userDao as? TestUserDao)?.currentUser = currentUser.asCached()
                    
                    expect {
                        try userRepository.deleteCurrentUser().waitingCompletion().first
                    }.to(beVoid())
                }
            }
            
            context("Not found") {
                it("Error is thrown") {
                    expect {
                        try userRepository.deleteCurrentUser().waitingCompletion().first
                    }.to(throwError())
                }
            }
        }
        
        describe("Save or update favourite") {
            context("Saved or update") {
                it("Return saved or updated succeeded") {
                    let newFavourite = Favourite.testFavourite()
                    
                    expect {
                        try userRepository.saveOrUpdate(favourite: newFavourite).waitingCompletion().first
                    }.to(beVoid())
                }
            }
        }
        
        describe("Delete favourite") {
            context("Deleted") {
                it("Return deletion succeeded") {
                    let newFavourite = Favourite.testFavourite()
                    
                    expect {
                        try userRepository.deleteFavourite(byIdDirectory: newFavourite.idDirectory).waitingCompletion().first
                    }.to(beVoid())
                }
            }
        }
    }
}
