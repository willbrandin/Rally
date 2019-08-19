//
//  RallyTests.swift
//  RallyTests
//
//  Created by Will Brandin on 8/1/19.
//  Copyright © 2019 Will Brandin. All rights reserved.
//

import XCTest
@testable import Rally

class RallyTests: XCTestCase {
    
    static let matchSettings = Standard_Settings()
    var matchController = RallyMatchController(settings: RallyTests.matchSettings)
    
    // FULL MATCH TEST
    func testServing_WithPastLimit() {
        matchController.incrementScore(for: .one)
        matchController.incrementScore(for: .two)
        XCTAssert(matchController.servingTeam == .two)
        
        matchController.incrementScore(for: .one)
        matchController.incrementScore(for: .two)
        XCTAssert(matchController.servingTeam == .one) // 2-2
        
        matchController.incrementScore(for: .one)
        matchController.incrementScore(for: .two)
        XCTAssert(matchController.servingTeam == .two)
        
        matchController.incrementScore(for: .one)
        matchController.incrementScore(for: .two)
        XCTAssert(matchController.servingTeam == .one) // 4-4
        
        matchController.incrementScore(for: .one)
        matchController.incrementScore(for: .two)
        XCTAssert(matchController.servingTeam == .two)
        
        matchController.incrementScore(for: .one)
        matchController.incrementScore(for: .two)
        XCTAssert(matchController.servingTeam == .one) // 6-6
        
        matchController.incrementScore(for: .one)
        matchController.incrementScore(for: .two)
        XCTAssert(matchController.servingTeam == .two)
        
        matchController.incrementScore(for: .one)
        matchController.incrementScore(for: .two)
        XCTAssert(matchController.servingTeam == .one) // 8-8
        
        matchController.incrementScore(for: .one)
        matchController.incrementScore(for: .two)
        XCTAssert(matchController.servingTeam == .two) // 9-9
        
        matchController.incrementScore(for: .one) // 10 - 9 two score
        matchController.incrementScore(for: .two) // 10-10 two
        XCTAssert(matchController.servingTeam == .two) // 10-10
        
        matchController.incrementScore(for: .one) // 11-10 Team Two should serve
        XCTAssert(matchController.servingTeam == .two)
        
        matchController.incrementScore(for: .two) // 11-11 TeamTwo should still serve
        XCTAssert(matchController.servingTeam == .two)

        matchController.incrementScore(for: .two) // 11-12 Team one should serve
        XCTAssert(matchController.servingTeam == .one)
        
        matchController.incrementScore(for: .two) // 11-13 Team two wins
        XCTAssert(matchController.determineWin(for: .two))
    }
}
