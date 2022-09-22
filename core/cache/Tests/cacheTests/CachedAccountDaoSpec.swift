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

@testable import cache

class CachedAccountDaoSpec: QuickSpec {
    
    override func spec() {
        var accountDatabase: Realm!
        var cachedAccountDao: CachedAccountDao!
        
        var firstAccount: CachedAccount!
        var secondAccount: CachedAccount!
        var thirdAccount: CachedAccount!
        
        beforeEach {
            let configuration = Realm.Configuration(inMemoryIdentifier: "cached-account-dao-testing")
            Realm.Configuration.defaultConfiguration = configuration
            accountDatabase = try? Realm()
            cachedAccountDao = CachedAccountDaoImpl()
            
            firstAccount = CachedAccount.testAccount()
            secondAccount = CachedAccount.testAccount()
            thirdAccount = CachedAccount.testAccount()
        }
        
        afterEach {
            try? accountDatabase.write {
                accountDatabase.deleteAll()
                try? accountDatabase.commitWrite()
            }
        }
        
        describe("Find Account by Uuid") {
            context("Found") {
                it("Account is returned") {
                    try? accountDatabase.write {
                        accountDatabase.add([firstAccount, secondAccount, thirdAccount])
                        try? accountDatabase.commitWrite()
                    }
                    
                    expect { try cachedAccountDao.findAccount(byUuid: firstAccount.uuid).waitingCompletion().first }.to(equal(firstAccount))
                }
            }
            
            context("Not Found") {
                it("Error is thrown") {
                    try? accountDatabase.write {
                        accountDatabase.add([secondAccount, thirdAccount])
                        try? accountDatabase.commitWrite()
                    }
                    
                    expect { try cachedAccountDao.findAccount(byUuid: firstAccount.uuid).waitingCompletion().first }.to(throwError())
                }
            }
        }
        
        describe("Find all Accounts") {
            context("Found") {
                it("All Accounts are returned") {
                    try? accountDatabase.write {
                        accountDatabase.add([firstAccount, secondAccount, thirdAccount])
                        try? accountDatabase.commitWrite()
                    }
                    
                    expect { try cachedAccountDao.findAllAccounts().waitingCompletion().first }.to(equal([firstAccount, secondAccount, thirdAccount]))
                }
            }
            
            context("Database Empty") {
                it("Error is thrown") {
                    expect { try cachedAccountDao.findAllAccounts().waitingCompletion().first }.to(throwError())
                }
            }
        }
        
        describe("Delete Account") {
            context("Found") {
                it("Return deletion succeeded") {
                    try? accountDatabase.write {
                        accountDatabase.add([firstAccount, secondAccount, thirdAccount])
                        try? accountDatabase.commitWrite()
                    }
                    
                    cachedAccountDao.delete(byUuid: firstAccount.uuid)
                    
                    expect { try cachedAccountDao.findAllAccounts().waitingCompletion().first }.toNot(contain(firstAccount))
                }
            }
            
            context("Not Found") {
                it("Error is thrown") {
                    try? accountDatabase.write {
                        accountDatabase.add([secondAccount, thirdAccount])
                        try? accountDatabase.commitWrite()
                    }
                    
                    expect {
                        try cachedAccountDao.delete(byUuid: firstAccount.uuid).waitingCompletion()
                    }.to(throwError())
                }
            }
        }
        
        describe("Save Accounts") {
            context("Saved") {
                it("Return save succeeded") {
                    cachedAccountDao.save(accounts: [firstAccount, secondAccount, thirdAccount])
                    
                    expect { accountDatabase.objects(CachedAccount.self).toArray() }.to(equal([firstAccount, secondAccount, thirdAccount]))
                }
            }
        }
        
        describe("Save Account") {
            context("Saved") {
                it("Return save succeeded") {
                    cachedAccountDao.saveOrUpdate(account: firstAccount)
                    
                    expect { accountDatabase.objects(CachedAccount.self).toArray() }.to(equal([firstAccount]))
                }
            }
        }
    }
}

extension CachedAccount {
    
    static func testAccount() -> CachedAccount {
        return CachedAccount(uuid: UUID(),
                             providerId: DataFactory.randomString(),
                             email: DataFactory.randomString(),
                             displayName: DataFactory.randomString(),
                             phoneNumber: DataFactory.randomString(),
                             photo: nil,
                             favourites: CachedFavourite.testFavourite())
    }
}
