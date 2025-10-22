//
//  SupportedLanguages.swift
//  OCR Playground
//
//  Created by Andrei Maksimovich on 09/10/2025.
//

import MLKit

class SupportedLanguages {
    
    static let shared = SupportedLanguages()
    
    private static let _languages: [String : Language] = [
        
        // English
        "en" : .init(
            code: "en",
            translateLanguage: .english,
            nameEnglish: "English",
            name: "English",
            suppportedOCRLibraries: [
                .vision : OCRVisionConfiguration.latin,
                .mlkit : OCRMLKitConfiguration.latin,
                .tesseract : OCRTesseractConfiguration(language: "eng")
            ]),
        
        // Polish - Polski
        "pl" : .init(
            code: "pl",
            translateLanguage: .polish,
            nameEnglish: "Polish",
            name: "Polksi",
            suppportedOCRLibraries: [
                .vision : OCRVisionConfiguration.latin,
                .mlkit : OCRMLKitConfiguration.latin,
                .tesseract : OCRTesseractConfiguration(language: "pol")
            ]),
        
        // Belarusian - Беларускі
        "be" : .init(
            code: "be",
            translateLanguage: .belarusian,
            nameEnglish: "Belarusian",
            name: "Беларускі",
            suppportedOCRLibraries: [
                .tesseract : OCRTesseractConfiguration(language: "bel"),
                .vision : OCRVisionConfiguration(recognitionLanguages: ["be-BY", "uk-UA", "ru-RU"])
            ]),
        
        // Georgian - Khartuli (ქართული)
        "ka" : .init(
            code: "ka",
            translateLanguage: .georgian,
            nameEnglish: "Georgian",
            name: "ქართული",
            suppportedOCRLibraries: [
                .tesseract : OCRTesseractConfiguration(language: "kat"),
            ])
    ]
    
    var languages: [String : Language] {
        SupportedLanguages._languages
    }
    
    let languageArray: [Language]
        = Array(SupportedLanguages._languages.values.sorted(by: { $0.code.compare($1.code) == .orderedAscending }))
    
    let defaultLanguageCode: String = "en"
    var defaultLanguage: Language {
        languages[defaultLanguageCode]!
    }
    
    let defaultTranslationTargetLanguageCode = "pl"
    var defaultTranslationTargetLanguage: Language {
        languages[defaultTranslationTargetLanguageCode]!
    }
}
