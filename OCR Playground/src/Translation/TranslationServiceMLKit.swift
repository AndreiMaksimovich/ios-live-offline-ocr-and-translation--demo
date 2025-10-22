//
//  TranslationServiceMLKit.swift
//  OCR Playground
//
//  Created by Andrei Maksimovich on 14/10/2025.
//

import MLKitTranslate

class TranslationServiceMLKit : ITranslationService {
    private let translator: Translator?
    
    init(sourceLanguage: TranslateLanguage, targetLanguage: TranslateLanguage) {
        guard sourceLanguage != targetLanguage else {
            self.translator = nil
            return
        }
        
        let options = TranslatorOptions(sourceLanguage: sourceLanguage, targetLanguage: targetLanguage)
        self.translator = Translator.translator(options: options)
    }
    
    
    func translate(text: String) async throws -> String {
        guard let translator = translator else {
            return text
        }
        
        return try await translator.translate(text)
    }
    
    func recycle() {
        
    }
}
