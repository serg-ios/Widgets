//
//  ContentView.swift
//  Widgets
//
//  Created by Sergio on 05/08/22.
//

import SwiftUI

struct ContentView: View {
    @State var text: String
    
    var body: some View {
        Text(text)
            .font(.largeTitle)
            .onOpenURL(perform: { url in
                switch url {
                case AnimalDetail.unicorn.url:
                    text = AnimalDetail.unicorn.emoji
                case AnimalDetail.fish.url:
                    text = AnimalDetail.fish.emoji
                case AnimalDetail.pufferFish.url:
                    text = AnimalDetail.pufferFish.emoji
                case AnimalDetail.lobster.url:
                    text = AnimalDetail.lobster.emoji
                case AnimalDetail.dinosaur.url:
                    text = AnimalDetail.dinosaur.emoji
                case AnimalDetail.ladybug.url:
                    text = AnimalDetail.ladybug.emoji
                default:
                    fatalError("Animal not supported.")
                }
            })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(text: AnimalDetail.unicorn.emoji)
    }
}
