//
//  IOCRService.swift
//  OCR Playground
//
//  Created by Andrei Maksimovich on 06/10/2025.
//

import Foundation
import SwiftUI

protocol IOCRService: IService, AnyObject {
    func run(image: UIImage) async throws -> IOCRResult
}
