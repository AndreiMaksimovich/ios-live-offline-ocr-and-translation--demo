//
//  InitializationScreenViewModel.swift
//  OCR Playground
//
//  Created by Andrei Maksimovich on 09/10/2025.
//

import SwiftUI
import AVFoundation
import MLKitTranslate

@Observable
class AppInitializationViewModel {
    
    private(set) var state: State = .unknown
    private(set) var log: [String] = [" >> Initialization:"]
    private(set) var error: Error?
    private(set) var cameraAuthorizationStatus: AVAuthorizationStatus = .notDetermined
    private var appState: AppState?
    
    init() { }
    
    func setup(_ appState: AppState) {
        self.appState = appState
    }
    
    func initialize() {
        guard state != .initializationInProgress else { return }
        
        if (state != .unknown) {
            logAppendLine("- - - - - - - - -")
        }
        
        state = .initializationInProgress
        
        Task.init {
            await initializationProcess()
        }
    }
    
    private func logAppendLine(_ message: String) {
        log = log + [message]
    }
    
    private func logReplaceLastLine(_ message: String) {
        guard !log.isEmpty else {
            logAppendLine(message)
            return
        }
        
        log = log.dropLast(1) + [message]
    }
    
    func initializationProcess() async {
        cameraAuthorizationStatus = await CameraAuthorizationUtils.authorize(for: .video)
        
        // Camera authorization
        guard cameraAuthorizationStatus == .authorized else {
            state = .cameraAccessDenied
            return
        }
        
        do {
            let downloadedModels = ModelManager.modelManager().downloadedTranslateModels
        
            
            for language in SupportedLanguages.shared.languages.values {
                if downloadedModels.contains(where: { $0.language == language.translateLanguage }) {
                    continue
                }
                
                logAppendLine("Downloading \(language.name) translation model")
                
                let languageModel = TranslateRemoteModel.translateRemoteModel(language: language.translateLanguage)
                let progress = ModelManager.modelManager().download(
                    languageModel,
                    conditions: ModelDownloadConditions(
                        allowsCellularAccess: true,
                        allowsBackgroundDownloading: true
                    )
                )
                
                let startTime = Date()
                
                while !progress.isFinished {
                    try await Task.sleep(for: .microseconds(100))
                    let duration = Date().timeIntervalSince(startTime)
                    
                    let message = "Downloading \(language.nameEnglish) translation model: \((duration * 10).rounded()/10.0)"
                    debugPrint(message)
                    logReplaceLastLine(message)
                }
                
                if (!ModelManager.modelManager().isModelDownloaded(languageModel)) {
                    throw InitializationError.translationModelDownloadFailed
                }
            }
         
            state = .initializationCompleted
            onInitialized()
        } catch (let error) {
            state = .initializationError
            self.error = error
        }
    }
    
    func onInitialized() {
        appState!.onInitialized()
    }
    
    enum State {
        case unknown
        case initializationInProgress
        case initializationCompleted
        case initializationError
        case cameraAccessDenied
    }
    
    enum InitializationError: Error {
        case translationModelDownloadFailed
    }

}
