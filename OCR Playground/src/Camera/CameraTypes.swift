//
//  Types.swift
//  OCR Playground
//
//  Created by Andrei Maksimovich on 07/10/2025.
//

import AVFoundation


protocol ICameraManager {
    @discardableResult func addClient(_ client: any ICameraClient) throws -> AVCaptureSession
    func removeClient(_ client: any ICameraClient)
    
    var state: CameraManagerState {get}
    var error: Error? {get}
    
    var lock: CameraLock { get }
    var dispatchQueue: DispatchQueue { get }
}

protocol ICameraClient: AnyObject {

    func onReady(_ captureSession: AVCaptureSession)
    func onError(_ error: Error)
    func onDeviceRotationChaged(contentRotationDeg: CGFloat, previewRotationDeg: CGFloat)
    
    var output: AVCaptureOutput? {get}
    var name: String {get}
}
