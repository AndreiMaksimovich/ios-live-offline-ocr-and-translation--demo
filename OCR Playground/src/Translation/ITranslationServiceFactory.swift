//
//  ITranslationServiceFactory.swift
//  OCR Playground
//
//  Created by Andrei Maksimovich on 14/10/2025.
//

protocol ITranslationServiceFactory {
    
    func instantiateTranslationServiceInstance(sourceLanguage: Language, targetLanguage: Language) -> ITranslationService
    
}
