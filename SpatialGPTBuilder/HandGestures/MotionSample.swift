//
//  MotionSample.swift
//  SpatialGPTBuilder
//
//  Created by Steinhauer, Jan on 02.11.25.
//

import SwiftUI

struct MotionSample { let t: TimeInterval; let p: SIMD3<Float> }

final class MotionBuffer {
    private var samples: [MotionSample] = []
    private let maxSeconds: Double

    init(maxSeconds: Double) { self.maxSeconds = maxSeconds }

    func add(_ t: TimeInterval, _ p: SIMD3<Float>) {
        samples.append(.init(t: t, p: p))
        trim(olderThan: t - maxSeconds - 0.1)
    }

    func recent(seconds: Double, now: TimeInterval) -> [MotionSample] {
        let minT = now - seconds
        return Array(samples.drop { $0.t < minT })
    }


    private func trim(olderThan cutoff: TimeInterval) {
        if let idx = samples.firstIndex(where: { $0.t >= cutoff }) {
            if idx > 0 { samples.removeFirst(idx) }
        } else if !samples.isEmpty {
            samples.removeAll()
        }
    }
}
