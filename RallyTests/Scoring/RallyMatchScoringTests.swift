//
//  RallyMatchScoringTests.swift
//  RallyTests
//
//  Created by Will Brandin on 8/19/19.
//  Copyright © 2019 Will Brandin. All rights reserved.
//

import XCTest
@testable import Rally

class RallyMatchScoringTests: XCTestCase {
    
    static let matchSettings = Standard_Settings()
    var matchController = RallyMatchController(settings: RallyTests.matchSettings)

    func testIncrementTeamOneScore() {
        matchController.incrementScore(for: .one)
        XCTAssert(matchController.teamOneScore == 1)
    }
    
    func testIncrementTeamTwoScore() {
        matchController.incrementScore(for: .two)
        XCTAssert(matchController.teamTwoScore == 1)
    }
}
