//
//  AppState.swift
//  OCR Playground
//
//  Created by Andrei Maksimovich on 07/10/2025.
//

import Foundation
import SwiftUI
import AVFoundation

@Observable
class AppState {
    
    private let LogTag: String = "[AppState]"
        
    private(set) var isInitialized: Bool = false
    
    private(set) var sourceLanguage: Language = SupportedLanguages.shared.defaultLanguage
    private(set) var targetLanguage: Language = SupportedLanguages.shared.defaultTranslationTargetLanguage
    
    var sourceLanguageBinding: Binding<Language> { Binding(get: { self.sourceLanguage }, set: { self.setSourceLanguage($0) }) }
    var targetLanguageBinding: Binding<Language> { Binding(get: { self.targetLanguage }, set: { self.setTargetLanguage($0) }) }
    
    func swapLanguages() {
        (sourceLanguage, targetLanguage) = (targetLanguage, sourceLanguage)
    }
    
    func onInitialized() {
        debugPrint(LogTag, "onInitialized()")
        self.isInitialized = true
    }
    
    func setSourceLanguage(_ language: Language) {
        debugPrint(LogTag, "setSourceLanguage(\(language.name))")
        self.sourceLanguage = language
    }
    
    func setTargetLanguage(_ language: Language) {
        debugPrint(LogTag, "setTargetLanguage(\(language.name))")
        self.targetLanguage = language
    }
    
    static var production: AppState {
        return .init()
    }
    
    static var preview: AppState {
        production //TODO
    }
}
