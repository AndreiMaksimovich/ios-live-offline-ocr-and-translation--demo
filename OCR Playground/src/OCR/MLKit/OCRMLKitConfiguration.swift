//
//  OCRLibraryConfigurationMLKit.swift
//  OCR Playground
//
//  Created by Andrei Maksimovich on 09/10/2025.
//

import MLKit

struct OCRMLKitConfiguration: OCRConfiguration {
    let options: CommonTextRecognizerOptions
    
    static var latin: OCRMLKitConfiguration {
        .init(options: TextRecognizerOptions())
    }
}
