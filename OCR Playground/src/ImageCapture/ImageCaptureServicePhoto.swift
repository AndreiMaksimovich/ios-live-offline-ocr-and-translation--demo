//
//  ImageCaptureServiceCameraClient.swift
//  OCR Playground
//
//  Created by Andrei Maksimovich on 09/10/2025.
//

import AVFoundation
import SwiftUI

class ImageCaptureServicePhoto: NSObject, IImageCaptureService, ICameraClient, AVCapturePhotoCaptureDelegate {
    private let LogTag = "[ImageCaptureServicePhoto]"
    
    private var cameraManager: ICameraManager
    private var captureSession: AVCaptureSession?
    private var photoCaptureContinuation: CheckedContinuation<AVCapturePhoto, Error>?
    
    init(cameraManager: ICameraManager) {
        self.cameraManager = cameraManager
    }
            
    func captureImage() async throws -> UIImage {
        let settings = AVCapturePhotoSettings()
        
        defer { self.photoCaptureContinuation = nil }
        
        let result = try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<AVCapturePhoto, Error>) in
            self.photoCaptureContinuation = continuation
            _output.capturePhoto(with: settings, delegate: self)
        }
        
        return UIImage(data: result.fileDataRepresentation()!)!
    }
    
    func initialize() throws {
        captureSession = try cameraManager.addClient(self)
    }
    
    func recycle() {
        cameraManager.removeClient(self)
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let error = error {
            photoCaptureContinuation?.resume(throwing: error)
        } else {
            photoCaptureContinuation?.resume(returning: photo)
        }
    }
    
    func onReady(_ captureSession: AVCaptureSession) {}
    
    func onDeviceRotationChaged(contentRotationDeg: CGFloat, previewRotationDeg: CGFloat) {
        output?.connection(with: .video)?.videoRotationAngle = contentRotationDeg
    }
    
    func onError(_ error: any Error) {
        print(LogTag, "onError", error)
    }
    
    private let _output = AVCapturePhotoOutput()
    var output: AVCaptureOutput? { _output }
    var name: String = "ImageCaptureServicePhoto"
}
