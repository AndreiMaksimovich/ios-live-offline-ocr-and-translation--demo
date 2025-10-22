//
//  ITranslationService.swift
//  OCR Playground
//
//  Created by Andrei Maksimovich on 14/10/2025.
//

protocol ITranslationService: IService {
    func translate(text: String) async throws -> String
}
