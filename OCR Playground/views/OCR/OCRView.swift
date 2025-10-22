//
//  OCRView.swift
//  OCR Playground
//
//  Created by Andrei Maksimovich on 09/10/2025.
//

import AVFoundation
import SwiftUI

struct OCRView: View {

    private let LogTag = "[OCRView]"

    @Environment(AppCore.self) private var appCore
    @Environment(AppState.self) private var appState

    @State private var model = OCRViewModel()

    var body: some View {
        let sourceLanguage = appState.sourceLanguage

        VStack {
            if model.isCameraOwner {

                ZStack {

                    CameraPreviewView(
                        videoGravirty: .resizeAspect,
                        cameraManager: appCore.cameraManager
                    )
                    
                    OCRResultView(
                        ocrResult: model.ocrResult,
                        imageSize: model.ocrResultSourceImageSize,
                        barcodes: model.barcodeScanResult,
                        confidenceThreshold: 0)

                    GeometryReader { geometry in
                        VStack {

                            VStack {

                                HStack {
                                    Picker(
                                        "Common.SourceLanguagePicker.Title",
                                        selection: appState.sourceLanguageBinding
                                    ) {
                                        ForEach(
                                            SupportedLanguages.shared
                                                .languageArray
                                        ) { language in
                                            Text(
                                                "\(language.nameEnglish)(\(language.code))"
                                            ).tag(language)
                                        }
                                    }
                                    .frame(width: geometry.size.width * 0.4)
                                    Spacer()
                                    Button {
                                        model.swapLanguages()
                                    } label: {
                                        Image(systemName: "arrow.forward")
                                            .frame(width: 24, height: 24)
                                    }
                                    Spacer()
                                    Picker(
                                        "Common.TargetLanguagePicker.Title",
                                        selection: appState.targetLanguageBinding
                                    ) {
                                        ForEach(
                                            SupportedLanguages.shared
                                                .languageArray
                                        ) { language in
                                            Text(
                                                "\(language.nameEnglish)(\(language.code))"
                                            ).tag(language)
                                        }
                                    }
                                    .frame(width: geometry.size.width * 0.4)
                                }
                            }

                            HStack {
                                Spacer()
                                Picker(
                                    "OCRView.ModelPicker.Title",
                                    selection: model.ocrLibraryBinding
                                ) {
                                    if sourceLanguage.supports(.mlkit) {
                                        Text("MLKit")
                                            .tag(OCRLibrary.mlkit)
                                    }

                                    if sourceLanguage.supports(.tesseract) {
                                        Text("Tesseract")
                                            .tag(OCRLibrary.tesseract)
                                    }

                                    if sourceLanguage.supports(.vision) {
                                        Text("Vision")
                                            .tag(OCRLibrary.vision)
                                    }
                                }
                                .pickerStyle(.segmented)
                                Spacer()
                            }
                            .padding(.bottom, 10)

                        }
                        .background(BackgroundStyle().secondary.opacity(0.85))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .padding(10)

                        Spacer()
                    }

                }

            } else {
                ProgressView().progressViewStyle(.circular)
            }
        }
        .onAppear {
            debugPrint(LogTag, "onAppear()")
            model.setup(appCore: appCore, appState: appState)
            model.onAppear()
        }
        .onDisappear {
            debugPrint(LogTag, "onDisappear()")
            model.onDisappear()
        }
        .onChange(of: appState.sourceLanguage) {
            model.onSettingsChanged()
        }
        .onChange(of: appState.targetLanguage) {
            model.onSettingsChanged()
        }
        .onChange(of: model.ocrLibrary) {
            model.onSettingsChanged()
        }
    }
}

#Preview {
    OCRView()
}
