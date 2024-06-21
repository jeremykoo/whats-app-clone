//
//  UIApplication+Extensions.swift
//  WhatsAppClone
//
//  Created by Jeremy Koo on 6/12/24.
//

import Foundation
import UIKit

extension UIApplication {
    static func dismissKeyboard() {
        UIApplication
            .shared
            .sendAction(#selector(UIApplication.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
