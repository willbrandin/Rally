//
//  RallyTeamTests.swift
//  RallyTests
//
//  Created by Will Brandin on 8/19/19.
//  Copyright © 2019 Will Brandin. All rights reserved.
//

import XCTest
@testable import Rally

class RallyTeamTests: XCTestCase {
    
    func testTeamToggle() {
        var team = RallyTeam.one
        team = team.toggle()
        XCTAssert(team == .two)
        
        team = team.toggle()
        XCTAssert(team == .one)
    }
}
