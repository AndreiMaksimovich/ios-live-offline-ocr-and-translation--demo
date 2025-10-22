//
//  OCRResultView.swift
//  OCR Playground
//
//  Created by Andrei Maksimovich on 15/10/2025.
//

import SwiftUI
import MLKitBarcodeScanning

struct OCRResultView: View {
    
    private let LogTag = "[OCRResultView]"
    
    let ocrResult: IOCRResult?
    let imageSize: CGSize?
    let barcodes: [Barcode]?
    var confidenceThreshold: Double = 0.8

    var body: some View {
        return GeometryReader { geometry in
            if let ocrResult, let imageSize, let barcodes {
                Canvas { canvas, size in
                    let viewWidth = size.width
                    let viewHeight = size.height
                    
                    let imageWidth = imageSize.width
                    let imageHeight = imageSize.height
                    
                    let ratio = if (viewWidth > imageWidth || viewHeight > imageHeight)
                        // Scale down
                        {
                            max(imageWidth/viewWidth, imageHeight/viewHeight)
                        }
                        // Scale up
                        else {
                            min(viewWidth/imageWidth, viewHeight/imageHeight)
                        }
                    
                    let activeAreaWidth = imageWidth * ratio
                    let activeAreaHeight = imageHeight * ratio

                    canvas.translateBy(x: (viewWidth - activeAreaWidth)/2.0, y: (viewHeight - activeAreaHeight)/2.0)
                    
                    func drawElement(_ element: IBaseElement) {
                        if (element.confidence != nil && element.confidence! < confidenceThreshold) {
                            return
                        }
                                                
                        let rect = CGRect(
                            x: element.boundingBox.minX * imageWidth * ratio,
                            y: element.boundingBox.minY * imageHeight * ratio,
                            width: element.boundingBox.width * imageWidth * ratio,
                            height: element.boundingBox.height * imageHeight * ratio
                        )
                        
                        let path = Path(rect)
                        
                        canvas.fill(path, with: .color(Color.white.opacity(0.9)))
                        
                        let fontSize = bestFittingFontSize(text: element.text, targetRect: rect)
                        let text = Text(element.text)
                            .font(.system(size: fontSize, design: .monospaced))
                            
                        canvas.draw(text, in: rect)
                        canvas.stroke(path, with: .color(Color.blue), style: StrokeStyle(lineWidth: 1.0, lineCap: .round))
                    }
                    
                    for block in ocrResult.blocks {
                        if let lines = block.lines {
                            for line in lines {
                                drawElement(line)
                            }
                        } else {
                            drawElement(block)
                        }
                    }
                    
                    func drawBarcode(_ barcode: Barcode) {
                        let rect = CGRect(
                            x: barcode.frame.minX * ratio,
                            y: barcode.frame.minY * ratio,
                            width: barcode.frame.width * ratio,
                            height: barcode.frame.height * ratio
                        )
                        
                        let path = Path(rect)
                        
                        canvas.fill(path, with: .color(Color.gray.opacity(0.9)))
                        if let text = barcode.rawValue {
                            canvas.draw(
                                Text(text).font(.system(size: 12)),
                                at: .init(x: rect.midX, y: rect.midY),
                                anchor: .center)
                        }
                        canvas.stroke(path, with: .color(Color.blue), style: StrokeStyle(lineWidth: 1.0, lineCap: .round))
                    }
                    
                    for barcode in barcodes {
                        drawBarcode(barcode)
                    }
                }
            } else {
                EmptyView()
            }
        }
        
        
    }
    
    private func bestFittingFontSize(
        text: String,
        targetRect: CGRect
    ) -> CGFloat {
        //TODO: replace magic numbers
        return min (targetRect.height * 0.7, targetRect.width * 1.5 / CGFloat(text.count))
    }
}

#Preview {
    OCRResultView(
        ocrResult: OCRResult(text: "Hello World", blocks: [
            Block(
                text: "Hello World",
                boundingBox: .init(x: 50, y: 50, width: 250, height: 50),
                confidence: 1.0,
                recognizedLanguage: nil,
                lines: nil),
            ]),
        imageSize: .init(width: 1080.0, height: 1920.0),
        barcodes: []
    )
        .modifier(PreviewViewModifier())
}
