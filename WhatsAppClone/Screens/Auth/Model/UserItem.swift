//
//  UserItem.swift
//  WhatsAppClone
//
//  Created by Jeremy Koo on 5/9/24.
//

import Foundation

struct UserItem: Identifiable, Hashable, Decodable {
    let uid: String
    let username: String
    let email: String
    var bio: String? = nil
    var profileImageUrl: String? = nil
    
    var id: String {
        return uid
    }
    
    var bioUnwrapped: String {
        return bio ?? "Hey there! I am using WhatsApp."
    }
    
    static let placeholder = UserItem(uid: "1", username: "Osas", email: "askswiftskool@gmail.com")
    
    static let placeholders: [UserItem] = [
        .init(uid: "1", username: "Jeremy", email: "jeremy@example.com"),
        .init(uid: "2", username: "JohnDoe", email: "johndoe@example.com", bio: "Hello, I'm John."),
        .init(uid: "3", username: "JaneSmith", email: "janesmith@example.com", bio: "Passionate about coding."),
        .init(uid: "4", username: "Alice", email: "alice@example.com", bio: "Tech enthusiast"),
        .init(uid: "5", username: "Bob", email: "bob@example.com", bio: "Lover of nature."),
        .init(uid: "6", username: "Ella", email: "ella@example.com", bio: "Dreamer."),
        .init(uid: "7", username: "Michael", email: "michael@example.com"),
        .init(uid: "8", username: "Sophie", email: "sophie@example.com", bio: "Coffee addict ☕️"),
        .init(uid: "9", username: "David", email: "david@example.com", bio: "Music lover."),
        .init(uid: "10", username: "Emily", email: "emily@example.com", bio: "Travel enthusiast.")
    ]
}

extension UserItem {
    init(dictionary: [String: Any]) {
        self.uid = dictionary[.uid] as? String ?? ""
        self.username = dictionary[.username] as? String ?? ""
        self.email = dictionary[.email] as? String ?? ""
        self.bio = dictionary[.bio] as? String ?? nil
        self.profileImageUrl = dictionary[.profileImageUrl] as? String ?? nil
    }
}

extension String {
    static let uid = "uid"
    static let username = "username"
    static let email = "email"
    static let bio = "bio"
    static let profileImageUrl = "profileImageUrl"
}
