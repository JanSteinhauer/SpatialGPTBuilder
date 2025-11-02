//
//  HandTrackingSystem.swift
//  SpatialGPTBuilder
//
//  Created by Steinhauer, Jan on 02.11.25.
//

import RealityKit
import ARKit
import UIKit
import AudioToolbox
import simd



struct HandTrackingSystem: System {
    // MARK: - ARKit providers & latest anchors

    static var arSession = ARKitSession()
    static let handTracking = HandTrackingProvider()
    static let confettiRoot: AnchorEntity = {
        let t = simd_float4x4(translation: SIMD3<Float>(0, 2, 0))
        return AnchorEntity(.world(transform: t))
    }()
    
    static let floatyQuery = EntityQuery(where:
        .has(FloatyConfetti.self) && .has(PhysicsMotionComponent.self)
    )
    
    var debugHandshake = true


    static var leftMotion  = MotionBuffer(maxSeconds: 2.0)
    static var rightMotion = MotionBuffer(maxSeconds: 2.0)
    
    static var latestLeftHand: HandAnchor?
    static var latestRightHand: HandAnchor?

    // MARK: - Gesture state

    static var detector = HandGestureDetector()

    // MARK: - Utilities

    static func distance(_ a: SIMD3<Float>, _ b: SIMD3<Float>) -> Float {
        simd_length(a - b)
    }

    static func jointWorldPos(_ entity: Entity?) -> SIMD3<Float>? {
        entity?.position(relativeTo: nil)
    }

    static func firstEntity<S: Sequence>(
        with chirality: AnchoringComponent.Target.Chirality,
        in entities: S
    ) -> Entity? where S.Element == Entity {
        entities.first { ($0.components[HandTrackingComponent.self]?.chirality) == chirality }
    }
    
    static func spawnConfetti(around center: SIMD3<Float>, in _: RealityKit.Scene, count: Int = 160) {
        let uiColors: [UIColor] = [.systemRed, .systemGreen, .systemBlue, .systemYellow, .magenta, .cyan, .white]

        let burst = Entity()
        burst.setPosition(center, relativeTo: nil)

        for _ in 0..<count {
            let w: Float = .random(in: 0.003...0.008)
            let h: Float = .random(in: 0.0008...0.002)
            let d: Float = .random(in: 0.003...0.008)

            let mesh = MeshResource.generateBox(size: [w, h, d])
            let color = uiColors.randomElement() ?? .white
            let material = SimpleMaterial(color: color, isMetallic: false)
            let confetti = ModelEntity(mesh: mesh, materials: [material])

            confetti.position = SIMD3<Float>(
                .random(in: -0.2...0.2),
                .random(in:  0.8...1.4),
                .random(in: -0.2...0.2)
            )

            confetti.generateCollisionShapes(recursive: false)

            var body = PhysicsBodyComponent(
                massProperties: .default,
                material: .default,
                mode: .dynamic
            )
            body.linearDamping  = 0.96
            body.angularDamping = 0.96
            confetti.components[PhysicsBodyComponent.self] = body

            confetti.components[PhysicsMotionComponent.self] = .init(
                linearVelocity: SIMD3<Float>(
                    .random(in: -0.06...0.06),
                    .random(in:  0.02...0.08),
                    .random(in: -0.06...0.06)
                ),
                angularVelocity: SIMD3<Float>(
                    .random(in: -1.6...1.6),
                    .random(in: -1.6...1.6),
                    .random(in: -1.6...1.6)
                )
            )

            confetti.components[FloatyConfetti.self] = .init(
                terminalFallSpeed: -0.12,
                liftPerSecond: 0.25
            )

            burst.addChild(confetti)
        }

        // attach under the pre-added world anchor
        HandTrackingSystem.confettiRoot.addChild(burst)

        Task { @MainActor in
            try? await Task.sleep(nanoseconds: 5_000_000_000)
            burst.removeFromParent()
        }
    }

    // MARK: - System lifecycle

    init(scene: RealityKit.Scene) {
        Task { await Self.runSession() }
    }

    @MainActor
    static func runSession() async {
        do {
            try await arSession.run([handTracking])
        } catch let error as ARKitSession.Error {
            print("ARKit provider error: \(error.localizedDescription)")
        } catch {
            print("Unexpected ARKit error: \(error.localizedDescription)")
        }

        // Stream hand anchors
        for await anchorUpdate in handTracking.anchorUpdates {
            switch anchorUpdate.anchor.chirality {
            case .left:
                Self.latestLeftHand = anchorUpdate.anchor
            case .right:
                Self.latestRightHand = anchorUpdate.anchor
            @unknown default:
                break
            }
        }
    }

    static let query = EntityQuery(where: .has(HandTrackingComponent.self))

    // MARK: - Per-frame update

    func update(context: SceneUpdateContext) {
        let handEntities = context.entities(matching: Self.query, updatingSystemWhen: .rendering)

        // Update/initialize joint spheres on each hand entity
        for entity in handEntities {
            guard var handComponent = entity.components[HandTrackingComponent.self] else { continue }

            if handComponent.fingers.isEmpty {
                self.addJoints(to: entity, handComponent: &handComponent)
            }

            guard let handAnchor: HandAnchor = {
                switch handComponent.chirality {
                case .left:  return Self.latestLeftHand
                case .right: return Self.latestRightHand
                @unknown default: return nil
                }
            }() else { continue }

            if let handSkeleton = handAnchor.handSkeleton {
                for (jointName, jointEntity) in handComponent.fingers {
                    let anchorFromJoint = handSkeleton.joint(jointName).anchorFromJointTransform
                    jointEntity.setTransformMatrix(
                        handAnchor.originFromAnchorTransform * anchorFromJoint,
                        relativeTo: nil
                    )
                }
            }
        }

        let now = CFAbsoluteTimeGetCurrent()

        let leftEntity  = Self.firstEntity(with: .left,  in: handEntities)
        let rightEntity = Self.firstEntity(with: .right, in: handEntities)
        let leftComp  = leftEntity?.components[HandTrackingComponent.self]
        let rightComp = rightEntity?.components[HandTrackingComponent.self]

        func pos(_ comp: HandTrackingComponent, _ name: HandSkeleton.JointName) -> SIMD3<Float>? {
            Self.jointWorldPos(comp.fingers[name])
        }
        
        if let l = leftComp  { checkThumbsUp(l,  isLeft: true,  now: now) }
        if let r = rightComp { checkThumbsUp(r, isLeft: false, now: now) }
        

        func wristPos(_ comp: HandTrackingComponent) -> SIMD3<Float>? {
            Self.jointWorldPos(comp.fingers[.forearmWrist])
        }
        
        func palmCenterPos(_ comp: HandTrackingComponent) -> SIMD3<Float>? {
            guard
                let idxK = Self.jointWorldPos(comp.fingers[.indexFingerKnuckle]),
                let litK = Self.jointWorldPos(comp.fingers[.littleFingerKnuckle])
            else { return nil }
            return (idxK + litK) * 0.5
        }


        if let l = leftComp, let wp = wristPos(l) {
            Self.leftMotion.add(now, wp)
            debugLog(Self.detector.debugHandshake, "[Handshake][Left] Sample t=\(String(format: "%.3f", now)) p=\(wp)")
            let count = Self.leftMotion.recent(seconds: Self.detector.hsWindowSeconds, now: now).count
            debugLog(Self.detector.debugHandshake, "[Handshake][Left] Window count=\(count)")
        }

        if let r = rightComp, let wp = wristPos(r) {
            Self.rightMotion.add(now, wp)
            debugLog(Self.detector.debugHandshake, "[Handshake][Right] Sample t=\(String(format: "%.3f", now)) p=\(wp)")
            let count = Self.rightMotion.recent(seconds: Self.detector.hsWindowSeconds, now: now).count
            debugLog(Self.detector.debugHandshake, "[Handshake][Right] Window count=\(count)")
        }
        
        if let l = leftComp  { checkHandshake(l,  isLeft: true,  now: now, context: context) }
        if let r = rightComp { checkHandshake(r, isLeft: false, now: now, context: context) }

        if let l = leftComp, let r = rightComp,
           let lt = pos(l, .thumbTip),      let rt = pos(r, .thumbTip),
           let li = pos(l, .indexFingerTip), let ri = pos(r, .indexFingerTip) {

            let rightThumb_to_leftIndex = Self.distance(rt, li)
            let leftThumb_to_rightIndex = Self.distance(lt, ri)

            if rightThumb_to_leftIndex <= Self.detector.touchThreshold &&
                   leftThumb_to_rightIndex <= Self.detector.touchThreshold &&
                   Self.detector.maybeTriggerRectangle(now: now) {

                    GestureSound.play(GestureSound.cameraShutter)

                let midIndex = (li + ri) * 0.5
                let midThumb = (lt + rt) * 0.5
                let mid      = (midIndex + midThumb) * 0.5
                    Self.spawnConfetti(around: mid, in: context.scene, count: 140)
                }
        }

//        // --- Single-hand index↔︎middle touch ---
//        func checkIndexMiddleTouch(_ comp: HandTrackingComponent, isLeft: Bool) {
//            guard let ip = pos(comp, .indexFingerTip),
//                  let mp = pos(comp, .middleFingerTip) else { return }
//            if Self.distance(ip, mp) <= Self.detector.touchThreshold,
//               Self.detector.maybeTriggerFingerTouch(isLeft: isLeft, now: now) {
//                GestureSound.play(GestureSound.fingerTap)
//            }
//        }
        
        // Slow-fall integrator for confetti (no gravityFactor needed)
//
    }

    // MARK: - Joint spheres setup

    func addJoints(to handEntity: Entity, handComponent: inout HandTrackingComponent) {
        let radius: Float = 0.01
        let material = SimpleMaterial(color: .white, isMetallic: false)
        let sphereEntity = ModelEntity(mesh: .generateSphere(radius: radius), materials: [material])

        for (jointName, _, _) in Hand.joints {
            let newJoint = sphereEntity.clone(recursive: false)
            handEntity.addChild(newJoint)
            handComponent.fingers[jointName] = newJoint
        }

        handEntity.components.set(handComponent)
    }
    
    
    func checkThumbsUp(_ comp: HandTrackingComponent, isLeft: Bool, now: TimeInterval) {
        // Helper to fetch positions
        func pos(_ n: HandSkeleton.JointName) -> SIMD3<Float>? {
            Self.jointWorldPos(comp.fingers[n])
        }

        // Require these joints
        guard
            let thumbTip      = pos(.thumbTip),
            let thumbKnuckle  = pos(.thumbKnuckle),

            let indexTip      = pos(.indexFingerTip),
            let indexKnuckle  = pos(.indexFingerKnuckle),

            let middleTip     = pos(.middleFingerTip),
            let middleKnuckle = pos(.middleFingerKnuckle),

            let ringTip       = pos(.ringFingerTip),
            let ringKnuckle   = pos(.ringFingerKnuckle),

            let littleTip     = pos(.littleFingerTip),
            let littleKnuckle = pos(.littleFingerKnuckle)
        else { return }

        let thumbExtended = Self.distance(thumbTip, thumbKnuckle) >= Self.detector.thumbExtendedMin

        @inline(__always)
        func curled(_ tip: SIMD3<Float>, _ knuckle: SIMD3<Float>) -> Bool {
            Self.distance(tip, knuckle) <= Self.detector.curledMax
        }

        let othersCurled =
            curled(indexTip, indexKnuckle) &&
            curled(middleTip, middleKnuckle) &&
            curled(ringTip,   ringKnuckle)   &&
            curled(littleTip, littleKnuckle)

        if thumbExtended && othersCurled,
           Self.detector.maybeTriggerThumbsUp(isLeft: isLeft, now: now) {
            GestureSound.play(GestureSound.thumbsUp)

            NotificationCenter.default.post(
                name: .thumbsUpDetected,
                object: nil,
                userInfo: ["isLeft": isLeft]
            )

          
        }
    }
    
    // HandTrackingSystem.swift
    func checkHandshake(_ comp: HandTrackingComponent, isLeft: Bool, now: TimeInterval, context: SceneUpdateContext) {
        let dbg = Self.detector.debugHandshake
        func pos(_ n: HandSkeleton.JointName) -> SIMD3<Float>? { Self.jointWorldPos(comp.fingers[n]) }

        guard
            let thumbTip = pos(.thumbTip),
            let indexTip = pos(.indexFingerTip),
            let indexKnuckle = pos(.indexFingerKnuckle),
            let middleTip = pos(.middleFingerTip), let middleKnuckle = pos(.middleFingerKnuckle),
            let ringTip   = pos(.ringFingerTip),   let ringKnuckle   = pos(.ringFingerKnuckle),
            let littleTip = pos(.littleFingerTip), let littleKnuckle = pos(.littleFingerKnuckle),
            let wrist = pos(.forearmWrist),
            let midK = pos(.middleFingerKnuckle),
            let idxK = pos(.indexFingerKnuckle), let litK = pos(.littleFingerKnuckle)
        else {
            debugLog(dbg, "[Handshake][\(isLeft ? "L" : "R")] Missing required joints")
            return
        }

        let palmWidth = max(Self.distance(idxK, litK), 0.001)
        debugLog(dbg, "[Handshake][\(isLeft ? "L" : "R")] palmWidth=\(String(format: "%.3f", palmWidth))")

        // (1) Grip
        @inline(__always)
        func curled(_ tip: SIMD3<Float>, _ kn: SIMD3<Float>) -> (Bool, Float) {
            let d = Self.distance(tip, kn)
            let ok = d <= Self.detector.hsCurledMaxFactor * palmWidth
            return (ok, d)
        }
        let (idxCurled, idxD) = curled(indexTip, indexKnuckle)
        let (midCurled, midD) = curled(middleTip, middleKnuckle)
        let (rngCurled, rngD) = curled(ringTip,   ringKnuckle)
        let (litCurled, litD) = curled(littleTip, littleKnuckle)

        let thumbAcrossD = Self.distance(thumbTip, indexKnuckle)
        let thumbAcross  = thumbAcrossD <= Self.detector.hsThumbAcrossIdxFactor * palmWidth

        debugLog(dbg, """
        [Handshake][\(isLeft ? "L" : "R")] Grip:
          idxCurled=\(idxCurled) d=\(String(format: "%.3f", idxD))
          midCurled=\(midCurled) d=\(String(format: "%.3f", midD))
          rngCurled=\(rngCurled) d=\(String(format: "%.3f", rngD))
          litCurled=\(litCurled) d=\(String(format: "%.3f", litD))
          thumbAcross=\(thumbAcross) d=\(String(format: "%.3f", thumbAcrossD))
        """)

        let allFingersCurled = idxCurled && midCurled && rngCurled && litCurled

        // (2) Palm vertical
        let edge  = simd_normalize(litK - idxK)
        let span  = simd_normalize(midK - wrist)
        let normal = simd_normalize(simd_cross(edge, span))
        let worldUp = SIMD3<Float>(0, 1, 0)
        let dotUp = abs(simd_dot(normal, worldUp))
        let palmVerticalOK = dotUp <= Self.detector.hsPalmVerticalDotMax

        debugLog(dbg, "[Handshake][\(isLeft ? "L" : "R")] Palm: |dot(normal, up)|=\(String(format: "%.3f", dotUp)) ok=\(palmVerticalOK)")

        // (3) Oscillation
        let buf = isLeft ? Self.leftMotion : Self.rightMotion
        let window = buf.recent(seconds: Self.detector.hsWindowSeconds, now: now)
        guard window.count >= 6 else {
            debugLog(dbg, "[Handshake][\(isLeft ? "L" : "R")] Not enough samples: \(window.count)")
            return
        }

        let xs = window.map { $0.p.x }, ys = window.map { $0.p.y }, zs = window.map { $0.p.z }
        func variance(_ arr: [Float]) -> Float {
            guard let m = arr.average else { return 0 }
            let v = arr.reduce(0) { $0 + ( $1 - m ) * ( $1 - m ) }
            return v / max(Float(arr.count - 1), 1)
        }
        let varX = variance(xs), varY = variance(ys), varZ = variance(zs)
        let axis: String
        let coords: [Float]
        if varX > varY && varX > varZ { axis = "x"; coords = xs }
        else if varY > varZ { axis = "y"; coords = ys }
        else { axis = "z"; coords = zs }

        guard let minC = coords.min(), let maxC = coords.max() else { return }
        let amplitude = maxC - minC

        var zeroCrossings = 0
        if coords.count >= 3 {
            var lastVel: Float? = nil
            for i in 1..<coords.count {
                let dt = Float(window[i].t - window[i-1].t)
                if dt <= 0 { continue }
                let v = (coords[i] - coords[i-1]) / dt
                if let lv = lastVel {
                    if (lv > 0 && v < 0) || (lv < 0 && v > 0) { zeroCrossings += 1 }
                }
                lastVel = v
            }
        }

        let duration = max(window.last!.t - window.first!.t, 1e-3)
        let cycles = Double(zeroCrossings) / 2.0
        let freqHz = cycles / duration

        let oscOK =
            zeroCrossings >= Self.detector.hsMinZeroCrossings &&
            freqHz >= Self.detector.hsMinFreqHz &&
            freqHz <= Self.detector.hsMaxFreqHz &&
            amplitude >= Self.detector.hsMinAmplitude &&
            amplitude <= Self.detector.hsMaxAmplitude

        debugLog(dbg, """
        [Handshake][\(isLeft ? "L" : "R")] Motion:
          axis=\(axis) samples=\(window.count) duration=\(String(format: "%.3f", duration))
          zeroCrossings=\(zeroCrossings) freq=\(String(format: "%.2f", freqHz))Hz
          amplitude=\(String(format: "%.3f", amplitude)) (min=\(String(format: "%.3f", minC)) max=\(String(format: "%.3f", maxC)))
          oscOK=\(oscOK)
        """)

        // Cooldown info
        if isLeft {
            let remaining = max(0, Self.detector.handshakeCooldown - (now - Self.detector.lastHandshakeAtLeft))
            debugLog(dbg, "[Handshake][L] Cooldown remaining=\(String(format: "%.2f", remaining))s")
        } else {
            let remaining = max(0, Self.detector.handshakeCooldown - (now - Self.detector.lastHandshakeAtRight))
            debugLog(dbg, "[Handshake][R] Cooldown remaining=\(String(format: "%.2f", remaining))s")
        }

        let decision = allFingersCurled && thumbAcross && palmVerticalOK && oscOK
        debugLog(dbg, "[Handshake][\(isLeft ? "L" : "R")] Decision=\(decision) (grip=\(allFingersCurled && thumbAcross), palm=\(palmVerticalOK), osc=\(oscOK))")

        if decision, Self.detector.maybeTriggerHandshake(isLeft: isLeft, now: now) {
            print("[Handshake][\(isLeft ? "L" : "R")] TRIGGER -> play sound + post notification")
            GestureSound.play(GestureSound.handshake)

            NotificationCenter.default.post(
                name: .handshakeDetected,
                object: nil,
                userInfo: ["isLeft": isLeft,
                           "freqHz": freqHz,
                           "amplitude": amplitude,
                           "axis": axis]
            )
        } else if decision {
            print("[Handshake][\(isLeft ? "L" : "R")] Decision true but in cooldown – suppressed trigger")
        }
    }
    
    @inline(__always)
    func debugLog(_ enabled: Bool, _ msg: @autoclosure () -> String) {
        if enabled { print(msg()) }
    }


}


extension simd_float4x4 {
    init(translation t: SIMD3<Float>) {
        self = matrix_identity_float4x4
        columns.3 = SIMD4<Float>(t.x, t.y, t.z, 1)
    }
}

struct FloatyConfetti: Component {
    var terminalFallSpeed: Float = -0.12
    var liftPerSecond:   Float =  0.25
}

    extension Array where Element == Float {
        var average: Float? {
            guard !isEmpty else { return nil }
            return self.reduce(0, +) / Float(self.count)
        }
    }
