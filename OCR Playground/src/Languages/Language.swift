//
//  Language.swift
//  OCR Playground
//
//  Created by Andrei Maksimovich on 09/10/2025.
//

import MLKitTranslate

struct Language: Equatable, Identifiable, Hashable {
    var id: String {
        code
    }
    
    static func == (lhs: Language, rhs: Language) -> Bool {
        lhs.code == rhs.code
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(code)
    }
    
    func supports(_ library: OCRLibrary) -> Bool {
        suppportedOCRLibraries.keys.contains(library)
    }
    
    var defaultOCRLibrary: OCRLibrary {
        suppportedOCRLibraries.first!.key
    }
    
    let code: String
    let translateLanguage: TranslateLanguage
    let nameEnglish: String
    let name: String
    let suppportedOCRLibraries: [OCRLibrary : any OCRConfiguration]
}
