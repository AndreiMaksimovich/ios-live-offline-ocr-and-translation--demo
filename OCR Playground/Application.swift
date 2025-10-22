//
//  OCR_PlaygroundApp.swift
//  OCR Playground
//
//  Created by Andrei Maksimovich on 06/10/2025.
//

import SwiftUI

@main
struct Application: App {
    
    @State private var appState: AppState = AppState.production
    @State private var appCore: AppCore = AppCore.production
    
    var body: some Scene {
        
        return WindowGroup {
            Group {
                if (appState.isInitialized) {
                    MainView()
                } else {
                    AppInitializationView()
                }
            }
            .colorScheme(.light)
        }
        .environment(appState)
        .environment(appCore)
        
    }
    
}
