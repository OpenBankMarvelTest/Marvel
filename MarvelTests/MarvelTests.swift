//
//  MarvelTests.swift
//  MarvelTests
//
//  Created by MarvelDev on 14/05/2020.
//  Copyright © 2020 MarvelDev. All rights reserved.
//

import XCTest

@testable import Marvel

class MarvelTests: XCTestCase {
    
    let kTimeOut = 20.0

    func testCharactersList() throws {
        let expectation = XCTestExpectation(description: "CharactersList")
        CharactersServiceHandler().getCharacters { (response) in
            switch response {
                case .success(_):
                    expectation.fulfill()
                    break
                case .error(let error):
                    XCTFail("Get Characters failed: " + (error.message))
                    break
            }
        }
        wait(for: [expectation], timeout: kTimeOut)
    }
    
    func testCharactersListPagination() throws {
        let expectation = XCTestExpectation(description: "CharactersList")
        CharactersServiceHandler().getCharacters(offset: "20", limit: "40") { (response) in
            switch response {
                case .success(_):
                    expectation.fulfill()
                    break
                case .error(let error):
                    XCTFail("Get Characters failed: " + (error.message))
                    break
            }
        }
        wait(for: [expectation], timeout: kTimeOut)
    }

    func testCharacterDetail() throws {
        let expectation = XCTestExpectation(description: "CharacterDetail")
        CharactersServiceHandler().getDetailCharacter(characterId: "1011334") { (response) in
            switch response {
                case .success(_):
                    expectation.fulfill()
                    break
                case .error(let error):
                    XCTFail("Get Character Detail failed: " + (error.message))
                    break
            }
        }
        wait(for: [expectation], timeout: kTimeOut)
    }
    
    func testCharacterImage() throws {
        let expectation = XCTestExpectation(description: "CharacterImage")
        
        CharactersServiceHandler().getImageCharacter(url: "http://i.annihil.us/u/prod/marvel/i/mg/c/e0/535fecbbb9784.jpg") { (response) in
            switch response {
                case .success(_):
                    expectation.fulfill()
                    break
                case .error(let error):
                    XCTFail("Get Character Image failed: " + (error.message))
                    break
            }
        }
        wait(for: [expectation], timeout: kTimeOut)
    }
}
