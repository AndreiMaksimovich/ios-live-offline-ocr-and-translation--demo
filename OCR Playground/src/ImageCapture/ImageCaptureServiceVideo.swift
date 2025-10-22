//
//  ImageCaptureServiceVideo.swift
//  OCR Playground
//
//  Created by Andrei Maksimovich on 10/10/2025.
//

import AVFoundation
import SwiftUI

class ImageCaptureServiceVideo: NSObject, IImageCaptureService, ICameraClient, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    private let LogTag = "[ImageCaptureServiceVideo]"
    
    private var cameraManager: ICameraManager
    private var captureSession: AVCaptureSession?
    private var continuation: CheckedContinuation<CMSampleBuffer, Error>?
    
    private let ciContext = CIContext()
    
    init(cameraManager: ICameraManager) {
        self.cameraManager = cameraManager
    }
    
    func captureImage() async throws -> UIImage {
        defer { self.continuation = nil }
        
        let result = try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<CMSampleBuffer, Error>) in
            self.continuation = continuation
        }
        
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(result) else { throw ImageCaptureError.videoBufferToImageConversionFailed }
        let ciImage = CIImage(cvPixelBuffer: pixelBuffer)
        guard let cgImage = ciContext.createCGImage(ciImage, from: ciImage.extent) else { throw ImageCaptureError.videoBufferToImageConversionFailed }
        let uiImage = UIImage(cgImage: cgImage)
        
        return uiImage
    }
        
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let continuation = continuation else { return }
        continuation.resume(returning: sampleBuffer)
        self.continuation = nil
    }
    
    func initialize() throws {
        captureSession = try cameraManager.addClient(self)
        _output.setSampleBufferDelegate(self, queue: DispatchQueue.global())
    }
    
    func recycle() {
        cameraManager.removeClient(self)
    }
    
    func onReady(_ captureSession: AVCaptureSession) {}
    
    func onDeviceRotationChaged(contentRotationDeg: CGFloat, previewRotationDeg: CGFloat) {
        output?.connection(with: .video)?.videoRotationAngle = contentRotationDeg
    }
    
    func onError(_ error: any Error) {
        print(LogTag, "onError", error)
    }
    
    private let _output = AVCaptureVideoDataOutput()
    var output: AVCaptureOutput? { _output }
    var name: String = "ImageCaptureServiceVideo"
}
