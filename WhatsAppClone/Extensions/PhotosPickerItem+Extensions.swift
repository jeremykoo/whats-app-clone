//
//  PhotosPickerItem+Extensions.swift
//  WhatsAppClone
//
//  Created by Jeremy Koo on 5/28/24.
//

import Foundation
import PhotosUI
import SwiftUI

extension PhotosPickerItem {
    var isVideo: Bool {
        let videoUTType: [UTType] = [
            .avi,
            .video,
            .mpeg2Video,
            .mpeg4Movie,
            .movie,
            .quickTimeMovie,
            .audiovisualContent,
            .mpeg,
            .appleProtectedMPEG4Video
        ]
        return videoUTType.contains(where: supportedContentTypes.contains)
    }
}
