//
//  FireStoreManager.swift
//  TasQuest
//
//  Created by KinjiKawaguchi on 2023/09/09.
//


import FirebaseFirestore
import FirebaseAuth
import Firebase

class FirestoreManager {
    
    static let shared = FirestoreManager()
    private let db = Firestore.firestore()
    
    private init() {
        print("FirestoreManager initialized")
    }
    
    func fetchAppData(completion: @escaping (AppData?) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("Error: No current user ID")
            completion(nil)
            return
        }
        
        let userRef = db.collection("Users").document(userId)
        
        fetchUserData(from: userRef) { (userData, error) in
            if let error = error {
                print("Error fetching user data: \(error)")
                completion(nil)
                return
            }
            
            guard let userData = userData else {
                print("Error: User data is nil")
                completion(nil)
                return
            }
            
            let dispatchGroup = DispatchGroup()
            
            var tags: [Tag] = []
            var statuses: [Status] = []
            
            dispatchGroup.enter()
            self.fetchTags(from: userRef) { (fetchedTags, error) in
                if let error = error {
                    print("Error fetching tags: \(error)")
                } else {
                    print("FetchedTag: \(fetchedTags)")
                    tags = fetchedTags
                }
                dispatchGroup.leave()
            }
            
            dispatchGroup.enter()
            self.fetchStatuses(from: userRef, with: tags) { (fetchedStatuses, error) in
                if let error = error {
                    print("Error fetching statuses: \(error)")
                } else {
                    statuses = fetchedStatuses
                }
                dispatchGroup.leave()
            }
            
            dispatchGroup.notify(queue: .main) {
                let appData = AppData(userid: userId,
                                      username: userData.name,
                                      statuses: statuses,
                                      tags: tags,
                                      createdAt: userData.createdAt)
                print("Fetched all app data, completing.")
                completion(appData)
            }
        }
    }
    
    struct UserData {
        let name: String
        let createdAt: String
        // 他の必要なフィールドもここに追加できます
    }
    
    func fetchUserData(from userRef: DocumentReference, completion: @escaping (UserData?, Error?) -> Void) {
        userRef.getDocument { userSnapshot, error in
            if let error = error {
                completion(nil, error)
                return
            }
            
            guard let userData = userSnapshot?.data(),
                  let userName = userData["name"] as? String,
                  let userCreatedAt = userData["createdAt"] as? String else {
                completion(nil, NSError(domain: "App", code: 1, userInfo: ["Description": "Failed to parse user data"]))
                return
            }
            
            let user = UserData(name: userName, createdAt: userCreatedAt)
            completion(user, nil)
        }
    }
    
    func fetchTags(from userRef: DocumentReference, completion: @escaping ([Tag], Error?) -> Void) {
        userRef.collection("Tags").getDocuments { tagSnapshot, error in
            if let error = error {
                completion([], error)
                return
            }
            
            var tags: [Tag] = []
            for tagDoc in tagSnapshot!.documents {
                let tagData = tagDoc.data()
                if let tagName = tagData["name"] as? String,
                   let tagColor = tagData["color"] as? [Float],
                   let tagCreatedAt = tagData["createdAt"] as? String,
                   let tagUpdatedAt = tagData["updatedAt"] as? String {
                    
                    let tag = Tag(id: tagDoc.documentID,
                                  name: tagName,
                                  color: tagColor,
                                  createdAt: tagCreatedAt,
                                  updatedAt: tagUpdatedAt)
                    tags.append(tag)
                }
            }
            
            completion(tags, nil)
        }
    }

    
    func fetchStatuses(from userRef: DocumentReference, with tags: [Tag], completion: @escaping ([Status], Error?) -> Void) {
        print("after fetch statuse tags \(tags)")
        userRef.collection("Statuses").getDocuments { statusSnapshot, error in
            if let error = error {
                completion([], error)
                return
            }
            
            let dispatchGroup = DispatchGroup()
            var statuses: [Status] = []
            
            for statusDoc in statusSnapshot!.documents {
                dispatchGroup.enter()
                
                let statusData = statusDoc.data()
                if let statusName = statusData["name"] as? String,
                   let statusUpdatedAt = statusData["updatedAt"] as? String {
                    
                    print("Processing status \(statusName)...")  // Log the status being processed
                    
                    let statusRef = userRef.collection("Statuses").document(statusDoc.documentID)
                    print("Tags before fetching goals: \(tags.map { $0.id })")
                    self.fetchGoals(from: statusRef, with: tags) { (fetchedGoals, error) in
                        if let error = error {
                            print("Error fetching goals for status \(statusName): \(error)")  // Log the error
                        } else {
                            print("Fetched \(fetchedGoals.count) goals for status \(statusName)")  // Log the number of fetched goals for this status
                        }
                        
                        let status = Status(id: statusDoc.documentID,
                                            name: statusName,
                                            goals: fetchedGoals, // Update this with fetched goals
                                            updatedAt: statusUpdatedAt)
                        statuses.append(status)
                        
                        dispatchGroup.leave()
                    }
                } else {
                    print("Status data could not be parsed.")  // Log if status data parsing fails
                }

            }
            
            dispatchGroup.notify(queue: .main) {
                completion(statuses, nil)
            }
        }
    }
    
    func fetchGoals(from statusRef: DocumentReference, with tags: [Tag], completion: @escaping ([Goal], Error?) -> Void) {
        print("Fetching goals from status \(statusRef.documentID)...")  // Log the start
        statusRef.collection("Goals").getDocuments { goalSnapshot, error in
            if let error = error {
                print("Failed to fetch goals: \(error)")  // Log the error
                completion([], error)
                return
            }
            
            guard let goalDocuments = goalSnapshot?.documents else {
                print("Goal snapshot is nil.")  // Log if snapshot is nil
                completion([], nil)
                return
            }
            
            print("Fetched \(goalDocuments.count) goals.")  // Log the number of fetched goals
            
            var goals: [Goal] = []
            
            for goalDoc in goalDocuments {
                let goalData = goalDoc.data()
                print("Raw goal data: \(goalData)")
                let goalIsStarred = (goalData["isStarred"] as? Int) == 1

                if let goalName = goalData["name"] as? String,
                   let goalDescription = goalData["description"] as? String,
                   let goalDueDate = goalData["dueDate"] as? String,
                   let goalThumbnail = goalData["thumbnail"] as? String,
                   let goalCreatedAt = goalData["createdAt"] as? String,
                   let goalUpdatedAt = goalData["updatedAt"] as? String {

                    let goalTagsIDs = goalData["tags"] as? [String] ?? []
                    print("Goal Tags IDs: \(goalTagsIDs)")  // デバッグ用
                    print("Available Tags IDs: \(tags.map { $0.id })")  // デバッグ用

                    let goalTags = tags.filter { goalTagsIDs.contains($0.id) }
                    print("Filtered Goal Tags: \(goalTags)")  // デバッグ用


                    // Tasks will be fetched later
                    let goal = Goal(id: goalDoc.documentID,
                                    name: goalName,
                                    description: goalDescription,
                                    tasks: [],  // これは後で処理します
                                    dueDate: goalDueDate,
                                    isStarred: goalIsStarred,
                                    tags: goalTags,  // ここで使用
                                    thumbnail: goalThumbnail,
                                    createdAt: goalCreatedAt,
                                    updatedAt: goalUpdatedAt)

                    goals.append(goal)
                    print("Processed goal: \(goalName)")  // Log each processed goal

                }
            }
            
            completion(goals, nil)
        }
    }


}
