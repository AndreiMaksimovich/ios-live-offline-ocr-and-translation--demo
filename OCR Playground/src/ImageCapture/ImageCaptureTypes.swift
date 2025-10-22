//
//  Types.swift
//  OCR Playground
//
//  Created by Andrei Maksimovich on 09/10/2025.
//

import SwiftUI

protocol IImageCaptureService: IService {
    
    func captureImage() async throws -> UIImage
    
    func initialize() throws
    
}

protocol IImageCaptureServiceFactory {
    
    func instantiateVideoFrameCaptureService() -> IImageCaptureService
    
    func instantiatePhotoCaptureService() -> IImageCaptureService
    
}
