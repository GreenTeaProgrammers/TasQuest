import Foundation

class AppDataSingleton : NSObject {
    static func swiftMethod(_ message: String) {
        print("\(#function) is called with message: \(message)")
    }
}
