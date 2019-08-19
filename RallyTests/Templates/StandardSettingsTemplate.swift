//
//  StandardSettingsTemplate.swift
//  RallyTests
//
//  Created by Will Brandin on 8/19/19.
//  Copyright © 2019 Will Brandin. All rights reserved.
//

import Foundation
@testable import Rally

class Standard_Settings: RallyMatchConfigurable {
    var limit: Int = 11
    var winByTwo: Bool = true
    var serveInterval: Int = 2
}
