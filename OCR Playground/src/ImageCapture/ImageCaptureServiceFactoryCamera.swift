//
//  ImageCaptureServiceCameraClientFactory.swift
//  OCR Playground
//
//  Created by Andrei Maksimovich on 10/10/2025.
//

class ImageCaptureServiceFactoryCamera: IImageCaptureServiceFactory {
    
    private let cameraManager: ICameraManager
    
    init (cameraManager: ICameraManager) {
        self.cameraManager = cameraManager
    }
    
    func instantiateVideoFrameCaptureService() -> any IImageCaptureService {
        ImageCaptureServiceVideo(cameraManager: cameraManager)
    }
    
    func instantiatePhotoCaptureService() -> any IImageCaptureService {
        ImageCaptureServicePhoto(cameraManager: cameraManager)
    }
    
}
