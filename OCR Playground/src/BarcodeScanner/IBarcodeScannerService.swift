//
//  IBarcodeScannerService.swift
//  OCR Playground
//
//  Created by Andrei Maksimovich on 21/10/2025.
//

import MLKitBarcodeScanning
import SwiftUI

protocol IBarcodeScannerService {
    
    func recycle()
    func process(image: UIImage) async throws -> [Barcode]
    
}
