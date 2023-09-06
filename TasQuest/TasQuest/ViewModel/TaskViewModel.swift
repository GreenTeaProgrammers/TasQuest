//
//  TaskViewModel.swift
//  TasQuest
//
//  Created by KinjiKawaguchi on 2023/09/06.
//


import Foundation
import SwiftUI

class TaskViewModel: ObservableObject {
    @Published var percentage: CGFloat = 1.0
    @Published var fillColor: Color = .green
    @Published var currentHP: Float = 315
    @Published var maxHP: Float = 315

    private var startTime: CFTimeInterval = .zero
    private var progress: CFTimeInterval = .zero
    private let duration: CGFloat = 5
    @Published var task: Task<Void, Never>? // 非同期関数の戻り値が Int, エラー型が Error の場合// Task.Handleを保存する変数

    func start() {
        task?.cancel()
        task = Task.detached { [weak self] in // [weak self] を追加してメモリリークを防ぐ
            self?.reset() // self を明示的に使用
            for await event in await CADisplayLink.events() {
                self?.progress = (event.timestamp - self!.startTime) / self!.duration
                if self?.progress ?? 0 > 1 {
                    self?.stop() // self を明示的に使用
                }
                self?.percentage = 1 - CustomEasing.easeOut.circ.progress(elapsed: self!.progress)
                self?.currentHP = Float(CGFloat(self!.maxHP) * (1.0 - (CustomEasing.easeOut.circ.progress(elapsed: self!.progress))))
                self?.fillColor = self?.getColor() ?? .red
            }
            return
        }
    }

    func stop() {
        task?.cancel()
        task = nil
    }

    private func reset() {
        startTime = CACurrentMediaTime()
        progress = .zero
        currentHP = maxHP
    }

    private func getColor() -> Color {
        if percentage > 0.5 {
            return .green
        } else if percentage > 0.2 {
            return .yellow
        } else {
            return .red
        }
    }
}
