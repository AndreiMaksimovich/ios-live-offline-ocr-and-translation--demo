//
//  CameraError.swift
//  OCR Playground
//
//  Created by Andrei Maksimovich on 06/10/2025.
//

enum CameraError: Error {
    case notAuthorized
    case videoDeviceUnavailable
    case audioDeviceUnavailable
    case addInputFailed
    case addOutputFailed
    case setupFailed
    case deviceChangeFailed
}
