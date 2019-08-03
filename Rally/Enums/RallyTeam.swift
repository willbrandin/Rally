//
//  RallyTeam.swift
//  Rally
//
//  Created by Will Brandin on 8/3/19.
//  Copyright © 2019 Will Brandin. All rights reserved.
//

import Foundation

public enum RallyTeam {
    case one
    case two
    
    func toggle() -> RallyTeam {
        return self == .one ? .two : .one
    }
}
