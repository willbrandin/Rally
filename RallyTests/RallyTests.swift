//
//  RallyTests.swift
//  RallyTests
//
//  Created by Will Brandin on 8/1/19.
//  Copyright © 2019 Will Brandin. All rights reserved.
//

import XCTest
@testable import Rally

class Settings: RallyMatchConfigurable {
    var limit: Int = 11
    var winByTwo: Bool = true
    var serveInterval: Int = 2
}

class RallyTests: XCTestCase {
    
    static let matchSettings = Settings()
    var matchController = RallyMatchController(settings: RallyTests.matchSettings)

    func testScore() {
        matchController.incrementScore(for: .one)
        XCTAssert(matchController.teamOneScore == 1)
    }
    
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
    
    func testTeamToggle() {
        var team = RallyTeam.one
        team = team.toggle()
        XCTAssert(team == .two)
        
        team = team.toggle()
        XCTAssert(team == .one)
    }
    
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
