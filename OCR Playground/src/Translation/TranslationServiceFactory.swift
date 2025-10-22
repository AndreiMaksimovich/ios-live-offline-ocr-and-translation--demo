//
//  TranslationServiceFactory.swift
//  OCR Playground
//
//  Created by Andrei Maksimovich on 14/10/2025.
//

class TranslationServiceFactory: ITranslationServiceFactory {
    
    func instantiateTranslationServiceInstance(sourceLanguage: Language, targetLanguage: Language) -> any ITranslationService {
        TranslationServiceMLKit(
            sourceLanguage: sourceLanguage.translateLanguage,
            targetLanguage: targetLanguage.translateLanguage)
    }
    
}
