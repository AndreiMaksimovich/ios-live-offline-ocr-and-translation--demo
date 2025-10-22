//
//  Styles.swift
//  OCR Playground
//
//  Created by Andrei Maksimovich on 09/10/2025.
//

import SwiftUI

struct ErrorMessageModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(.red)
    }
}
