//
//  Model.swift
//  Widgets
//
//  Created by Sergio on 09/08/22.
//

import Foundation

typealias Cities = [City]

struct City: Codable {
    let name, temperature, precipitation: String
}

