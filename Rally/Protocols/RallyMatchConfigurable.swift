//
//  RallyMatchConfigurable.swift
//  Rally
//
//  Created by Will Brandin on 8/3/19.
//  Copyright © 2019 Will Brandin. All rights reserved.
//

import Foundation

public protocol RallyMatchConfigurable {
    var limit: Int { get }
    var winByTwo: Bool { get }
    var serveInterval: Int { get }
}
