//
//  Rover.swift
//  BeblueRovers
//
//  Created by Silvia Florido on 24/02/19.
//  Copyright © 2019 Silvia Florido. All rights reserved.
//

import Foundation

struct Rover {
    var id: String
    var name: String
    var totalPhotos: Double
    var cameras: [Camera]
}

enum MarsRovers: String {
    case Curiosity
    case Opportunity
    case Spirit
}
