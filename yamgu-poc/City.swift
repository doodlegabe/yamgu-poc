//
//  City.swift
//  yamgu-poc
//
//  Created by Gabriel Walsh on 1/7/19.
//  Copyright © 2019 Gabriel Walsh. All rights reserved.
//

import Foundation

struct City: Codable {
    var longitude: Double
    var lattitude: Double
    var code: Int
    var visual: String
    var name: String

    enum CodingKeys: String, CodingKey {
        case longitude = "Lng"
        case lattitude = "Lat"
        case code = "Code"
        case visual = "Visual"
        case name = "Name"
    }
}
