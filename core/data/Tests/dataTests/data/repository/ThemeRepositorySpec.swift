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

@testable import data

class ThemeRepositorySpec: QuickSpec {
    
    override func spec() {
        
        var themeRepository: DefaultThemeRepository!
        var themeDao: ThemeDao!
        
        var firstTheme: Theme!
        var secondTheme: Theme!
        var thirdTheme: Theme!
        
        beforeEach {
            themeDao = TestThemeDao()
            themeRepository = DefaultThemeRepository(themeDao: themeDao)
            
            firstTheme = Theme.testTheme()
            secondTheme = Theme.testTheme()
            thirdTheme = Theme.testTheme()
        }
        
        describe("Find theme by idTheme") {
            context("Found") {
                it("Theme is returned") {
                    (themeDao as? TestThemeDao)?.themes.append(contentsOf: [firstTheme.asCached(), secondTheme.asCached(), thirdTheme.asCached()])
                    
                    expect { try themeRepository.findTheme(byIdTheme: firstTheme.idTheme).waitingCompletion().first }.to(equal(firstTheme))
                }
            }
            
            context("Not found") {
                it("Error is thrown") {
                    (themeDao as? TestThemeDao)?.themes.append(contentsOf:[secondTheme.asCached(), thirdTheme.asCached()])
                    
                    expect { try themeRepository.findTheme(byIdTheme: firstTheme.idTheme).waitingCompletion().first }.to(throwError())
                }
            }
        }
        
        describe("Find themes by name") {
            context("Found") {
                it("Themes are returned") {
                    secondTheme.name = firstTheme.name

                    (themeDao as? TestThemeDao)?.themes.append(contentsOf:[firstTheme.asCached(), secondTheme.asCached(), thirdTheme.asCached()])
                    
                    expect { try themeRepository.findThemes(byName: firstTheme.name).waitingCompletion().first }.to(equal([firstTheme, secondTheme]))
                }
            }
            
            context("Found themes with idRelatedThemes") {
                it("Themes are returned") {
                    firstTheme.idRelatedThemes = [secondTheme.idTheme]

                    (themeDao as? TestThemeDao)?.themes.append(contentsOf:[firstTheme.asCached(), secondTheme.asCached(), thirdTheme.asCached()])
                    
                    expect { try themeRepository.findThemes(byName: firstTheme.name).waitingCompletion().first }.to(equal([firstTheme, secondTheme]))
                }
            }
            
            context("Not found") {
                it("Error is thrown") {
                    secondTheme.name = firstTheme.name

                    (themeDao as? TestThemeDao)?.themes.append(contentsOf:[firstTheme.asCached(), secondTheme.asCached(), thirdTheme.asCached()])
                    
                    expect { try themeRepository.findThemes(byName: DataFactory.randomString()).waitingCompletion().first }.to(throwError())
                }
            }
        }
        
        describe("Find themes by idParent") {
            context("Found") {
                it("Themes are returned") {
                    firstTheme.themes = [secondTheme, thirdTheme]
                    
                    (themeDao as? TestThemeDao)?.themes.append(contentsOf:[firstTheme.asCached(), secondTheme.asCached(), thirdTheme.asCached()])
                    
                    expect { try themeRepository.findThemes(byIdParent: firstTheme.idTheme).waitingCompletion().first }.to(equal([secondTheme, thirdTheme]))
                }
            }
            
            context("Not found") {
                it("Error is thrown") {
                    (themeDao as? TestThemeDao)?.themes.append(contentsOf:[firstTheme.asCached(), secondTheme.asCached(), thirdTheme.asCached()])
                    
                    expect { try themeRepository.findThemes(byIdParent: DataFactory.randomInt()).waitingCompletion().first }.to(throwError())
                }
            }
        }
        
        describe("Find main Themes") {
            context("Found") {
                it("Main themes are returned") {
                    firstTheme.idParentTheme = nil
                    secondTheme.idParentTheme = nil

                    (themeDao as? TestThemeDao)?.themes.append(contentsOf:[firstTheme.asCached(), secondTheme.asCached(), thirdTheme.asCached()])
                    
                    expect { try themeRepository.findMainThemes().waitingCompletion().first }.to(equal([firstTheme, secondTheme]))
                }
            }
            
            context("Nout found") {
                it("Error is thrown") {
                    (themeDao as? TestThemeDao)?.themes.append(contentsOf:[firstTheme.asCached(), secondTheme.asCached(), thirdTheme.asCached()])
                    
                    expect { try themeRepository.findMainThemes().waitingCompletion().first }.to(throwError())
                }
            }
        }
        
        describe("Find all themes") {
            context("Found") {
                it("All Themes are returned") {
                    (themeDao as? TestThemeDao)?.themes.append(contentsOf:[firstTheme.asCached(), secondTheme.asCached(), thirdTheme.asCached()])
                    
                    expect { try themeRepository.findAllThemes().waitingCompletion().first }.to(equal([firstTheme, secondTheme, thirdTheme]))
                }
            }
            
            context("Database empty") {
                it("Error is thrown") {
                    expect { try themeRepository.findAllThemes().waitingCompletion().first }.to(throwError())
                }
            }
        }
    }
}
