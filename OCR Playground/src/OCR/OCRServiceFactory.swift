//
//  OCRServiceFactory.swift
//  OCR Playground
//
//  Created by Andrei Maksimovich on 13/10/2025.
//

import Foundation

class OCRServiceFactory : IOCRServiceFactory {
    
    private let distpatchQueue: DispatchQueue
    
    init(distpatchQueue: DispatchQueue) {
        self.distpatchQueue = distpatchQueue
    }
    
    func instantiateOCRServiceInstance(sourceLanguage: Language, ocrLibrary: OCRLibrary) -> any IOCRService {
        let config = sourceLanguage.suppportedOCRLibraries[ocrLibrary]!
        return switch ocrLibrary {
            case .mlkit:
                OCRServiceMLKit(config: config as! OCRMLKitConfiguration)
            case .tesseract:
                OCRServiceTesseract(
                    config: config as! OCRTesseractConfiguration,
                    dispatchQueue: distpatchQueue
                )
            case .vision:
                OCRServiceVision(
                    config: config as! OCRVisionConfiguration
                )
        }
    }
    
}
