//
//  TranslationViewModel.swift
//  OCR Playground
//
//  Created by Andrei Maksimovich on 17/10/2025.
//

import Foundation
import SwiftUI

@Observable
class TranslationViewModel {
    
    private var appState: AppState?
    private var appCore: AppCore?
    private var translationService: ITranslationService?
    
    var sourceText: String = "" {
        didSet {
            translate()
        }
    }
    var sourceTextBinding: Binding<String> { .init(get: { self.sourceText }, set: { self.sourceText = $0 }) }
    
    var targetText: String = ""
    var targetTextBinding: Binding<String> { .init(get: { self.targetText }, set: { self.targetText = $0 }) }
    
    func setup(appState: AppState, appCore: AppCore) {
        self.appState = appState
        self.appCore = appCore
        updateTranslationService()
    }
    
    func updateTranslationService() {
        translationService?.recycle()
        translationService = appCore!.translationServiceFactory.instantiateTranslationServiceInstance(sourceLanguage: appState!.sourceLanguage, targetLanguage: appState!.targetLanguage)
        translate()
    }
    
    func onButtonClick_SourceTextCopy() {
        UIPasteboard.general.string = sourceText
    }
    
    func onButtonClick_SourceTextPaste() {
        sourceText = UIPasteboard.general.string ?? ""
    }
    
    func onButtonClick_TargetTextCopy() {
        UIPasteboard.general.string = targetText
    }
    
    func onDisappear() {
        translationService?.recycle()
    }
    
    func swapLanguages() {
        appState?.swapLanguages()
        sourceText = targetText
    }
    
    private var isTranslating: Bool = false
    private var isTrnaslationUpdateRequired: Bool = false
    
    private func translate() {
        guard !isTranslating else {
            isTrnaslationUpdateRequired = true
            return
        }
        
        let translationService = self.translationService!
        let value = sourceText
        
        Task {
            
            do {
                targetText = try await translationService.translate(text: value)
            } catch (let error) {
                debugPrint(error)
            }
            
            isTranslating = false
            
            if isTrnaslationUpdateRequired {
                isTrnaslationUpdateRequired = false
                DispatchQueue.main.async {
                    self.translate()
                }
            }
        }
    }
    
}
