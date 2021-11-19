////
////  FirebaseService.swift
////  AutismLove
////
////  Created by Samuel Krisna on 06/05/21.
////
//
//import Foundation
//import MessageKit
//
//final class FirebaseService {
//
//    static let shared = FirebaseService()
//    private let database = Database.database().reference()
//
////    func safeEmail(email: String) -> String {
////        var safeEmail = email.replacingOccurrences(of: ".", with: "-")
////        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
////
////        return safeEmail
////    }
//
//    func register(email: String, fullname: String) {
////        let chatAppUser = ChatAppUser(email: email, fullname: fullname, uid: (Globals.userData?.id)!)
////
////        insertUser(user: chatAppUser)
//    }
//}
//
//// Mark: - Account management
//extension FirebaseService {
//    public func userExists(userId: String, completion: @escaping((Bool) -> Void)) {
//        database.child(userId).observeSingleEvent(of: .value) { snapshot in
//            guard snapshot.value as? String != nil else {
//                completion(false)
//                return
//            }
//            completion(true)
//        }
//    }
//
//    // Insert new user to database
//    public func insertUser(email: String, fullname: String) {
////        let chatAppUser = ChatAppUser(email: email, fullname: fullname, uid: (Globals.userData?.id)!)
//        let uid:String = (Globals.userData?.id!)!
//
//        userExists(userId: uid) { [self] isUserExists in
//            print("Is User Exists : \(isUserExists)")
//            if !isUserExists {
//                database.child(uid).setValue([
//                    "fullname": fullname
//                ])
////                { [self] error, _ in
////                    guard error == nil else { return }
//
////                    database.child("users").observeSingleEvent(of: .value) { snapshot in
////                        if var usersCollection = snapshot.value as? [[String: String]] {
////                            // Append to user dictionary
////                            print("Append to user dictionary")
////                            let newElement = [
////                                "email": safeEmail,
////                                "fullname": user.fullname,
////                                "uid": user.uid
////                            ]
////
////                            usersCollection.append(newElement)
////
////                            database.child("users").setValue(usersCollection) { error, _ in
////                                guard error == nil else { return }
////                            }
////                        } else {
////                            // Create array
////                            print("Create array")
////                            let newCollection: [[String: String]] = [
////                                [
////                                    "email": safeEmail,
////                                    "fullname": user.fullname,
////                                    "uid": user.uid
////                                ]
////                            ]
////
////                            database.child("users").setValue(newCollection) { error, _ in
////                                guard error == nil else { return }
////                            }
////                        }
////                    }
////                }
//            } else {
//                print("User already exists!")
//            }
//        }
//    }
//}
//
//// Mark: - Sending message
//extension FirebaseService {
//    func createEmptyNewConversation(otherUid: String, messageId: String, completion: @escaping (Bool) -> Void) {
//        let uid:String = (Globals.userData?.id!)!
//
//        let ref = database.child(uid)
//        ref.observeSingleEvent(of: .value) { snapshot in
////            let conversationId = "conversation_\(messageId)"
//
//            // Update recipient conversation entry
//            self.database.child("\(otherUid)/conversations").observeSingleEvent(of: .value) { snapshot in
//                if (snapshot.value as? [[String: Any]]) == nil {
//                    // Create
//                    self.database.child("\(otherUid)/conversations").setValue(["null"])
//                }
//            }
//
////            self.finishCreatingConversation(name: name,
////                                            conversationId: conversationId,
////                                            firstMessage: firstMessage,
////                                            completion: completion)
//        }
//    }
//
//    func createNewConversation(otherUid: String, name: String, firstMessage: Message, completion: @escaping (Bool) -> Void) {
//        let uid:String = (Globals.userData?.id!)!
//
//        let ref = database.child(uid)
//        ref.observeSingleEvent(of: .value) { snapshot in
//            guard var userNode = snapshot.value as? [String: Any] else {
//                completion(false)
//                print("User not found")
//                return
//            }
//
//            let conversationId = "conversation_\(firstMessage.messageId)"
//            let dateString = GlobalHelper.dateFormatter.string(from: firstMessage.sentDate)
//
//            var message = ""
//            switch firstMessage.kind {
//            case .text(let messageText):
//                message = messageText
//            case .attributedText(_):
//                break
//            case .photo(_):
//                break
//            case .video(_):
//                break
//            case .location(_):
//                break
//            case .emoji(_):
//                break
//            case .audio(_):
//                break
//            case .contact(_):
//                break
//            case .linkPreview(_):
//                break
//            case .custom(_):
//                break
//            }
//
//            let newConversationData:[String: Any] = [
//                "id": conversationId,
//                "other_user_id": otherUid,
//                "name": name,
//                "latest_message": [
//                    "date": dateString,
//                    "message": message,
//                    "is_read": false
//                ]
//            ]
//
//            let recipient_newConversationData: [String: Any] = [
//                "id": conversationId,
//                "other_user_email": uid,
//                "name": name,
//                "latest_message": [
//                    "date": dateString,
//                    "message": message,
//                    "is_read": false
//                ]
//            ]
//
//            // Update recipient conversation entry
//            self.database.child("\(otherUid)/conversations").observeSingleEvent(of: .value) { snapshot in
//                if var conversations = snapshot.value as? [[String: Any]] {
//                    // Append
//                    conversations.append(recipient_newConversationData)
//                    self.database.child("\(otherUid)/conversations").setValue(conversations)
//                } else {
//                    // Create
//                    self.database.child("\(otherUid)/conversations").setValue([recipient_newConversationData])
//                }
//            }
//
//            // Update current user conversation entry
//            if var conversations = userNode["conversations"] as? [[String: Any]] {
//                print("Update current user conversation entry")
//                conversations.append(newConversationData)
//                userNode["conversations"] = conversations
//
//                ref.setValue(userNode) { error, _ in
//                    guard error == nil else {
//                        completion(false)
//                        return
//                    }
//
//                    self.finishCreatingConversation(name: name,
//                                                    conversationId: conversationId,
//                                                    firstMessage: firstMessage,
//                                                    completion: completion)
//                }
//            } else {
//                // Conversation array does not exixts
//                print("Conversation array does not exixts")
//
//                // Create it
//                userNode["conversations"] = [
//                    newConversationData
//                ]
//
//                ref.setValue(userNode) { error, _ in
//                    guard error == nil else {
//                        completion(false)
//                        return
//                    }
//
//                    self.finishCreatingConversation(name: name,
//                                                    conversationId: conversationId,
//                                                    firstMessage: firstMessage,
//                                                    completion: completion)
//                }
//            }
//        }
//    }
//
//    func finishCreatingConversation(name : String, conversationId: String, firstMessage: Message, completion: @escaping(Bool) -> Void) {
//        let currentUserEmail = "60a4f076d8b805001502af6a"
//        let dateString = GlobalHelper.dateFormatter.string(from: firstMessage.sentDate)
//
//        var message = ""
//        switch firstMessage.kind {
//        case .text(let messageText):
//            message = messageText
//        case .attributedText(_):
//            break
//        case .photo(_):
//            break
//        case .video(_):
//            break
//        case .location(_):
//            break
//        case .emoji(_):
//            break
//        case .audio(_):
//            break
//        case .contact(_):
//            break
//        case .linkPreview(_):
//            break
//        case .custom(_):
//            break
//        }
//
//        let collectionMessage: [String: Any] = [
//            "id": firstMessage.messageId,
//            "type": firstMessage.kind.messageKindString,
//            "content": message,
//            "date": dateString,
//            "sender_email": currentUserEmail,
//            "is_read": false,
//            "name": name
//        ]
//
//        let value: [String: Any] = [
//            "messages": [
//                collectionMessage
//            ]
//        ]
//
//        database.child("\(conversationId)").setValue(value) { error, _ in
//            guard error == nil else {
//                completion(false)
//                return
//            }
//            completion(true)
//        }
//    }
//
//    public func getAllConversations(email: String, completion: @escaping (Result<[Conversation], Error>) -> Void) {
//        database.child("\(email)/conversations").observe(.value, with: { snapshot in
//            guard let value = snapshot.value as? [[String: Any]] else{
//                return
//            }
//
//            let conversations: [Conversation] = value.compactMap({ dictionary in
//
//                let conversationId = dictionary["id"]
//                let name = dictionary["name"]
//                let otherUserEmail = dictionary["other_user_email"]
//                let latestMessage = dictionary["latest_message"] as? [String: Any]
//                let date = latestMessage!["date"] as? String
//                let message = latestMessage!["message"] as? String
//                let isRead = latestMessage!["is_read"] as? Bool
//
//                let latestMmessageObject = LatestMessage(date: date!,
//                                                         text: message!,
//                                                         isRead: isRead!)
//
//                return Conversation(id: conversationId! as! String,
//                                    name: name! as! String,
//                                    otherUserEmail: otherUserEmail! as! String,
//                                    latestMessage: latestMmessageObject)
//            })
//
//            completion(.success(conversations))
//        })
//    }
//
//    public func getAllMessagesForConversation(with id: String, completion: @escaping (Result<[Message], Error>) -> Void) {
//        database.child("\(id)/messages").observe(.value, with: { snapshot in
//            guard let value = snapshot.value as? [[String: Any]] else{
//                return
//            }
//
//            let messages: [Message] = value.compactMap({ dictionary in
//                let name = dictionary["name"] as? String
//                let isRead = dictionary["is_read"] as? Bool
//                let messageID = dictionary["id"] as? String
//                let content = dictionary["content"] as? String
//                let senderEmail = dictionary["sender_email"] as? String
//                let type = dictionary["type"] as? String
//                let dateString = dictionary["date"] as? String
//                var date = GlobalHelper.dateFormatter.date(from: dateString!)
//
//                if date == nil {
//                    date = Date()
//                }
//
//                var kind: MessageKind?
//
//                if type == "photo" {
//                    // photo
//                    guard let imageUrl = URL(string: content!),
//                          let placeHolder = UIImage(systemName: "plus") else {
//                        return nil
//                    }
//                    let media = Media(url: imageUrl,
//                                      image: nil,
//                                      placeholderImage: placeHolder,
//                                      size: CGSize(width: 300, height: 300))
//                    kind = .photo(media)
//                } else {
//                    kind = .text(content!)
//                }
//
//                guard let finalKind = kind else {
//                    return nil
//                }
//
//                let sender = Sender(senderId: senderEmail!,
//                                    displayName: name!)
//
//                return Message(sender: sender,
//                               messageId: messageID!,
//                               sentDate: date!,
//                               kind: finalKind)
//            })
//
//            completion(.success(messages))
//        })
//    }
//
//    func sendMessage(conversationId: String, otherUserEmail: String, name: String, newMessage: Message, completion: @escaping(Bool) -> Void) {
//        let currentUserEmail = "jersamkris-gmail-com"
//        let otherUserEmail = "other-gmail-com"
//
//        database.child("\(conversationId)/messages").observeSingleEvent(of: .value) { [self] snapshot in
//            guard var currentMessages = snapshot.value as? [[String: Any]] else {
//                completion(false)
//                return
//            }
//
//            let messageDate = newMessage.sentDate
//            let dateString = GlobalHelper.dateFormatter.string(from: messageDate)
//
//            var message = ""
//            switch newMessage.kind {
//            case .text(let messageText):
//                message = messageText
//            case .attributedText(_):
//                break
//            case .photo(let mediaItem):
//                if let targetUrlString = mediaItem.url?.absoluteString {
//                    message = targetUrlString
//                }
//                break
//            case .video:
//                break
//            case .location:
//                break
//            case .emoji(_):
//                break
//            case .audio(_):
//                break
//            case .contact(_):
//                break
//            case .custom(_):
//                break
//            case .linkPreview(_):
//                break
//            }
//
//            let newMessageEntry: [String: Any] = [
//                "id": newMessage.messageId,
//                "type": newMessage.kind.messageKindString,
//                "content": message,
//                "date": dateString,
//                "sender_email": currentUserEmail,
//                "is_read": false,
//                "name": name
//            ]
//
//            currentMessages.append(newMessageEntry)
//
//            database.child("\(conversationId)/messages").setValue(currentMessages) { error, _ in
//                guard error == nil else {
//                    completion(false)
//                    return
//                }
//
//                database.child("\(currentUserEmail)/conversations").observeSingleEvent(of: .value, with: { snapshot in
//                    var databaseEntryConversations = [[String: Any]]()
//                    let updatedValue: [String: Any] = [
//                        "date": dateString,
//                        "is_read": false,
//                        "message": message
//                    ]
//
//                    if var currentUserConversations = snapshot.value as? [[String: Any]] {
//                        var targetConversation: [String: Any]?
//                        var position = 0
//
//                        for conversationDictionary in currentUserConversations {
//                            if let currentId = conversationDictionary["id"] as? String, currentId == conversationId {
//                                targetConversation = conversationDictionary
//                                break
//                            }
//                            position += 1
//                        }
//
//                        if var targetConversation = targetConversation {
//                            targetConversation["latest_message"] = updatedValue
//                            currentUserConversations[position] = targetConversation
//                            databaseEntryConversations = currentUserConversations
//                        } else {
//                            let newConversationData: [String: Any] = [
//                                "id": conversationId,
//                                "other_user_email": otherUserEmail,
//                                "name": name,
//                                "latest_message": updatedValue
//                            ]
//                            currentUserConversations.append(newConversationData)
//                            databaseEntryConversations = currentUserConversations
//                        }
//                    } else {
//                        let newConversationData: [String: Any] = [
//                            "id": conversationId,
//                            "other_user_email": otherUserEmail,
//                            "name": name,
//                            "latest_message": updatedValue
//                        ]
//                        databaseEntryConversations = [
//                            newConversationData
//                        ]
//                    }
//
//                    database.child("\(currentUserEmail)/conversations").setValue(databaseEntryConversations, withCompletionBlock: { error, _ in
//                        guard error == nil else {
//                            completion(false)
//                            return
//                        }
//
//
//                        // Update latest message for recipient user
//                        database.child("\(otherUserEmail)/conversations").observeSingleEvent(of: .value, with: { snapshot in
//                            let updatedValue: [String: Any] = [
//                                "date": dateString,
//                                "is_read": false,
//                                "message": message
//                            ]
//
//                            var databaseEntryConversations = [[String: Any]]()
//
//                            guard let currentName = UserDefaults.standard.value(forKey: "name") as? String else {
//                                return
//                            }
//
//                            if var otherUserConversations = snapshot.value as? [[String: Any]] {
//                                var targetConversation: [String: Any]?
//                                var position = 0
//
//                                for conversationDictionary in otherUserConversations {
//                                    if let currentId = conversationDictionary["id"] as? String, currentId == conversationId {
//                                        targetConversation = conversationDictionary
//                                        break
//                                    }
//                                    position += 1
//                                }
//
//                                if var targetConversation = targetConversation {
//                                    targetConversation["latest_message"] = updatedValue
//                                    otherUserConversations[position] = targetConversation
//                                    databaseEntryConversations = otherUserConversations
//                                } else {
//                                    // failed to find in current colleciton
//                                    let newConversationData: [String: Any] = [
//                                        "id": conversationId,
//                                        "other_user_email": otherUserEmail,
//                                        "name": currentName,
//                                        "latest_message": updatedValue
//                                    ]
//                                    otherUserConversations.append(newConversationData)
//                                    databaseEntryConversations = otherUserConversations
//                                }
//                            } else {
//                                // current collection does not exist
//                                let newConversationData: [String: Any] = [
//                                    "id": conversationId,
//                                    "other_user_email": otherUserEmail,
//                                    "name": currentName,
//                                    "latest_message": updatedValue
//                                ]
//                                databaseEntryConversations = [
//                                    newConversationData
//                                ]
//                            }
//
//                            database.child("\(otherUserEmail)/conversations").setValue(databaseEntryConversations, withCompletionBlock: { error, _ in
//                                guard error == nil else {
//                                    completion(false)
//                                    return
//                                }
//
//                                completion(true)
//                            })
//                        })
//                    })
//                })
//            }
//        }
//    }
//}
