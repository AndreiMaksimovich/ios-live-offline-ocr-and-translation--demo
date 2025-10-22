//
//  InitializationScreenView.swift
//  OCR Playground
//
//  Created by Andrei Maksimovich on 09/10/2025.
//

import SwiftUI

struct AppInitializationView: View {
    
    @Environment(AppState.self) private var appState
    @State private var model: AppInitializationViewModel = .init()
    
    
    var body: some View {
        
        Group {
            switch (model.state) {
                case .unknown, .initializationInProgress: initializationProcessView
                case .cameraAccessDenied: cameraAccessDeniedView
                case .initializationError: initializationErrorView
                case .initializationCompleted: EmptyView()
            }
        }
        .onAppear {
            model.setup(appState)
            model.initialize()
        }
        
    }
    
    var initializationProcessView: some View {
        ZStack {
            List {
                ForEach(0..<model.log.count, id: \.self) {index in
                    Text(model.log[index])
                }
            }
            ProgressView()
        }
    }
    
    var initializationErrorView: some View {
        VStack {
            Spacer()
            Text("AppInitializationView.InitializationError.ErrorMessage")
                .modifier(ErrorMessageModifier())
            Button("AppInitializationView.InitializationError.TryAgainButton") {
                model.initialize()
            }
            Spacer()
        }
    }
    
    var cameraAccessDeniedView: some View {
        VStack {
            Spacer()
            Text("AppInitializationView.CameraAuthorizationFailed.ErrorMessage")
                .modifier(ErrorMessageModifier())
            Button("AppInitializationView.CameraAuthorizationFailed.OpenAppSettingsButton") {
                SystemUtils.openApplicationSettings()
            }
            Spacer()
        }
    }
}

#Preview {
    AppInitializationView()
        .modifier(PreviewViewModifier())
}
