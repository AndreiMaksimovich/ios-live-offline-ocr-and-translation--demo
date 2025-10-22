//
//  CameraPreviewView.swift
//  OCR Playground
//
//  Created by Andrei Maksimovich on 07/10/2025.
//

import SwiftUI
import AVFoundation


struct CameraPreviewView: View {
    
    private let LogTag = "[CameraPreviewView]"
    
    let videoGravirty: AVLayerVideoGravity
    let cameraManager: ICameraManager
    
    @State private var model = CameraPreviewViewModel()
    
    init(videoGravirty: AVLayerVideoGravity = .resizeAspectFill, cameraManager: ICameraManager) {
        self.videoGravirty = videoGravirty
        self.cameraManager = cameraManager
    }
    
    var body: some View {
        Group {
            VStack {
                switch model.state {
                    case .stopped: ProgressView().progressViewStyle(.circular)
                    case .running: CameraPreview(session: model.captureSession!, videoGravity: videoGravirty, rotation: model.rotation)
                    case .error: Text("Error: \(model.error?.localizedDescription ?? "Unknown error.)")").modifier(ErrorMessageModifier()) //TODO
                }
            }
        }
        .onAppear {
            print(LogTag, "onAppear")
            model.setup(cameraManager)
            model.onAppear()
        }
        .onDisappear {
            print(LogTag, "onDisappear")
            model.onDisapper()
        }
    }
    
    struct CameraPreview: UIViewRepresentable {
        let session: AVCaptureSession
        let videoGravirty: AVLayerVideoGravity
        let rotation: CGFloat
        
        init(session: AVCaptureSession, videoGravity: AVLayerVideoGravity = .resizeAspectFill, rotation: CGFloat = 0) {
            self.session = session
            self.videoGravirty = videoGravity
            self.rotation = rotation
        }

        func makeUIView(context: Context) -> CameraPreviewLayerView {
            let view = CameraPreviewLayerView()
            
            view.videoPreviewLayer.videoGravity = videoGravirty
            view.videoPreviewLayer.session = session
            
            setRotation(view)
            
            return view
        }

        public func updateUIView(_ uiView: CameraPreviewLayerView, context: Context) {
            setRotation(uiView)
        }
        
        private func setRotation(_ uiView: CameraPreviewLayerView) {
            if (uiView.videoPreviewLayer.connection?.isVideoRotationAngleSupported(rotation) ?? false) {
                uiView.videoPreviewLayer.connection!.videoRotationAngle = rotation
            }
        }
    }
    
    class CameraPreviewLayerView: UIView {
        override class var layerClass: AnyClass {
            return AVCaptureVideoPreviewLayer.self
        }
        
        var videoPreviewLayer: AVCaptureVideoPreviewLayer {
            return layer as! AVCaptureVideoPreviewLayer
        }
    }
    
}
