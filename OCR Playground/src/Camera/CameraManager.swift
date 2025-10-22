//
//  CameraManager.swift
//  OCR Playground
//
//  Created by Andrei Maksimovich on 07/10/2025.
//

import AVFoundation
import SwiftUI

class CameraManager: ICameraManager {
    
    let lock: CameraLock = .init()
    let dispatchQueue: DispatchQueue
    
    private let LOG_TAG = "[CameraManager]"
    
    private(set) var state: CameraManagerState = .stopped
    private(set) var error: Error?
    
    private(set) var captureSession: AVCaptureSession = .init()
    private var clients: [any ICameraClient] = []
    
    private let previewLayer = AVCaptureVideoPreviewLayer()
            
    init (dispatchQueue: DispatchQueue) {
        self.dispatchQueue = dispatchQueue
        
        NotificationCenter.default.addObserver(
            forName: UIDevice.orientationDidChangeNotification,
            object: nil, queue: .main
        ) { [weak self] _ in self?.applyRotationAngles() }
        
    }
    
    func addClient(_ client: any ICameraClient) throws -> AVCaptureSession {
        debugPrint(LOG_TAG, "Add client: \(client.name)")
        
        guard clients.contains(where: { $0 === client }) == false else {
            return captureSession
        }
        
        do {
            if state != .running {
                try start()
            }
            try addOutput(client)
            clients.append(client)
            applyRotationAngles()
            
            DispatchQueue.main.async {
                client.onReady(self.captureSession)
            }
        } catch (let error) {
            DispatchQueue.main.async {
                client.onError(error)
            }
            throw error
        }
        
        return captureSession
    }
    
    func removeClient(_ client: any ICameraClient) {
        debugPrint(LOG_TAG, "Remove client: \(client.name)")
        
        guard clients.contains(where: { $0 === client }) == true else {
            return
        }
        
        clients.removeAll(where: { $0 === client })
        removeOutput(client)
        
        if (clients.count == 0) {
            stop()
        }
    }
    
    private func removeOutput(_ client: any ICameraClient) {
        guard let output = client.output else {
            return
        }
        
        captureSession.beginConfiguration()
        captureSession.removeOutput(output)
        captureSession.commitConfiguration()
    }
    
    private func addOutput(_ client: any ICameraClient) throws {
        guard let output = client.output else {
            return
        }
                
        if (!captureSession.canAddOutput(output)) {
            throw CameraError.addOutputFailed
        }
        
        captureSession.beginConfiguration()
        captureSession.addOutput(output)
        captureSession.commitConfiguration()
    }
    
    
    private func start() throws {
        debugPrint(LOG_TAG, "Start")
        
        guard state != .running else {
            return
        }
                
        do {
            captureSession.beginConfiguration()
                        
            let camera = try CameraDeviceLookup.shared.defaultCamera
            let videoInput = try AVCaptureDeviceInput(device: camera)
            
            guard captureSession.canAddInput(videoInput) else {
                throw CameraError.addInputFailed
            }
            
            captureSession.addInput(videoInput)
            
            captureSession.sessionPreset = .high
            captureSession.commitConfiguration()
                        
            captureSession.startRunning()
            state = .running
        } catch (let error) {
            print(error)
            self.error = error
            state = .cameraInitializationFailed
            throw error
        }
    }
    
    private func stop() {
        debugPrint(LOG_TAG, "Stop()")
        
        captureSession.stopRunning()
        captureSession.inputs.forEach{ captureSession.removeInput($0) }
        captureSession.outputs.forEach{ captureSession.removeOutput($0) }
        
        state = .stopped
    }
        
    private func applyRotationAngles() {
        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene else  {
           return
        }
        
        let orientation = scene.interfaceOrientation
        
        let contentRotation: CGFloat = switch(orientation) {
            case .portrait: 90
            case .portraitUpsideDown: 270
            case .landscapeLeft: 180
            case .landscapeRight: 0
            default: 0
        }
        
        let previewRotation: CGFloat = switch(orientation) {
            case .portrait: 0
            case .portraitUpsideDown: 180
            case .landscapeLeft: 270
            case .landscapeRight: 90
            default: 0
        }
                            
        clients.forEach { $0.onDeviceRotationChaged(contentRotationDeg: contentRotation, previewRotationDeg: previewRotation) }
    }
    
}

enum CameraManagerState {
    case running
    case stopped
    case cameraInitializationFailed
}
