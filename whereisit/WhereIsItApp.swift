//
//  whereisitApp.swift
//  whereisit
//
//  Created by Sauermann, Victor on 25.07.23.
//

import SwiftUI

@main
struct whereisitApp: App {
    var body: some Scene {
        WindowGroup {
            GameView().environmentObject(GameState())
                .preferredColorScheme(.light)
        }
    }
}
