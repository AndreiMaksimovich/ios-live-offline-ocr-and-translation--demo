//
//  PreviewModifier.swift
//  OCR Playground
//
//  Created by Andrei Maksimovich on 09/10/2025.
//

import SwiftUI

struct PreviewViewModifier: ViewModifier {
    
    @State private var appState = AppState.preview
    @State private var appCore = AppCore.preview //TODO preview services & dummy data
    
    func body(content: Content) -> some View {
        content
            .environment(appState)
            .environment(appCore)
    }
}
