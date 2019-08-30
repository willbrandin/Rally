//
//  RallyMatchController.swift
//  Rally
//
//  Created by Will Brandin on 8/1/19.
//  Copyright © 2019 Will Brandin. All rights reserved.
//

import Foundation
import Combine

/// Initialized with settings. Provides all game logic.
public class RallyMatchController: ObservableObject {
    
    // MARK: - Properties
    
    @Published public var teamOneScore: Int = 0 {
        didSet {
            if determineWin(for: .one) {
                self.winningTeam = .one
            }
            
            determineServingTeam()
        }
    }

    @Published public var teamTwoScore: Int = 0 {
        didSet {
            if determineWin(for: .two) {
                self.winningTeam = .two
            }
            
            determineServingTeam()
        }
    }
    
    /// True when a team has won
    @Published public var teamDidWin: Bool = false
    
    /// True when a RallyTeam has GamePoint - a single point left to win the game.
    @Published public var teamHasGamePoint: Bool = false
    
    /// RallyTeam that is currently serving
    @Published public var servingTeam: RallyTeam = .one
    
    /// RallyTeam that has won
    @Published public internal(set) var winningTeam: RallyTeam? = nil {
        didSet {
            teamDidWin = winningTeam != nil
            print("RallyMatchController: - Team \(String(describing: winningTeam)) did win.")
        }
    }
    
    deinit {
        print("RallyMatchController: - Deinit")
    }
    
    private var settings: RallyMatchConfigurable!
    
    // MARK: - Initializer
    
    public init(settings: RallyMatchConfigurable) {
        self.settings = settings
        print("RallyMatchController: - Init")
    }
    
    public func setNewGame() {
        teamOneScore = 0
        teamTwoScore = 0
        servingTeam = .one
        teamDidWin = false
        teamHasGamePoint = false
        winningTeam = nil
        print("RallyMatchController: - New Game Set")
    }
        
    // MARK: - Internal Methods
    
    internal func incrementScore(for team: RallyTeam) {
        switch team {
        case .one: teamOneScore += 1
        case .two: teamTwoScore += 1
        }
    }
    
    /// If combination of team scores are divisible by serve interval, toggle serves.
    /// If winByTwo, the team with the disadvantage will serve until they gain advantage.
    internal func determineServingTeam() {
        self.servingTeam = determineServingTeam(with: settings, current: servingTeam, score: (teamOne: teamOneScore, teamTwo: teamTwoScore))
    }
    
    internal func determineWin(for team: RallyTeam) -> Bool {
        let teamScore: Int = team == .one ? teamOneScore : teamTwoScore
        let opposingTeamScore: Int = team != .one ? teamOneScore : teamTwoScore
        
        if settings.winByTwo {
            if teamScore == settings.limit && (opposingTeamScore <= (settings.limit - 2)) {
                return true
            } else if teamScore > settings.limit && opposingTeamScore == (teamScore - 2) { // if teamScore is above the limit, if the opposing team score is == 2 - teamScore then team score has won.
                return true
            }
            
            return false
        } else {
            return teamScore == settings.limit
        }
    }
    
    internal func determineServingTeam(with gameSettings: RallyMatchConfigurable, current servingTeam: RallyTeam, score: (teamOne: Int, teamTwo: Int)) -> RallyTeam {
        let teamOneGamePoint = hasGamePoint(for: score.teamOne, against: score.teamTwo, with: gameSettings)
        let teamTwoGamePoint = hasGamePoint(for: score.teamTwo, against: score.teamOne, with: gameSettings)

        teamHasGamePoint = teamOneGamePoint || teamTwoGamePoint
        
        // If the scores both equal Game Point do nothing.
        if score.teamOne == gameSettings.limit - 1 && score.teamTwo == gameSettings.limit - 1 {
            return servingTeam
        }
        
        // If team one has game point
        if teamOneGamePoint {
            return servingTeam == .one ? .two : servingTeam
        }
        
        // If team two has game point
        if teamTwoGamePoint {
            return servingTeam == .one ? servingTeam : .one
        }
        
        // If scores are above or equal to the limit and neither have game point, return the current serving team.
        if score.teamOne >= gameSettings.limit && score.teamTwo >= gameSettings.limit && !teamOneGamePoint && !teamTwoGamePoint {
            return servingTeam
        }
        
        // If the scores added up are equally divisible by the serve interval, swap.
        if (score.teamOne + score.teamTwo) % gameSettings.serveInterval == 0 {
            return servingTeam.toggle()
        }
    
        return servingTeam
    }
    
    // MARK: - Private Methods
    
    private func hasGamePoint(for score: Int, against opponent: Int, with settings: RallyMatchConfigurable) -> Bool {
        let teamHasSinglePointToScore = score >= settings.limit - 1
        let opponentHasSinglePointToScore = opponent >= settings.limit - 1

        if teamHasSinglePointToScore && !opponentHasSinglePointToScore {
            return true
        } else if score >= settings.limit && opponent >= settings.limit - 1 && settings.winByTwo {
            // Only way a team can have higher that limit is win by two.
            return teamHasSinglePointToScore && opponent == (score - 1)
        } else {
            return false
        }
    }
}
