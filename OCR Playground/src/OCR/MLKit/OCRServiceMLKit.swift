//
//  MLKit.swift
//  OCR Playground
//
//  Created by Andrei Maksimovich on 09/10/2025.
//

import Foundation
import MLKit
import SwiftUI

class OCRServiceMLKit : IOCRService {
    
    private let recognizer: TextRecognizer
    
    init(config: OCRMLKitConfiguration) {
        recognizer = TextRecognizer.textRecognizer(options: config.options)
    }
    
    func run(image: UIImage) async throws -> any IOCRResult {
        let visionImage = VisionImage(image: image)
        visionImage.orientation = image.imageOrientation
        let mlkitText = try await withCheckedThrowingContinuation{(continuation: CheckedContinuation<MLKit.Text, Error>) in
                recognizer.process(visionImage) { result, error in
                    if let error = error {
                        continuation.resume(throwing: error)
                    } else {
                        continuation.resume(returning: result!)
                    }
                }
        }
        return mlKitTextToOCRResult(image: image, text: mlkitText)
    }
    
    private func mlKitTextToOCRResult(image: UIImage, text: MLKit.Text) -> some IOCRResult {
        
        let width = image.size.width
        let height = image.size.height
        
        func mlKitFrameToRect(_ frame: CGRect) -> CGRect {
            .init(x: frame.minX / width, y: frame.minY / height, width: frame.width / width, height: frame.height / height)
        }
        
        var blocks: [IBlock] = []
        for block in text.blocks {
            var lines: [ILine] = []
            for line in block.lines {
                var words: [IWord] = []
                for word in line.elements {
                    words.append(Word(text: word.text, boundingBox: mlKitFrameToRect(word.frame), confidence: nil, recognizedLanguage: nil, symbols: nil))
                }
                lines.append(Line(text: line.text, boundingBox: mlKitFrameToRect(line.frame), confidence: nil, recognizedLanguage: nil, words: words))
            }
            blocks.append(Block(text: block.text, boundingBox: mlKitFrameToRect(block.frame), confidence: nil, recognizedLanguage: nil, lines: lines))
        }
        return OCRResult(text: text.text, blocks: blocks)
    }
    
    func recycle() {

    }
}
