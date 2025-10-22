//
//  OCRViewModel.swift
//  OCR Playground
//
//  Created by Andrei Maksimovich on 09/10/2025.
//

import Foundation
import SwiftUI
import MLKit

@Observable
class OCRViewModel {
    
    private let LogTag = "[OCRViewModel]"
    
    private let ocrCycleDelay: Duration = .seconds(0.1)
    
    private(set) var state: State = .unknown
    private(set) var isCameraOwner: Bool = false
    
    private(set) var viewState: ViewState = .notInitialized
    
    private var _appCore: AppCore?
    private var appCore: AppCore {
        _appCore!
    }
    
    private var _appState: AppState?
    private var appState: AppState {
        _appState!
    }
    
    private(set) var ocrResult: IOCRResult? = nil
    private(set) var ocrResultSourceImageSize: CGSize? = nil
    private(set) var barcodeScanResult: [Barcode]? = nil
    
    private var videoFrameCaptureSerice: IImageCaptureService?
    private var photoCaptureService: IImageCaptureService?
    private var ocrCycleTask: Task<(), Never>?
    private var initializationTask: Task<Void, Never>?
    
    private var ocrService: IOCRService?
    private var translationService: ITranslationService?
    
    var ocrLibrary: OCRLibrary = .tesseract
    
    var ocrLibraryBinding: Binding<OCRLibrary> {
        Binding(get: { self.ocrLibrary }, set: { self.ocrLibrary = $0 })
    }
    
    func setup(appCore: AppCore, appState: AppState) {
        self._appCore = appCore
        self._appState = appState
        ocrLibrary = appState.sourceLanguage.suppportedOCRLibraries.first!.key
    }
    
    func onAppear() {
        viewState = .visible
        initializationTask = Task {
            await onAppearTask()
        }
    }
    
    func swapLanguages() {
        appState.swapLanguages()
    }
    
    func onSettingsChanged() {
        let sourceLanguage = appState.sourceLanguage
        let targetLanguage = appState.targetLanguage
        
        if !sourceLanguage.supports(ocrLibrary) {
            ocrLibrary = sourceLanguage.defaultOCRLibrary
        }
        
        ocrService?.recycle()
        ocrService = appCore.ocrServiceFactory.instantiateOCRServiceInstance(sourceLanguage: sourceLanguage, ocrLibrary: ocrLibrary)
        translationService?.recycle()
        translationService = appCore.translationServiceFactory.instantiateTranslationServiceInstance(
            sourceLanguage: sourceLanguage,
            targetLanguage: targetLanguage)
        
        ocrCycleTask?.cancel()
        
        run()
    }
    
    var translateOCRResult: Bool {
        appState.sourceLanguage.translateLanguage != appState.targetLanguage.translateLanguage
    }
    
    func onAppearTask() async {
        while (!Task.isCancelled && !appCore.cameraManager.lock.lock(owner: self)) {
            do { try await Task.sleep(for: .milliseconds(100)) } catch {}
        }
        
        guard !Task.isCancelled else { return }
        
        isCameraOwner = true
        
        appCore.cameraManager.dispatchQueue.async {
            self.intialize()
        }
    }
        
    func onDisappear() {
        initializationTask?.cancel()
        viewState = .discarded
        appCore.cameraManager.dispatchQueue.async {
            self.deintialize()
        }
    }
        
    private func intialize() {
        debugPrint(LogTag, "intialize()")
        guard viewState == .visible else { return }
        
        do {
            videoFrameCaptureSerice = _appCore!.imageCaptureServiceFactory.instantiateVideoFrameCaptureService()
            try videoFrameCaptureSerice?.initialize()
            
            photoCaptureService = _appCore!.imageCaptureServiceFactory.instantiatePhotoCaptureService()
            try photoCaptureService?.initialize()
            
            onSettingsChanged()
            state = .running
            run()
            
        } catch (let error) {
            debugPrint(LogTag, "intialize() error", error)
        }
    }
    
    private func deintialize() {
        debugPrint(LogTag, "deintialize()")
        
        ocrCycleTask?.cancel()

        guard isCameraOwner else { return }
        
        videoFrameCaptureSerice?.recycle()
        photoCaptureService?.recycle()
        
        Thread.sleep(forTimeInterval: 0.1)
        
        appCore.cameraManager.lock.unlock(owner: self)
    }
    
    private func run() {
        debugPrint(LogTag, "run()")
        
        guard state == .running else { return }
        
        let ocrService = ocrService!
        let videoFrameCaptureSerice = videoFrameCaptureSerice!
        let translationService = translationService!
        let barcodeScannerService = appCore.barcodeScannerService
        
        ocrCycleTask = Task {
            while (!Task.isCancelled) {
                
                do {
                    if (Task.isCancelled) { break }
                    let image = try await videoFrameCaptureSerice.captureImage()

                    if (Task.isCancelled) { break }
                    var ocrResult = try await ocrService.run(image: image)
                    
                    if (Task.isCancelled) { break }
                    if (translateOCRResult) {
                        ocrResult = try await OCRTranslator.shared.translate(ocrResult: ocrResult, translationService: translationService)
                    }
                    
                    if (Task.isCancelled) { break }
                    let barcodes = try await barcodeScannerService.process(image: image)
                    
                    if (Task.isCancelled) { break }
                    DispatchQueue.main.async {
                        self.ocrResult = ocrResult
                        self.ocrResultSourceImageSize = image.size
                        self.barcodeScanResult = barcodes
                    }
                    
                } catch (let error) {
                    debugPrint(LogTag, "ocrCycleTask error", error)
                }
             
                do {
                    try await Task.sleep(for: ocrCycleDelay)
                } catch (let error) {
                    debugPrint(LogTag, "ocrCycleTask sleep error", error)
                }
            }
        }
    }
    
    enum State {
        case unknown
        case notInitialized
        case running
        case initializationError
        case error
    }
    
    enum ViewState {
        case notInitialized
        case visible
        case discarded
    }
    
    enum Mode {
        case ocr
        case ocrWithTranslation
        case barcodeScanner
    }
    
}
