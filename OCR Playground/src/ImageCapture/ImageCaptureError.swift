//
//  ImageCaptureError.swift
//  OCR Playground
//
//  Created by Andrei Maksimovich on 10/10/2025.
//

import Foundation

enum ImageCaptureError: LocalizedError {
    
    case videoBufferToImageConversionFailed
    
    var errorDescription: String? {
        switch (self) {
            case .videoBufferToImageConversionFailed: "Failed to convert video buffer to UIImage."
        }
    }
    
}
