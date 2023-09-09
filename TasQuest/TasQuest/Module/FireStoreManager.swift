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
            
            // 先に fetchTags を呼び出します
            self.fetchTags(from: userRef) { (fetchedTags, error) in
                if let error = error {
                    print("Error fetching tags: \(error)")
                    completion(nil)
                    return
                }
                
                // fetchTags が完了してから fetchStatuses を呼び出します
                self.fetchStatuses(from: userRef, with: fetchedTags) { (fetchedStatuses, error) in
                    if let error = error {
                        print("Error fetching statuses: \(error)")
                        completion(nil)
                        return
                    }
                    
                    let appData = AppData(userid: userId,
                                          username: userData.name,
                                          statuses: fetchedStatuses,
                                          tags: fetchedTags,
                                          createdAt: userData.createdAt)
                    print("Fetched all app data, completing.")
                    completion(appData)
                }
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
            
            let taskDispatchGroup = DispatchGroup()  // 新しい DispatchGroup
            var goals: [Goal] = []
            
            for goalDoc in goalDocuments {
                taskDispatchGroup.enter()  // DispatchGroup に enter
                
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
                    
                    let goalRef = statusRef.collection("Goals").document(goalDoc.documentID)
                    self.fetchTasks(from: goalRef, with: tags) { (fetchedTasks, error) in
                        if let error = error {
                            print("Error fetching tasks for goal \(goalName): \(error)")  // Log the error
                        } else {
                            print("Fetched \(fetchedTasks.count) tasks for goal \(goalName)")  // Log the number of fetched tasks for this goal
                        }
                        
                        let goal = Goal(id: goalDoc.documentID,
                                        name: goalName,
                                        description: goalDescription,
                                        tasks: fetchedTasks,
                                        dueDate: goalDueDate,
                                        isStarred: goalIsStarred,
                                        tags: goalTags,
                                        thumbnail: goalThumbnail,
                                        createdAt: goalCreatedAt,
                                        updatedAt: goalUpdatedAt)
                        
                        goals.append(goal)
                        print("Processed goal: \(goalName)")  // Log each processed goal
                        
                        taskDispatchGroup.leave()  // DispatchGroup から leave
                    }
                } else {
                    // If the goal data is invalid, leave the dispatch group to not block the completion
                    taskDispatchGroup.leave()
                }
            }
            
            taskDispatchGroup.notify(queue: .main) {  // すべての fetchTasks が完了したら
                completion(goals, nil)
            }
        }
    }
    
    func fetchTasks(from goalRef: DocumentReference, with tags: [Tag], completion: @escaping ([TasQuestTask], Error?) -> Void) {
        print("Fetching tasks from goal \(goalRef.documentID)...")  // Log the start
        goalRef.collection("TasQuestTasks").getDocuments { taskSnapshot, error in
            if let error = error {
                print("Failed to fetch tasks: \(error)")  // Log the error
                completion([], error)
                return
            }
            
            guard let taskDocuments = taskSnapshot?.documents else {
                print("Task snapshot is nil.")  // Log if snapshot is nil
                completion([], nil)
                return
            }
            
            print("Fetched \(taskDocuments.count) tasks.")  // Log the number of fetched tasks
            
            var tasks: [TasQuestTask] = []
            let taskDispatchGroup = DispatchGroup()  // Create a DispatchGroup
            
            for taskDoc in taskDocuments {
                print("taskDocuments: \(taskDocuments)")
                taskDispatchGroup.enter()  // Enter the DispatchGroup
                let taskData = taskDoc.data()
                print("Raw task data: \(taskData)")
                let taskIsVisible = (taskData["isVisible"] as? Int) == 1

                if let taskName = taskData["name"] as? String,
                   let taskDescription = taskData["description"] as? String,
                   let taskDueDate = taskData["dueDate"] as? String,
                   let taskMaxHealth = taskData["maxHealth"] as? Float,
                   let taskCurrentHealth = taskData["currentHealth"] as? Float,
                   let taskCreatedAt = taskData["createdAt"] as? String,
                   let taskUpdatedAt = taskData["updatedAt"] as? String {
                    
                    let taskTagsIDs = taskData["Tags"] as? [String] ?? []
                    print("Task Tags IDs: \(taskTagsIDs)")  // デバッグ用
                    print("Available Tags IDs: \(tags.map { $0.id })")  // デバッグ用
                    
                    let taskTags = tags.filter { taskTagsIDs.contains($0.id) }
                    print("Filtered Task Tags: \(taskTags)")  // デバッグ用
                    
                    let task = TasQuestTask(id: taskDoc.documentID,
                                            name: taskName,
                                            description: taskDescription,
                                            dueDate: taskDueDate,
                                            maxHealth: taskMaxHealth,
                                            currentHealth: taskCurrentHealth,
                                            tags: taskTags,
                                            isVisible: taskIsVisible,
                                            createdAt: taskCreatedAt,
                                            updatedAt: taskUpdatedAt)  // タグ情報を追加
                    tasks.append(task)
                    print("Processed task: \(taskName)")  // Log each processed task
                } else {
                    print("Skipping task due to incomplete data: \(taskData)")
                }
                taskDispatchGroup.leave()  // Leave the DispatchGroup when done processing this task
                
            }
            taskDispatchGroup.notify(queue: .main) {
                // This block will be executed once all tasks have been processed
                completion(tasks, nil)
            }
        }
    }
}
