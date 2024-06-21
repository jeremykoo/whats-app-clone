//
//  String+Extensions.swift
//  WhatsAppClone
//
//  Created by Jeremy Koo on 5/11/24.
//

import Foundation

extension String {
    var isEmptyOrWhiteSpace: Bool { return trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
}
