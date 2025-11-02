//
//  HandGestureDetector.swift
//  SpatialGPTBuilder
//
//  Created by Steinhauer, Jan on 02.11.25.
//

import SwiftUI
import AudioToolbox

enum GestureSound {
    static let diamond: SystemSoundID = 1104
    static let fingerTap: SystemSoundID = 1057
    static let rectangle: SystemSoundID = 1110
    static let cameraShutter: SystemSoundID = 1108 // iPhone shutter
    static let thumbsUp: SystemSoundID = diamond
    static let handshake: SystemSoundID = 1022

    static func play(_ id: SystemSoundID) {
        AudioServicesPlaySystemSound(id)
    }
}

struct HandGestureDetector {
    var touchThreshold: Float = 0.025
    var spreadMin: Float      = 0.035
    var cooldown: TimeInterval = 0.8
    
    var thumbExtendedMin: Float = 0.050
    var curledMax: Float        = 0.035
    
    var thumbsUpCooldown: TimeInterval = 1.0
    var handshakeCooldown: TimeInterval = 1.2
    
    var hsCurledMaxFactor: Float = 1.10
    var hsThumbAcrossIdxFactor: Float = 1.0
    
    var hsPalmVerticalDotMax: Float = 0.70
    
    var hsWindowSeconds: Double = 1.0
    var hsMinZeroCrossings: Int = 1
    var hsMinFreqHz: Double    = 0.8
    var hsMaxFreqHz: Double    = 5.0
    var hsMinAmplitude: Float  = 0.015
    var hsMaxAmplitude: Float  = 0.16

    var debugHandshake = false

    private(set) var lastDiamondAt: TimeInterval   = 0
    private(set) var lastRectangleAt: TimeInterval = 0
    private(set) var lastFingerTouchAtLeft: TimeInterval  = 0
    private(set) var lastFingerTouchAtRight: TimeInterval = 0
    private(set) var lastThumbsUpAtLeft: TimeInterval  = 0
    private(set) var lastThumbsUpAtRight: TimeInterval = 0
    private(set) var lastHandshakeAtLeft: TimeInterval  = 0
    private(set) var lastHandshakeAtRight: TimeInterval = 0

    @inline(__always)
    func debugLog(_ enabled: Bool, _ msg: @autoclosure () -> String) {
        if enabled { print(msg()) }
    }
    
    mutating func maybeTriggerDiamond(now: TimeInterval) -> Bool {
        guard now - lastDiamondAt >= cooldown else { return false }
        lastDiamondAt = now
        return true
    }

    mutating func maybeTriggerRectangle(now: TimeInterval) -> Bool {
        guard now - lastRectangleAt >= cooldown else { return false }
        lastRectangleAt = now
        return true
    }

    mutating func maybeTriggerFingerTouch(isLeft: Bool, now: TimeInterval) -> Bool {
        if isLeft {
            guard now - lastFingerTouchAtLeft >= cooldown else { return false }
            lastFingerTouchAtLeft = now
            return true
        } else {
            guard now - lastFingerTouchAtRight >= cooldown else { return false }
            lastFingerTouchAtRight = now
            return true
        }
    }
    
    mutating func maybeTriggerThumbsUp(isLeft: Bool, now: TimeInterval) -> Bool {
           if isLeft {
               guard now - lastThumbsUpAtLeft >= thumbsUpCooldown else { return false }
               lastThumbsUpAtLeft = now
               return true
           } else {
               guard now - lastThumbsUpAtRight >= thumbsUpCooldown else { return false }
               lastThumbsUpAtRight = now
               return true
           }
    }
    
    mutating func maybeTriggerHandshake(isLeft: Bool, now: TimeInterval) -> Bool {
            if isLeft {
                guard now - lastHandshakeAtLeft >= handshakeCooldown else { return false }
                lastHandshakeAtLeft = now
                return true
            } else {
                guard now - lastHandshakeAtRight >= handshakeCooldown else { return false }
                lastHandshakeAtRight = now
                return true
            }
        }
    

}
