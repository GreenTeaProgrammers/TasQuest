//
//  KeyboardResponder.swift
//  TasQuest
//
//  Created by KinjiKawaguchi on 2023/09/10.
//

import Foundation
import SwiftUI

// キーボードの高さを取得するためのクラス
final class KeyboardResponder: ObservableObject {
    @Published var currentHeight: CGFloat = 0

    func startObserve() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    func stopObserve() {
        NotificationCenter.default.removeObserver(self)
    }

    @objc func keyBoardWillShow(notification: Notification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            currentHeight = keyboardFrame.height
        }
    }

    @objc func keyBoardWillHide(notification: Notification) {
        currentHeight = 0
    }
}
