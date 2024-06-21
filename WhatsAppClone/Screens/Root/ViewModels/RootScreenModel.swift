//
//  RootScreenModel.swift
//  WhatsAppClone
//
//  Created by Jeremy Koo on 5/8/24.
//

import Foundation
import Combine

final class RootScreenModel: ObservableObject {
    
    @Published private(set) var authState = AuthState.pending
    private var cancellable: AnyCancellable?
    
    init() {
        cancellable = AuthManager.shared.authState.receive(on: DispatchQueue.main)
            .sink {[weak self] latestAuthState in
                self?.authState = latestAuthState
            }
        
//        AuthManager.testAccounts.forEach { email in
//            registerTestAccount(with: email)
//        }
    }
    
    // ONE TIME USE TO CREATE TEST ACCOUNTS
//    private func registerTestAccount(with email: String) {
//        Task {
//            let username = email.replacingOccurrences(of: "@test.com", with: "")
//            try? await AuthManager.shared.createAccount(for: username, with: email, and: "12345678")
//        }
//    }
}
