//
//  HostModelInput.swift
//  TasQuest
//
//  Created by KinjiKawaguchi on 2023/09/14.
//

import Foundation

protocol HostModelInput {
    func sendAppDataToUnity(appData: AppData)
}

final class HostModel: HostModelInput {
    
    func sendAppDataToUnity(appData: AppData) {
        // AppDataをJSONに変換
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .formatted({
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd/HH:mm:ss"
            return formatter
        }())
        
        do {
            let jsonData = try encoder.encode(appData)
            if let appDataJsonString = String(data: jsonData, encoding: .utf8) {
                
                // JSON文字列をエスケープしてUnityに適した形にする
                let escapedJsonString = appDataJsonString
                    .replacingOccurrences(of: "\\", with: "\\\\")
                    .replacingOccurrences(of: "\"", with: "\\\"")
                
                // UnityFrameworkのメソッドを呼び出す
                Unity.shared.sendMessageToUnity(objectName: "DataExchanger", functionName: "ReceiveAppData", argument: escapedJsonString)
                
            }
        } catch {
            print("Error encoding AppData to JSON: \(error)")
        }
    }
    
    func sendStatusIDToUnity(statusID: String){
        Unity.shared.sendMessageToUnity(objectName: "DataExhanger", functionName: "ReceiveStatusID", argument: statusID)
    }
    
    func sendGoalIDToUnity(goalID: String) {
        // UnityFrameworkのメソッドを呼び出す
        Unity.shared.sendMessageToUnity(objectName: "DataExchanger", functionName: "ReceiveGoalID", argument: goalID)
    }
}
