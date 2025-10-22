//
//  TranslationView.swift
//  OCR Playground
//
//  Created by Andrei Maksimovich on 09/10/2025.
//

import SwiftUI

struct TranslationView: View {
    
    @Environment(AppState.self) private var appState
    @Environment(AppCore.self) private var appCore
    
    @State private var model = TranslationViewModel()
    
    var body: some View {
        
        GeometryReader { geometry in
            
            ScrollView {
                
                // Languages
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
                
                
                // Source text
                VStack {
                    HStack {
                        Spacer()
                        Button("Common.ButtonCopy.Label") {
                            model.onButtonClick_SourceTextCopy()
                        }
                        Button("Common.ButtonPase.Label") {
                            model.onButtonClick_SourceTextPaste()
                        }
                    }
                    
                    TextEditor(text: model.sourceTextBinding)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .frame(minHeight: 100, idealHeight: geometry.size.height * 0.3)
                        .shadow(radius: 5)
                }
                .padding(.leading, 10)
                .padding(.trailing, 10)
                .padding(.top, 10)
                
                
                
                // Source text
                VStack {
                    HStack {
                        Spacer()
                        Button("Common.ButtonCopy.Label") {
                            model.onButtonClick_TargetTextCopy()
                        }
                    }
                    TextEditor(text: model.targetTextBinding)
                        .disabled(true)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .frame(minHeight: 100, idealHeight: geometry.size.height * 0.3)
                        .shadow(radius: 5)
                }
                .padding(.leading, 10)
                .padding(.trailing, 10)
                .padding(.top, 10)
            }
        }
        .onAppear {
            model.setup(appState: appState, appCore: appCore)
        }
        .onDisappear {
            model.onDisappear()
        }
        .onChange(of: appState.sourceLanguage) {
            model.updateTranslationService()
        }
        .onChange(of: appState.targetLanguage) {
            model.updateTranslationService()
        }
    }
}

#Preview {
    TranslationView()
}
