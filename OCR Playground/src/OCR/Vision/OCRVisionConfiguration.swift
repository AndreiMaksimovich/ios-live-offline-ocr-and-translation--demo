//
//  OCRLibraryConfigurationMLKit.swift
//  OCR Playground
//
//  Created by Andrei Maksimovich on 09/10/2025.
//

import MLKit

struct OCRVisionConfiguration: OCRConfiguration {
    
    let recognitionLanguages: [String]?

    init (recognitionLanguages: [String]? = nil) {
        self.recognitionLanguages = recognitionLanguages
    }
    
    static var latin: OCRVisionConfiguration {
        .init()
    }
    
    static var cyrillic: OCRVisionConfiguration {
        .init()
    }
    
}
