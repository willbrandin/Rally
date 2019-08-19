//
//  RallyMatchServingTests.swift
//  RallyTests
//
//  Created by Will Brandin on 8/19/19.
//  Copyright © 2019 Will Brandin. All rights reserved.
//

import XCTest
@testable import Rally

class RallyMatchServingTests: XCTestCase {
    
    static let matchSettings = Standard_Settings()
    var matchController = RallyMatchController(settings: RallyTests.matchSettings)
    
    func testServingTeam() {
        matchController.incrementScore(for: .one)
        matchController.incrementScore(for: .two)
        XCTAssert(matchController.servingTeam == .two)
        
        matchController.incrementScore(for: .one)
        XCTAssertFalse(matchController.servingTeam == .one)
        
        matchController.incrementScore(for: .one)
        XCTAssert(matchController.servingTeam == .one)
    }
    
    func testServing_WithGamePoint() {
        matchController.teamOneScore = 9
        matchController.teamTwoScore = 0
        
        matchController.incrementScore(for: .one) // 10 - 0
        XCTAssert(matchController.servingTeam == .two)
        matchController.incrementScore(for: .two) // 10 - 1
        XCTAssert(matchController.servingTeam == .two)
        matchController.incrementScore(for: .two) // 10-2
        XCTAssert(matchController.servingTeam == .two) // Should still be serving due to score being low
    }
    
    func testServingPastLimit() {
        matchController.teamOneScore = 25
        matchController.teamTwoScore = 24
        
        matchController.determineServingTeam()
        
        XCTAssert(matchController.servingTeam == .two)
    }
}
