//
//  SettingsView.swift
//  OCR Playground
//
//  Created by Andrei Maksimovich on 09/10/2025.
//

import SwiftUI

struct SettingsView: View {
    
    @Environment(AppState.self) private var appState
    
    var body: some View {
        
        List {
            
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
            
        }
        
    }
}

#Preview {
    SettingsView()
}
