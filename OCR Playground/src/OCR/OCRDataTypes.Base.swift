//
//  TypesBase.swift
//  OCR Playground
//
//  Created by Andrei Maksimovich on 06/10/2025.
//

import Foundation

protocol IBaseElement: Sendable {
    var text: String { get }
    var sourceText: String? { get }
    var boundingBox: CGRect { get }
    var confidence: Double? { get }
    var recognizedLanguage: String? { get }
}

protocol ISymbol: IBaseElement { }

protocol IWord : IBaseElement {
    var symbols: [ISymbol]? { get }
}

protocol ILine : IBaseElement {
    var words: [IWord]? { get }
}

protocol IBlock : IBaseElement {
    var lines: [ILine]? { get }
}

protocol IOCRResult: Sendable {
    var text: String { get }
    var sourceText: String? { get }
    var blocks: [IBlock] { get }
    var isEmpty: Bool { get }
}
