//
//  AppCore.swift
//  OCR Playground
//
//  Created by Andrei Maksimovich on 09/10/2025.
//

import Foundation

@Observable
class AppCore {
    
    private(set) var cameraManager: ICameraManager
    private(set) var imageCaptureServiceFactory: IImageCaptureServiceFactory
    private(set) var translationServiceFactory: ITranslationServiceFactory
    private(set) var ocrServiceFactory: IOCRServiceFactory
    private(set) var barcodeScannerService: IBarcodeScannerService
    
    init(cameraManager: ICameraManager, imageCaptureServiceFactory: IImageCaptureServiceFactory, translationServiceFactory: ITranslationServiceFactory, ocrServiceFactory: IOCRServiceFactory, barcodeScannerService: IBarcodeScannerService) {
        self.cameraManager = cameraManager
        self.imageCaptureServiceFactory = imageCaptureServiceFactory
        self.translationServiceFactory = translationServiceFactory
        self.ocrServiceFactory = ocrServiceFactory
        self.barcodeScannerService = barcodeScannerService
    }
    
    static var production: AppCore {
        let dispatchQueue: DispatchQueue = .init(label: "AppCoreServicesDispatchQueue", qos: .default)
        let cameraManager = CameraManager(dispatchQueue: dispatchQueue)
        let imageCaptureServiceFactory = ImageCaptureServiceFactoryCamera(cameraManager: cameraManager)
        let translationServiceFactory = TranslationServiceFactory()
        let ocrServiceFactory = OCRServiceFactory(distpatchQueue: dispatchQueue)
        let barcodeScannerService = BarcodeScannerService()
        return AppCore(cameraManager: cameraManager, imageCaptureServiceFactory: imageCaptureServiceFactory, translationServiceFactory: translationServiceFactory, ocrServiceFactory: ocrServiceFactory, barcodeScannerService: barcodeScannerService)
    }
    
    static var preview: AppCore {
        production //TODO 
    }
}
