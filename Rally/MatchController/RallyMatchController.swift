//
//  RallyMatchController.swift
//  Rally
//
//  Created by Will Brandin on 8/1/19.
//  Copyright © 2019 Will Brandin. All rights reserved.
//

import Foundation
import SwiftUI

public enum RallyTeam {
    case one
    case two
    
    func toggle() -> RallyTeam {
        return self == .one ? .two : .one
    }
}

public protocol RallyMatchConfigurable {
    var limit: Int { get }
    var winByTwo: Bool { get }
    var serveInterval: Int { get }
}

/// What would a controller need?
/// Teams? How would this be provided? If I was to say increment for .teamOne?
/// Settings: - Win by two, max score, how would other racket sports respond.
public class RallyMatchController {
    
    // MARK: - Public Properties
    
    public weak var delegate: RallyMatchControllerDelegate?
    
    // MARK: - Protected Properties
        
    public internal(set) var teamOneScore: Int = 0 {
        didSet {
            if determineWin(for: .one) {
                delegate?.teamDidWin(.one)
            }
        }
    }

    public internal(set) var teamTwoScore: Int = 0 {
        didSet {
            if determineWin(for: .two) {
                delegate?.teamDidWin(.two)
            }
        }
    }
    
    public internal(set) var servingTeam: RallyTeam = .one {
        didSet {
            delegate?.teamWillServe(servingTeam)
        }
    }
    
    private var settings: RallyMatchConfigurable!
    
    // MARK: - Initializer
    
    public init(settings: RallyMatchConfigurable) {
        self.settings = settings
    }
    
    // MARK: - Public Methods
    
    public func incrementScore(for team: RallyTeam) {
        switch team {
        case .one: teamOneScore += 1
        case .two: teamTwoScore += 1
        }
        
        determineServingTeam()
    }
    
    // MARK: - Methods
    
    /// If combination of team scores are divisible by serve interval, toggle serves.
    /// If winByTwo, the team with the disadvantage will serve until they gain advantage.
    ///
    func determineServingTeam() {
        if teamOneScore >= settings.limit || teamTwoScore >= settings.limit {
            // One score is over the limit.
            let winningTeam: RallyTeam = teamOneScore > teamTwoScore ? .one : .two
            
            if servingTeam == winningTeam && teamOneScore != teamTwoScore { // Change server to the losing team, but not when tied. 
                servingTeam = servingTeam.toggle()
            }
        } else if (teamOneScore + teamTwoScore) % settings.serveInterval == 0 {
            servingTeam = servingTeam.toggle()
        }
    }
    
    internal func determineWin(for team: RallyTeam) -> Bool {
        let teamScore: Int = team == .one ? teamOneScore : teamTwoScore
        let opposingTeamScore: Int = team != .one ? teamOneScore : teamTwoScore
        
        if settings.winByTwo {
            if teamScore == settings.limit && (opposingTeamScore <= (settings.limit - 2)) {
                return true
            } else if teamScore > settings.limit && opposingTeamScore == (teamScore - 2) { // if teamScore is above the limit, if the opposing team score is == 2 - teamScore then team score has won.
                return true
            } else {
                return false
            }
        } else {
            if teamScore == settings.limit {
                return true
            } else {
                return false
            }
        }
    }
    
    // MARK: - Private Methods
}

public protocol RallyMatchControllerDelegate: class {
    func teamDidWin(_ team: RallyTeam)
    func teamWillServe(_ team: RallyTeam)
}
