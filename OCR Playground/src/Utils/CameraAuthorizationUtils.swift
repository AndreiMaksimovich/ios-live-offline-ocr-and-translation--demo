//
//  CameraAuthorizationUtil.swift
//  OCR Playground
//
//  Created by Andrei Maksimovich on 06/10/2025.
//

import AVFoundation

@MainActor
class CameraAuthorizationUtils {
    
    static func authorize(for mediaType: AVMediaType) async -> AVAuthorizationStatus {
        let status = AVCaptureDevice.authorizationStatus(for: mediaType)
        if (status == .notDetermined) {
            await AVCaptureDevice.requestAccess(for: mediaType)
            return AVCaptureDevice.authorizationStatus(for: mediaType)
        }
        return status
    }
    
    static func authorize(for mediaTypes: [AVMediaType]) async -> AVAuthorizationStatus  {
        var status: AVAuthorizationStatus = .notDetermined
        for mediaType in mediaTypes {
            status = await authorize(for: mediaType)
            if (status != .authorized) {
                return status
            }
        }
        
        return status
    }
    
    static func getAuthorizationStatus(for mediaType: AVMediaType) -> AVAuthorizationStatus {
        return AVCaptureDevice.authorizationStatus(for: mediaType)
    }
    
    static func isAuthorized(for mediaType: AVMediaType) async -> Bool {
        return await authorize(for: mediaType) == .authorized
    }
}
