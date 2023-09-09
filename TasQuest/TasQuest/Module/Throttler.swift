//
//  Thttler.swift
//  TasQuest
//
//  Created by KinjiKawaguchi on 2023/09/09.
//

import Foundation

class Throttler {
    private var lastRun: Date?
    private let delay: TimeInterval
    
    init(delay: TimeInterval) {
        self.delay = delay
    }
    
    func run(action: @escaping () -> Void) {
        guard lastRun == nil || Date().timeIntervalSince(lastRun!) >= delay else {
            return
        }
        
        lastRun = Date()
        action()
    }
}
