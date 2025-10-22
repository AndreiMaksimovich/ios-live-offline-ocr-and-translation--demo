//
//  CameraActor.swift
//  OCR Playground
//
//  Created by Andrei Maksimovich on 13/10/2025.
//


class CameraLock {
    
    private(set) var isLocked: Bool = false
    private(set) var lockOwner: AnyObject? = nil
    
    func lock(owner: AnyObject) -> Bool {
        guard !isLocked else { return false }
        
        lockOwner = owner
        isLocked = true
        
        return true
    }
    
    @discardableResult
    func unlock(owner: AnyObject) -> Bool {
        guard lockOwner != nil, lockOwner! === owner, isLocked else { return false }
        
        lockOwner = nil
        isLocked = false
        
        return true
    }
    
}
