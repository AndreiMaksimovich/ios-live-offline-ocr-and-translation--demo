//
//  OCRServiceVision.swift
//  OCR Playground
//
//  Created by Andrei Maksimovich on 13/10/2025.
//

import Foundation
import SwiftUI
import Vision
import VisionKit

class OCRServiceVision : IOCRService {
    
    private let recognitionLanguages: [String]?

    init(config: OCRVisionConfiguration) {
        self.recognitionLanguages = config.recognitionLanguages
    }
    
    func run(image: UIImage) async throws -> any IOCRResult {
        
        guard let cgImage = image.cgImage else { throw OCRError.general(message: "Failed to convert UIImage to CGImage") }
        
        let requestHandler = VNImageRequestHandler(cgImage: cgImage)
        
        let observations = try await withCheckedThrowingContinuation {(continuation: CheckedContinuation<[VNObservation]?, any Error>) in
            let request = VNRecognizeTextRequest { request, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume(returning: request.results)
                }
            }
            
            if let recognitionLanguages = recognitionLanguages {
                request.recognitionLanguages = recognitionLanguages
            }
            request.recognitionLevel = .accurate
            request.usesLanguageCorrection = true
            
            do {
                try requestHandler.perform([request])
            } catch (let error) {
                continuation.resume(throwing: error)
            }
        }
        
        return observationsToOCRResult(observations)
    }
    
    private func observationsToOCRResult(_ observations: [VNObservation]?) -> some IOCRResult {
        guard let observations = observations as? [VNRecognizedTextObservation] else { return OCRResult(text: "", blocks: []) }
        
        var blocks: [IBlock] = []
        var text = ""
        
        func visionBoundingBoxToRect(_ boundingBox: CGRect) -> CGRect {
            .init(x: boundingBox.minX, y: 1 - boundingBox.minY - boundingBox.height, width: boundingBox.width, height: boundingBox.height)
        }
        
        for observation in observations   {
            if let candidate = observation.topCandidates(1).first {
                
                let stringRange = candidate.string.startIndex..<candidate.string.endIndex
                let boxObservation = try? candidate.boundingBox(for: stringRange)
                let boundingBox = visionBoundingBoxToRect(boxObservation?.boundingBox ?? .zero)
                blocks.append(Block(
                    text: candidate.string,
                    boundingBox: boundingBox,
                    confidence: Double(candidate.confidence),
                    recognizedLanguage: nil,
                    lines: [
                        Line(text: candidate.string, boundingBox: boundingBox, confidence: Double(candidate.confidence), recognizedLanguage: nil, words: nil)
                    ]))
                text = text + "\(candidate.string)\r\n"
            }
        }
        
        return OCRResult(text: text, blocks: blocks)
    }
        
    func recycle() {

    }
}
