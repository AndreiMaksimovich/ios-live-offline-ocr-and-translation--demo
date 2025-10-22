//
//  OCRServiceTesseract.swift
//  OCR Playground
//
//  Created by Andrei Maksimovich on 13/10/2025.
//

import Foundation
import SwiftUI
import TesseractOCR

class OCRServiceTesseract : IOCRService {
    
    private let tesseract: G8Tesseract
    private let dispatchQueue: DispatchQueue
    
    init(config: OCRTesseractConfiguration, dispatchQueue: DispatchQueue) {
        tesseract = .init(language: config.language)!
        self.dispatchQueue = dispatchQueue
    }
    
    func run(image: UIImage) async throws -> any IOCRResult {
        let result = await withCheckedContinuation {(continuation: CheckedContinuation<IOCRResult?, Never>) in
            dispatchQueue.async {
                self.tesseract.image = image
                self.tesseract.engineMode = .tesseractOnly
                self.tesseract.pageSegmentationMode = .auto
                
                var result: IOCRResult? = nil
            
                if (self.tesseract.recognize()) {
                    if let array = self.tesseract.recognizedBlocks(by: .textline) as? [G8RecognizedBlock] {
                        var blocks: [IBlock] = []
                        array.forEach { block in
                            let text = block.text.trimmingCharacters(in: .whitespacesAndNewlines)
                            if !text.isEmpty {
                                blocks.append(
                                    Block(
                                        text: text,
                                        boundingBox: block.boundingBox,
                                        confidence: block.confidence,
                                        recognizedLanguage: nil,
                                        lines: [
                                            Line(text: text, boundingBox: block.boundingBox, confidence: block.confidence, recognizedLanguage: nil, words: nil)
                                        ]
                                     ))
                            }
                        }
                        result = OCRResult(text: self.tesseract.recognizedText ?? "", blocks: blocks)
                    }
                }
                
                continuation.resume(returning: result)
            }
        }
                
        return result ?? OCRResult.empty
    }
    

        
    func recycle() {
  
    }
}
