//
//  OCRTranslator.swift
//  OCR Playground
//
//  Created by Andrei Maksimovich on 14/10/2025.
//

class OCRTranslator {
    
    static let shared: OCRTranslator = .init()
   
    func translate(ocrResult: IOCRResult, translationService: ITranslationService, elementsToTranslate: Set<TranslationLevel> = [.lines]) async throws -> IOCRResult {
        let translateBlocks = elementsToTranslate.contains(.blocks)
        let translateLines = elementsToTranslate.contains(.lines)
        let translateWords = elementsToTranslate.contains(.words)
        
        var translatedBlocks: [Block] = []
        for block in ocrResult.blocks {
            var translatedLines: [Line] = []
            if block.lines != nil {
                for line in block.lines! {
                    var translatedWords: [Word] = []
                    if translateWords && line.words != nil {
                        for word in line.words! {
                            translatedWords.append(
                                Word(
                                    text: try await translationService.translate(text: word.text),
                                    boundingBox: word.boundingBox,
                                    confidence: word.confidence,
                                    recognizedLanguage: word.recognizedLanguage,
                                    symbols: word.symbols,
                                    sourceText: word.text
                                ))
                        }
                    }
                    translatedLines.append(
                        Line(
                            text: translateLines ? try await translationService.translate(text: line.text) : line.text,
                            boundingBox: line.boundingBox,
                            confidence: line.confidence,
                            recognizedLanguage: line.recognizedLanguage,
                            words: translatedWords.count > 0 ? translatedWords : line.words,
                            sourceText: translateLines ? line.text : nil
                        ))
                }
            }
            translatedBlocks.append(
                Block(
                    text: translateBlocks ? try await translationService.translate(text: block.text) : block.text,
                    boundingBox: block.boundingBox,
                    confidence: block.confidence,
                    recognizedLanguage: block.recognizedLanguage,
                    lines: translatedLines.count > 0 ? translatedLines : block.lines,
                    sourceText: translateBlocks ? block.text : nil
                ))
        }
        
        return OCRResult(
            text: try await translationService.translate(text: ocrResult.text),
            blocks: translatedBlocks,
            sourceText: ocrResult.text
        )
    }
    
    enum TranslationLevel: Int {
        case blocks = 1
        case lines = 2
        case words = 3
    }
    
}
