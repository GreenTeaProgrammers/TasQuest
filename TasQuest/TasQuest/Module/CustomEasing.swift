//
//  CustomEasing.swift
//  TasQuest
//
//  Created by KinjiKawaguchi on 2023/09/06.
//

import CoreGraphics
import SwiftUI

enum CustomEasing {
    enum easeIn {
        case sine
        case quad
        case cubic
        case quart
        case quint
        case expo
        case circ
        case back

        func timingCurve(duration: CGFloat = 0.2) -> Animation {
            switch self {
            case .sine: return .timingCurve(0.12, 0, 0.39, 0, duration: duration)
            case .quad: return .timingCurve(0.11, 0, 0.5, 0, duration: duration)
            case .cubic: return .timingCurve(0.32, 0, 0.67, 0, duration: duration)
            case .quart: return .timingCurve(0.5, 0, 0.75, 0, duration: duration)
            case .quint: return .timingCurve(0.64, 0, 0.78, 0, duration: duration)
            case .expo: return .timingCurve(0.7, 0, 0.84, 0, duration: duration)
            case .circ: return .timingCurve(0.55, 0, 1, 0.45, duration: duration)
            case .back: return .timingCurve(0.36, 0, 0.66, -0.56, duration: duration)
            }
        }

        func progress(elapsed: CGFloat) -> CGFloat {
            switch self {
            case .sine:
                return 1 - cos((elapsed * .pi) / 2)
            case .quad:
                return elapsed * elapsed
            case .cubic:
                return elapsed * elapsed * elapsed
            case .quart:
                return elapsed * elapsed * elapsed * elapsed
            case .quint:
                return elapsed * elapsed * elapsed * elapsed * elapsed
            case .expo:
                return elapsed == 0 ? 0 : pow(2, 10 * elapsed - 10)
            case .circ:
                return 1 - sqrt(1 - pow(elapsed, 2))
            case .back:
                let c1 = 1.70158
                let c3 = c1 + 1
                return c3 * elapsed * elapsed * elapsed - c1 * elapsed * elapsed
            }
        }
    }

    enum easeOut {
        case sine
        case quad
        case cubic
        case quart
        case quint
        case expo
        case circ
        case back

        func timingCurve(duration: CGFloat) -> Animation {
            switch self {
            case .sine: return .timingCurve(0.61, 1, 0.88, 1, duration: duration)
            case .quad: return .timingCurve(0.5, 1, 0.89, 1, duration: duration)
            case .cubic: return .timingCurve(0.33, 1, 0.68, 1, duration: duration)
            case .quart: return .timingCurve(0.25, 1, 0.5, 1, duration: duration)
            case .quint: return .timingCurve(0.22, 1, 0.36, 1, duration: duration)
            case .expo: return .timingCurve(0.16, 1, 0.3, 1, duration: duration)
            case .circ: return .timingCurve(0, 0.55, 0.45, 1, duration: duration)
            case .back: return .timingCurve(0.34, 1.56, 0.64, 1, duration: duration)
            }
        }

        func progress(elapsed: CGFloat) -> CGFloat {
            switch self {
            case .sine:
                return sin((elapsed * .pi) / 2)
            case .quad:
                return 1 - (1 - elapsed) * (1 - elapsed)
            case .cubic:
                return 1 - pow(1 - elapsed, 3)
            case .quart:
                return 1 - pow(1 - elapsed, 4)
            case .quint:
                return 1 - pow(1 - elapsed, 5)
            case .expo:
                return elapsed == 1 ? 1 : 1 - pow(2, -10 * elapsed)
            case .circ:
                return sqrt(1 - pow(elapsed - 1, 2))
            case .back:
                let c1 = 1.70158
                let c3 = c1 + 1

                return 1 + c3 * pow(elapsed - 1, 3) + c1 * pow(elapsed - 1, 2)
            }
        }
    }

    enum easeInOut {
        case sine
        case quad
        case cubic
        case quart
        case quint
        case expo
        case circ
        case back

        func timingCurve(duration: CGFloat) -> Animation {
            switch self {
            case .sine: return .timingCurve(0.37, 0, 0.63, 1, duration: duration)
            case .quad: return .timingCurve(0.45, 0, 0.55, 1, duration: duration)
            case .cubic: return .timingCurve(0.65, 0, 0.35, 1, duration: duration)
            case .quart: return .timingCurve(0.76, 0, 0.24, 1, duration: duration)
            case .quint: return .timingCurve(0.83, 0, 0.17, 1, duration: duration)
            case .expo: return .timingCurve(0.87, 0, 0.13, 1, duration: duration)
            case .circ: return .timingCurve(0.85, 0, 0.15, 1, duration: duration)
            case .back: return .timingCurve(0.68, -0.6, 0.32, 1.6, duration: duration)
            }
        }

        func progress(elapsed: CGFloat) -> CGFloat {
            switch self {
            case .sine:
                return -(cos(.pi * elapsed) - 1) / 2
            case .quad:
                return elapsed < 0.5 ? 2 * elapsed * elapsed : 1 - pow(-2 * elapsed + 2, 2) / 2
            case .cubic:
                return elapsed < 0.5 ? 4 * elapsed * elapsed * elapsed : 1 - pow(-2 * elapsed + 2, 3) / 2
            case .quart:
                return elapsed < 0.5 ? 8 * elapsed * elapsed * elapsed * elapsed : 1 - pow(-2 * elapsed + 2, 4) / 2
            case .quint:
                return elapsed < 0.5 ? 16 * elapsed * elapsed * elapsed * elapsed * elapsed : 1 - pow(-2 * elapsed + 2, 5) / 2
            case .expo:
                return elapsed == 0
                  ? 0
                  : elapsed == 1
                  ? 1
                  : elapsed < 0.5 ? pow(2, 20 * elapsed - 10) / 2
                  : (2 - pow(2, -20 * elapsed + 10)) / 2
            case .circ:
                return elapsed < 0.5
                  ? (1 - sqrt(1 - pow(2 * elapsed, 2))) / 2
                  : (sqrt(1 - pow(-2 * elapsed + 2, 2)) + 1) / 2
            case .back:
                let c1 = 1.70158
                let c2 = c1 * 1.525

                return elapsed < 0.5
                  ? (pow(2 * elapsed, 2) * ((c2 + 1) * 2 * elapsed - c2)) / 2
                  : (pow(2 * elapsed - 2, 2) * ((c2 + 1) * (elapsed * 2 - 2) + c2) + 2) / 2
            }
        }
    }
}
