//
//  ContentView.swift
//  OCR Playground
//
//  Created by Andrei Maksimovich on 06/10/2025.
//

import SwiftUI
import AVFoundation

struct MainView: View {
    
    @State private var selectedTab: MainViewTab = .ocr
     
    var body: some View {
        
        VStack {
            
            NavigationStack {
                getTabView(selectedTab)
            }
            .transition(.slide)
            
            HStack (alignment: .bottom) {
                MainMenuTabItem(icon: "camera.on.rectangle", title: "MainView.Tab.OCR", id: .ocr, selectedTab: $selectedTab)
                MainMenuTabItem(icon: "translate", title: "MainView.Tab.Translation", id: .translation, selectedTab: $selectedTab)
                MainMenuTabItem(icon: "gearshape", title: "MainView.Tab.Settings", id: .settings, selectedTab: $selectedTab)
            }
            
        }
        .background(Color(UIColor.systemBackground))
    }
    
    @ViewBuilder
    private func getTabView(_ destination: MainViewTab) -> some View {
        switch destination {
            case .ocr: OCRView()
            case .translation: TranslationView()
            case .settings: SettingsView()
        }
    }
    
    struct MainMenuTabItem: View {
        let icon: String
        let title: String
        let id: MainViewTab
        let selectedTab: Binding<MainViewTab>
        
        var body: some View {
            Button {
                if id != selectedTab.wrappedValue {
                    selectedTab.wrappedValue = id
                }
            } label: {
                VStack(spacing: 5) {
                    // Icon
                    Image(systemName: icon)
                        .font(.system(size: 20))
                        .foregroundColor(selectedTab.wrappedValue == id ? AppTheme.activeTabButtonTintColor : AppTheme.tabButtonColor)
                    
                    // Title
                    Text(LocalizedStringKey(title))
                        .font(.caption)
                        .foregroundColor(selectedTab.wrappedValue == id ? AppTheme.activeTabButtonTintColor : AppTheme.tabButtonColor)
                        .multilineTextAlignment(.center)
               
                    // Bottom indicator
                    Rectangle()
                        .frame(height: 2)
                        .foregroundColor(selectedTab.wrappedValue == id ? AppTheme.activeTabButtonTintColor : AppTheme.tabButtonColor)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 1)
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
    
    enum MainViewTab: Int {
        case ocr = 1
        case translation = 2
        case settings = 3
    }

}

#Preview {
    MainView()
        .modifier(PreviewViewModifier())
}
