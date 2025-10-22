//
//  IOCRServiceFactory.swift
//  OCR Playground
//
//  Created by Andrei Maksimovich on 15/10/2025.
//

protocol IOCRServiceFactory {
    func instantiateOCRServiceInstance(sourceLanguage: Language, ocrLibrary: OCRLibrary) -> IOCRService
}
