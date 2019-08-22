//
//  RallyMatchOverTests.swift
//  RallyTests
//
//  Created by Will Brandin on 8/19/19.
//  Copyright © 2019 Will Brandin. All rights reserved.
//

import XCTest
@testable import Rally

class RallyMatchOverTests: XCTestCase {
    
    static let matchSettings = Standard_Settings()
    var matchController = RallyMatchController(settings: RallyTests.matchSettings)

    func testTeamOne_NotWin() {
        matchController.incrementScore(for: .one)
        XCTAssertFalse(matchController.determineWin(for: .one))
    }
    
    func testTeamOne_Lose() {
        matchController.teamTwoScore = 10
        matchController.incrementScore(for: .two)
        XCTAssertFalse(matchController.determineWin(for: .one))
    }
    
    func testTeamTwo_NotWin() {
        matchController.incrementScore(for: .two)
        XCTAssertFalse(matchController.determineWin(for: .two))
    }
    
    func testTeamTwo_Lose() {
        matchController.teamOneScore = 10
        matchController.incrementScore(for: .one)
        XCTAssertFalse(matchController.determineWin(for: .two))
    }
    
    func testTeamOne_Win() {
        matchController.teamOneScore = 10
        
        matchController.incrementScore(for: .one)
        XCTAssert(matchController.determineWin(for: .one))
    }
    
    func testTeamOne_WinByTwo() {
        matchController.teamOneScore = 10
        matchController.teamTwoScore = 8
        
        matchController.incrementScore(for: .one)
        XCTAssert(matchController.determineWin(for: .one))
    }
    
    func testTeamOne_WinByTwo_OverLimit() {
        matchController.teamOneScore = 12
        matchController.teamTwoScore = 11
        
        matchController.incrementScore(for: .one)
        XCTAssert(matchController.determineWin(for: .one))
    }
    
    func testTeamTwo_Win() {
        matchController.teamTwoScore = 10
        
        matchController.incrementScore(for: .two)
        XCTAssert(matchController.determineWin(for: .two))
    }
    
    func testTeamOne_OverTake() {
        matchController.teamOneScore = 10
        matchController.teamTwoScore = 9
        
        matchController.incrementScore(for: .two) // 10- 10
        matchController.incrementScore(for: .two) // 10-11
        XCTAssert(matchController.servingTeam == .one)
    }
    
    func testTeamTwo_WinByTwo() {
        matchController.teamTwoScore = 10
        matchController.teamOneScore = 8
        
        matchController.incrementScore(for: .two)
        XCTAssert(matchController.determineWin(for: .two))
    }
    
    func testTeamTwo_WinByTwo_OverLimit() {
        matchController.teamTwoScore = 12
        matchController.teamOneScore = 11
        
        matchController.incrementScore(for: .two)
        XCTAssert(matchController.determineWin(for: .two))
    }
    
    func testNoWinner() {
        matchController.teamTwoScore = 21
        matchController.teamOneScore = 20
        
        XCTAssertFalse(matchController.determineWin(for: .two))
        XCTAssertFalse(matchController.determineWin(for: .one))
    }
    
    func testNewGame() {
        matchController.teamOneScore = 10
        matchController.teamTwoScore = 9
        
        matchController.incrementScore(for: .one)
        
        XCTAssert(matchController.determineWin(for: .one))

        matchController.setNewGame()
        XCTAssert(matchController.teamOneScore == 0)
        XCTAssert(matchController.teamTwoScore == 0)
        XCTAssert(matchController.servingTeam == .one)
        XCTAssertFalse(matchController.teamDidWin)
        XCTAssertFalse(matchController.teamHasGamePoint)
        XCTAssertNil(matchController.winningTeam)
    }
}
