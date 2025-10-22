//
//  BarcodeScannerService.swift
//  OCR Playground
//
//  Created by Andrei Maksimovich on 21/10/2025.
//

import MLKit
import MLKitBarcodeScanning

class BarcodeScannerService: IService, IBarcodeScannerService {
    private let barcodeSanner: BarcodeScanner
    
    init() {
        barcodeSanner = BarcodeScanner.barcodeScanner()
    }
    
    func process(image: UIImage) async throws -> [Barcode] {
        let visionImage = VisionImage(image: image)
        visionImage.orientation = image.imageOrientation
        return try await barcodeSanner.process(visionImage)
    }
    
    func recycle() { }
}
