//
//  CameraDeviceLookup.swift
//  OCR Playground
//
//  Created by Andrei Maksimovich on 07/10/2025.
//

import AVFoundation
import Combine

final class CameraDeviceLookup {
    
    static var shared: CameraDeviceLookup = .init()
    
    let backCameraDiscoverySession: AVCaptureDevice.DiscoverySession
    let backCameras: [AVCaptureDevice]
    
    init() {
        backCameraDiscoverySession = AVCaptureDevice.DiscoverySession(
            deviceTypes: [.builtInDualCamera, .builtInWideAngleCamera],
            mediaType: .video,
            position: .back)
        
        backCameras = backCameraDiscoverySession.devices
        
        if AVCaptureDevice.systemPreferredCamera == nil {
            AVCaptureDevice.userPreferredCamera = backCameraDiscoverySession.devices.first
        }
    }
    
    var defaultBackCamera: AVCaptureDevice {
        get throws {
            guard let device = backCameras.first else {
                throw CameraError.videoDeviceUnavailable
            }
            return device
        }
    }
    
    var defaultCamera: AVCaptureDevice {
        get throws {
            guard let videoDevice = AVCaptureDevice.systemPreferredCamera else {
                throw CameraError.videoDeviceUnavailable
            }
            return videoDevice
        }
    }
}
