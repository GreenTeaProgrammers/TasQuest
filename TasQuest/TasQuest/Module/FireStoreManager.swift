//
//  FireStoreManager.swift
//  TasQuest
//
//  Created by KinjiKawaguchi on 2023/09/09.
//


import FirebaseFirestore  // <-- Make sure to import this
import FirebaseAuth
import Firebase

class FirestoreManager {
    
    // Singleton Instance
    static let shared = FirestoreManager()
    
    private init() {}
    
    // Fetch AppData based on the current logged-in user
    func fetchAppData(completion: @escaping (AppData?) -> Void) -> AppData {
        guard let currentUser = Auth.auth().currentUser else {
            completion(nil)
            return
        }

        let userId = currentUser.uid
        let db = Firestore.firestore()
        let dispatchGroup = DispatchGroup()

        var username: String = ""
        var statuses: [Status] = []
        var tags: [Tag] = []

        // Fetch user document first
        db.collection("Users").document(userId).getDocument { (userDocument, error) in
            if let error = error {
                print("Error fetching user data: \(error)")
                completion(nil)
                return
            }

            guard let userDocumentData = userDocument?.data(),
                  let fetchedUsername = userDocumentData["name"] as? String else {
                print("Failed to convert user document")
                completion(nil)
                return
            }
            
            username = fetchedUsername

            // Fetch Statuses sub-collection
            dispatchGroup.enter()
            db.collection("Users").document(userId).collection("Statuses").getDocuments { (statusesSnapshot, error) in
                if let error = error {
                    print("Error fetching statuses: \(error)")
                    dispatchGroup.leave()
                    return
                }

                for statusDocument in statusesSnapshot?.documents ?? [] {
                    let statusData = statusDocument.data()
                    
                    // Fetch Goals sub-collection for each Status
                    dispatchGroup.enter()
                    db.collection("Users").document(userId).collection("Statuses").document(statusDocument.documentID).collection("Goals").getDocuments { (goalsSnapshot, error) in
                        if let error = error {
                            print("Error fetching goals: \(error)")
                            dispatchGroup.leave()
                            return
                        }

                        var goals: [Goal] = []
                        for goalDocument in goalsSnapshot?.documents ?? [] {
                            let goalData = goalDocument.data()

                            // Fetch TasQuestTasks sub-collection for each Goal
                            dispatchGroup.enter()
                            db.collection("Users").document(userId).collection("Statuses").document(statusDocument.documentID).collection("Goals").document(goalDocument.documentID).collection("TasQuestTasks").getDocuments { (tasksSnapshot, error) in
                                if let error = error {
                                    print("Error fetching tasks: \(error)")
                                    dispatchGroup.leave()
                                    return
                                }

                                let tasks = tasksSnapshot?.documents.compactMap { TasQuestTask(dictionary: $0.data()) } ?? []
                                let goal = Goal(data: goalData, tasks: tasks)
                                goals.append(goal)

                                dispatchGroup.leave()
                            }
                        }

                        let status = Status(data: statusData, goals: goals)
                        statuses.append(status)

                        dispatchGroup.leave()
                    }
                }

                dispatchGroup.leave()
            }

            // Fetch Tags sub-collection
            dispatchGroup.enter()
            db.collection("Users").document(userId).collection("Tags").getDocuments { (tagsSnapshot, error) in
                if let error = error {
                    print("Error fetching tags: \(error)")
                    dispatchGroup.leave()
                    return
                }

                tags = tagsSnapshot?.documents.compactMap { Tag(dictionary: $0.data()) } ?? []
                dispatchGroup.leave()
            }

            dispatchGroup.notify(queue: .main) {
                // Now, you have user data, statuses, and tags.
                let appData = AppData(userid: userId, username: username, statuses: statuses, tags: tags)
                completion(appData)
                return appData
            }
        }
    }
}
