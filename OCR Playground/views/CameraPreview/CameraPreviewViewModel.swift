//
//  CameraPreviewViewModel.swift
//  OCR Playground
//
//  Created by Andrei Maksimovich on 09/10/2025.
//

import Foundation
import AVFoundation

@Observable
class CameraPreviewViewModel: ICameraClient {
    private let LogTag = "[CameraPreviewViewModel]"
    
    private(set) var captureSession: AVCaptureSession? = nil
    private(set) var state: State = .stopped
    private(set) var error: Error?
    private(set) var cameraManager: ICameraManager? = nil
    private(set) var rotation: CGFloat = 0.0
    
    var output: AVCaptureOutput? = nil
    var name: String = "CameraPreviewView"
    
    
    func setup(_ cameraManager: ICameraManager) {
        self.cameraManager = cameraManager
    }
    
    func onAppear() {
        cameraManager!.dispatchQueue.async {
            do {
                try self.cameraManager!.addClient(self)
            } catch (let error) {
                debugPrint(self.LogTag, "onAppear error", error)
            }
        }
    }
    
    func onDisapper() {
        state = .stopped
        captureSession = nil
        cameraManager!.dispatchQueue.async {
            self.cameraManager!.removeClient(self)
        }
    }
    
    @MainActor func onReady(_ captureSession: AVCaptureSession) {
        self.captureSession = captureSession
        self.state = .running
    }
    
    func onDeviceRotationChaged(contentRotationDeg: CGFloat, previewRotationDeg: CGFloat) {
        self.rotation = contentRotationDeg
    }
    
    @MainActor func onError(_ error: any Error) {
        self.error = error
        self.state = .error
    }
        
    enum State {
        case stopped
        case running
        case error
    }
}
