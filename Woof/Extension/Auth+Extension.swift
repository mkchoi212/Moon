//
//  Auth+Extension.swift
//  Woof
//
//  Created by Mike Choi on 12/19/21.
//

import LocalAuthentication

extension LAContext {
    var biometricType: LABiometryType {
        var error: NSError?

        guard self.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
            return .none
        }
    
        return self.biometryType
    }
}
