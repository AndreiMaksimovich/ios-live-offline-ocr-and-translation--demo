//
//  Types.Simple.swift
//  OCR Playground
//
//  Created by Andrei Maksimovich on 06/10/2025.
//

import Foundation

class BaseElement : IBaseElement {
    
    let text: String
    let sourceText: String?
    let boundingBox: CGRect
    let confidence: Double?
    let recognizedLanguage: String?
    
    init(text: String, boundingBox: CGRect, confidence: Double?, recognizedLanguage: String?, sourceText: String? = nil) {
        self.text = text
        self.boundingBox = boundingBox
        self.confidence = confidence
        self.recognizedLanguage = recognizedLanguage
        self.sourceText = sourceText
    }
    
}

class Symbol : BaseElement { }

class Word : BaseElement, IWord {
    let symbols: [any ISymbol]?
    
    init(text: String, boundingBox: CGRect, confidence: Double?, recognizedLanguage: String?, symbols: [any ISymbol]?, sourceText: String? = nil) {
        self.symbols = symbols
        super.init(text: text, boundingBox: boundingBox, confidence: confidence, recognizedLanguage: recognizedLanguage, sourceText: sourceText)
    }
}

class Line : BaseElement, ILine {
    let words: [any IWord]?
    
    init(text: String, boundingBox: CGRect, confidence: Double?, recognizedLanguage: String?, words: [any IWord]?, sourceText: String? = nil) {
        self.words = words
        super.init(text: text, boundingBox: boundingBox, confidence: confidence, recognizedLanguage: recognizedLanguage, sourceText: sourceText)
    }
}

class Block : BaseElement, IBlock {
    let lines: [any ILine]?
    
    init(text: String, boundingBox: CGRect, confidence: Double?, recognizedLanguage: String?, lines: [any ILine]?, sourceText: String? = nil) {
        self.lines = lines
        super.init(text: text, boundingBox: boundingBox, confidence: confidence, recognizedLanguage: recognizedLanguage, sourceText: sourceText)
    }
}

class OCRResult : IOCRResult {
    let text: String
    let sourceText: String?
    let blocks: [any IBlock]
    let isEmpty: Bool
    
    init(text: String, blocks: [any IBlock], sourceText: String? = nil) {
        self.text = text
        self.sourceText = sourceText
        self.blocks = blocks
        self.isEmpty = blocks.isEmpty
    }
    
    static var empty: IOCRResult {
        OCRResult(text: "", blocks: [])
    }
}
