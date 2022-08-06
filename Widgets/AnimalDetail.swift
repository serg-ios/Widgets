//
//  AnimalDetail.swift
//  Widgets
//
//  Created by Sergio on 06/08/22.
//

import Foundation

enum AnimalDetail: CaseIterable, Identifiable {
    case ladybug
    case dinosaur
    case pufferFish
    case fish
    case unicorn
    case lobster
    
    var id: String { self.emoji }
    
    var emoji: String {
        switch self {
        case .ladybug:
            return "🐞"
        case .dinosaur:
            return "🦕"
        case .pufferFish:
            return "🐡"
        case .fish:
            return "🐠"
        case .unicorn:
            return "🦄"
        case .lobster:
            return "🦞"
        }
    }

    var name: String {
        switch self {
        case .ladybug:
            return "Ladybug"
        case .dinosaur:
            return "Dinosaur"
        case .pufferFish:
            return "Puffer fish"
        case .fish:
            return "Cute fish"
        case .unicorn:
            return "Unicorn"
        case .lobster:
            return "Lobster"
        }
    }
    
    var age: Int {
        switch self {
        case .ladybug:
            return 1
        case .dinosaur:
            return 100
        case .pufferFish:
            return 2
        case .fish:
            return 3
        case .unicorn:
            return 999
        case .lobster:
            return 4
        }
    }
    
    var url: URL {
        switch self {
        case .ladybug:
            return URL(string: "animals:///ladybug")!
        case .dinosaur:
            return URL(string: "animals:///dinosaur")!
        case .pufferFish:
            return URL(string: "animals:///pufferfish")!
        case .fish:
            return URL(string: "animals:///fish")!
        case .unicorn:
            return URL(string: "animals:///unicorn")!
        case .lobster:
            return URL(string: "animals:///lobster")!
        }
    }
}
