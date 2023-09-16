//
//  AppData.swift
//  TasQuest
//
//  Created by KAWAGUCHI KINJI on 2023/09/05.
//

import Foundation


public class AppDataSingleton: NSObject, ObservableObject, NativeCallsProtocol {
    public static let shared = AppDataSingleton()
    
    var appData: AppData
    
    override init() {  // NSObject を継承しているので、init も override する
        self.appData = AppData() // 初期化
        super.init()
        NSClassFromString("FrameworkLibAPI")?.registerAPIforNativeCalls(self)
    }
    
    public func updateAppData(_ message: String) {
        do {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd/HH:mm:ss"

                let jsonDecoder = JSONDecoder()
                jsonDecoder.dateDecodingStrategy = .formatted(dateFormatter)
            
                if let jsonData = message.data(using: .utf8) {
                    let updatedAppData = try jsonDecoder.decode(AppData.self, from: jsonData)
                    self.appData = updatedAppData
                } else {
                    print("Failed to convert message to Data.")
                }
        } catch {
            print("Failed to update AppData:", error)
        }
        
        FirestoreManager.shared.saveAppData() { error in
            if let error = error {
                print("Failed to save data: \(error)")
            } else {
                print("Data saved successfully.")
                // Updateをフェッチしシングルトンオブジェクトを更新
                FirestoreManager.shared.fetchAppData { fetchedAppData in
                    if let fetchedAppData = fetchedAppData {
                        AppDataSingleton.shared.appData = fetchedAppData
//                        NotificationCenter.default.post(name: Notification.Name("TaskUpdated"), object: nil)
                    } else {
                        // Handle error
                    }
                }
            }
        }
        NotificationCenter.default.post(name: Notification.Name("TaskUpdated"), object: nil)
    }
}


struct AppData: Codable {
    let userid: String
    var username: String
    var statuses: [Status]
    var tags: [Tag]
    var createdAt: Date // YYYY-MM-DD/HH:MM:SS
    
    

    init(userid: String = "", username: String = "", statuses: [Status] = [], tags: [Tag] = [], createdAt: Date = Date()) {
        self.userid = userid
        self.username = username
        self.statuses = statuses
        self.tags = tags
        self.createdAt = createdAt
    }
}
