//
//  File.swift
//  
//
//  Created by damien on 14/09/2022.
//

import Foundation
import Quick
import Nimble
import RealmSwift
import testing
import CatchRealmException

@testable import cache

class AccountDaoSpec: QuickSpec {

    override func spec() {
        var accountDatabase: Realm!
        var accountDao: AccountDao!
        
        var firstAccount: CachedAccount!
        var secondAccount: CachedAccount!
        var thirdAccount: CachedAccount!
        
        var validConfiguration: Realm.Configuration!
        var invalidConfiguration: Realm.Configuration!
        
        beforeSuite {
            validConfiguration = Realm.Configuration(inMemoryIdentifier: "cached-account-dao-testing")
            
            let file = Bundle.module.url(forResource: "default", withExtension: "realm")
            invalidConfiguration = Realm.Configuration(fileURL: file?.absoluteURL, readOnly: true, schemaVersion: 1)
        }
        
        beforeEach {
            firstAccount = CachedAccount.testAccount()
            secondAccount = CachedAccount.testAccount()
            thirdAccount = CachedAccount.testAccount()
        }
        
        afterEach {
            if let accountDatabase = accountDatabase {
                autoreleasepool {
                    do {
                        try CatchRealmException.catch {
                            try! accountDatabase.write {
                                accountDatabase.deleteAll()
                            }
                        }
                    } catch { }
                }
            }
        }
        
        describe("Find Account by Uid") {

            beforeEach {
                Realm.Configuration.defaultConfiguration = validConfiguration
                accountDatabase = try? Realm()
                accountDao = AccountDaoImpl()
            }

            context("Found") {
                it("Account is returned") {
                    try? accountDatabase.write {
                        accountDatabase.add([firstAccount, secondAccount, thirdAccount])
                        try? accountDatabase.commitWrite()
                    }

                    expect { try accountDao.findAccount(byUid: firstAccount.uid).waitingCompletion().first }.to(equal(firstAccount))
                }
            }

            context("Not Found") {
                it("Error is thrown") {
                    try? accountDatabase.write {
                        accountDatabase.add([secondAccount, thirdAccount])
                        try? accountDatabase.commitWrite()
                    }

                    expect { try accountDao.findAccount(byUid: firstAccount.uid).waitingCompletion().first }.to(throwError())
                }
            }
        }

        describe("Find all Accounts") {
            beforeEach {
                Realm.Configuration.defaultConfiguration = validConfiguration
                accountDatabase = try? Realm()
                accountDao = AccountDaoImpl()
            }

            context("Found") {
                it("All Accounts are returned") {
                    try? accountDatabase.write {
                        accountDatabase.add([firstAccount, secondAccount, thirdAccount])
                        try? accountDatabase.commitWrite()
                    }

                    expect { try accountDao.findAllAccounts().waitingCompletion().first }.to(equal([firstAccount, secondAccount, thirdAccount]))
                }
            }

            context("Database Empty") {
                it("Error is thrown") {
                    expect { try accountDao.findAllAccounts().waitingCompletion().first }.to(throwError())
                }
            }
        }

        describe("Delete Account") {
            beforeEach {
                Realm.Configuration.defaultConfiguration = validConfiguration
                accountDatabase = try? Realm()
                accountDao = AccountDaoImpl()
            }

            context("Found") {
                it("Return deletion succeeded") {
                    try? accountDatabase.write {
                        accountDatabase.add([firstAccount, secondAccount, thirdAccount])
                        try? accountDatabase.commitWrite()
                    }

                    expect { try accountDao.delete(byUid: firstAccount.uid).waitingCompletion().first }.to(beVoid())

                    expect { try accountDao.findAllAccounts().waitingCompletion().first }.toNot(contain(firstAccount))
                }
            }

            context("Not Found") {
                it("Error is thrown") {
                    try? accountDatabase.write {
                        accountDatabase.add([secondAccount, thirdAccount])
                        try? accountDatabase.commitWrite()
                    }

                    expect {
                        try accountDao.delete(byUid: firstAccount.uid).waitingCompletion()
                    }.to(throwError())
                }
            }
        }
        
        describe("Save Accounts") {
            context("Saved") {
                
                it("Return save succeeded") {
                    Realm.Configuration.defaultConfiguration = validConfiguration
                    accountDatabase = try? Realm()
                    accountDao = AccountDaoImpl()
                    
                    expect { try accountDao.save(accounts: [firstAccount, secondAccount, thirdAccount]).waitingCompletion().first }.to(beVoid())
                    
                    expect { try Realm().objects(CachedAccount.self).toArray()}.to(equal([firstAccount, secondAccount, thirdAccount]))
                }
            }
            
            context("Invalid configuration") {
                
                it("Error is thrown") {
                    Realm.Configuration.defaultConfiguration = invalidConfiguration
                    accountDatabase = try? Realm()
                    accountDao = AccountDaoImpl()
                    
                    expect { try accountDao.save(accounts: [firstAccount, secondAccount, thirdAccount]).waitingCompletion() }.to(throwError())
                }
            }
        }
        
        describe("Save Account") {
            context("Saved") {

                it("Return save succeeded") {
                    Realm.Configuration.defaultConfiguration = validConfiguration
                    accountDatabase = try? Realm()
                    accountDao = AccountDaoImpl()

                    expect { try accountDao.saveOrUpdate(account: firstAccount).waitingCompletion().first }.to(beVoid())

                    expect { accountDatabase.objects(CachedAccount.self).toArray() }.to(equal([firstAccount]))
                }
            }

            context("Invalid configuration") {
                it("Error is thrown") {
                    Realm.Configuration.defaultConfiguration = invalidConfiguration
                    accountDatabase = try? Realm()
                    accountDao = AccountDaoImpl()

                    expect { try accountDao.saveOrUpdate(account: firstAccount).waitingCompletion() }.to(throwError())
                }
            }
        }
    }
}

extension CachedAccount {
    
    static func testAccount() -> CachedAccount {
        return CachedAccount(uid: DataFactory.randomString(),
                             providerID: DataFactory.randomString(),
                             email: DataFactory.randomString(),
                             displayName: DataFactory.randomString(),
                             phoneNumber: DataFactory.randomString(),
                             photo: nil,
                             favourites: CachedFavourite.testFavourite())
    }
}
