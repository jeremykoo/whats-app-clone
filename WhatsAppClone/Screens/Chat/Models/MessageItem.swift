//
//  MessageItem.swift
//  WhatsAppClone
//
//  Created by Jeremy Koo on 5/7/24.
//

import Foundation
import SwiftUI
import Firebase

struct MessageItem: Identifiable {
    let id: String
    let isGroupChat: Bool
    let text: String
    let type: MessageType
    let ownerUid: String
    let timeStamp: Date
    var sender: UserItem?
    let thumbnailUrl: String?
    var thumbnailHeight: CGFloat?
    var thumbnailWidth: CGFloat?
    var videoURL: String?
    var audioURL: String?
    var audioDuration: TimeInterval?
    
    var direction: MessageDirection {
        return ownerUid == Auth.auth().currentUser?.uid ? .sent : .received
    }
    
    static let sentPlaceholder = MessageItem(id: UUID().uuidString, isGroupChat: true, text: "Holy Spaghetti", type: .text, ownerUid: "1", timeStamp: Date(), thumbnailUrl: nil)
    static let receivedPlaceholder = MessageItem(id: UUID().uuidString, isGroupChat: false, text: "Hey dude what's up?", type: .text, ownerUid: "2", timeStamp: Date(), thumbnailUrl: nil)
    
    var alignment: Alignment {
        return direction == .received ? .leading : .trailing
    }
    
    var horizontalAlignment: HorizontalAlignment {
        return direction == .received ? .leading : .trailing
    }
    
    var backgroundColor: Color {
        return direction == .sent ? .bubbleGreen : .bubbleWhite
    }
    
    var showGroupPartnerInfo: Bool {
        return isGroupChat && direction == .received
    }
    
    var leadingPadding: CGFloat {
        return direction == .received ? 0 : horizontalPadding
    }
    
    var trailingPadding: CGFloat {
        return direction == .received ? horizontalPadding : 0
    }
    
    private let horizontalPadding: CGFloat = 25
    
    var imageSize: CGSize {
        let photoWidth = thumbnailWidth ?? 0
        let photoHeight = thumbnailHeight ?? 0
        let imageHeight = CGFloat(photoHeight / photoWidth * imageWidth)
        return CGSize(width: imageWidth, height: imageHeight)
    }
    
    var imageWidth: CGFloat {
        let photoWidth = (UIWindowScene.current?.screenWidth ?? 0) / 1.5
        return photoWidth
    }
    
    static let stubMessages: [MessageItem] = [
        .init(id: UUID().uuidString, isGroupChat: false, text: "Hi There", type: .text, ownerUid: "3", timeStamp: Date(), thumbnailUrl: nil),
        .init(id: UUID().uuidString, isGroupChat: true, text: "Check out this Photo", type: .photo, ownerUid: "4", timeStamp: Date(), thumbnailUrl: nil),
        .init(id: UUID().uuidString, isGroupChat: false, text: "Play out this Video", type: .video, ownerUid: "5", timeStamp: Date(), thumbnailUrl: nil),
        .init(id: UUID().uuidString, isGroupChat: false, text: "", type: .audio, ownerUid: "6", timeStamp: Date(), thumbnailUrl: nil)
    ]
}

extension MessageItem {
    init(id: String, isGroupChat: Bool, dict: [String: Any]) {
        self.id = id
        self.isGroupChat = isGroupChat
        self.text = dict[.text] as? String ?? ""
        let type = dict[.type] as? String ?? "text"
        self.type = MessageType(type) ?? .text
        self.ownerUid = dict[.ownerUid] as? String ?? ""
        let timeInterval = dict[.timeStamp] as? TimeInterval ?? 0
        self.timeStamp = Date(timeIntervalSince1970: timeInterval)
        self.thumbnailUrl = dict[.thumbnailUrl] as? String ?? nil
        self.thumbnailWidth = dict[.thumbnailWidth] as? CGFloat ?? nil
        self.thumbnailHeight = dict[.thumbnailHeight] as? CGFloat ?? nil
        self.videoURL = dict[.videoURL] as? String? ?? nil
        self.audioURL = dict[.audioURL] as? String? ?? nil
        self.audioDuration = dict[.audioDuration] as? TimeInterval ?? nil
    }
}

extension String {
    static let `type` = "type"
    static let timeStamp = "timeStamp"
    static let ownerUid = "ownerUid"
    static let text = "text"
    static let thumbnailWidth = "thumbnailWidth"
    static let thumbnailHeight = "thumbnailHeight"
    static let videoURL = "videoURL"
    static let audioURL = "audioURL"
    static let audioDuration = "audioDuration"
}
