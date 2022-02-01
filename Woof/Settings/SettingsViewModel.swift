//
//  SettingsViewModel.swift
//  Woof
//
//  Created by Mike Choi on 1/31/22.
//

import Foundation
import LocalAuthentication

final class SettingsViewModel: ObservableObject {
    @Published var isAuthenticated = false
    @Published var isWaitingAuthentication = false
    
    let context = LAContext()
    
    var isBiometricsEnabled: Bool {
        context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
    }
    
    func authenticate(completion: ((Bool) -> ())? = nil) {
        var error: NSError?

        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Protect your wallet via biometrics"

            isWaitingAuthentication = false
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                DispatchQueue.main.async {
                    self.isAuthenticated = success
                    
                    if !success {
                        self.isWaitingAuthentication = true
                    }
                    
                    completion?(success)
                }
            }
        }
    }
}
