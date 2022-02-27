//
//  PrivacyPermissionView.swift
//  Woof
//
//  Created by Mike Choi on 2/22/22.
//

import Foundation
import SwiftUI
import LocalAuthentication

final class LocalAuthModel: ObservableObject {
    @Published var isAuthenticated = false
    @Published var isWaitingAuthentication = false
    @Published var isBiometricsEnabled: Bool
    
    var biometricsType: String
    var biometricsIconName: String
    
    let context = LAContext()
    
    init() {
        switch LAContext().biometryType {
            case .faceID:
                biometricsIconName = "faceid"
                biometricsType = "Face ID"
            case .touchID:
                biometricsIconName = "touchid"
                biometricsType = "Touch ID"
            case .none:
                biometricsIconName = ""
                biometricsType = ""
            @unknown default:
                biometricsType = ""
                biometricsIconName = "questionmark"
        }
        
        isBiometricsEnabled = context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
    }
    
    func authenticate(completion: ((Bool) -> ())? = nil) {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Secure your wallet with biometrics"
            isWaitingAuthentication = false
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { ok, _ in
                DispatchQueue.main.async {
                    self.isAuthenticated = ok
                    
                    if !ok {
                        self.isWaitingAuthentication = true
                    }
                   
                    self.evaluateBiometricsAvailability()
                    completion?(ok)
                }
            }
        } else {
            DispatchQueue.main.async {
                self.evaluateBiometricsAvailability()
                completion?(false)
            }
        }
    }
    
    func evaluateBiometricsAvailability() {
        isBiometricsEnabled = context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
    }
}

struct PrivacyPermissionView: View {
    
    @State var goToNextView = false
    @EnvironmentObject var authViewModel: LocalAuthModel
    @AppStorage("did.complete.onboarding") var didCompleteOnboarding = false
    
    var body: some View {
        HStack(alignment: .center) {
            VStack(spacing: 20) {
                ZStack {
                    Circle()
                        .foregroundColor(.blue)
                        .opacity(0.15)
                        .frame(width: 250, height: 250)
                    
                    Circle()
                        .foregroundColor(.blue)
                        .opacity(0.2)
                        .frame(width: 200, height: 200)
                    
                    Circle()
                        .foregroundColor(.blue)
                        .opacity(0.25)
                        .frame(width: 150, height: 150)
                    
                    Image(systemName: "lock.shield.fill")
                        .font(.system(size: 80, weight: .regular))
                        .foregroundColor(.blue)
                }
                .padding(.bottom, 20)
                
                Text("Secure your wallet with biometrics")
                    .font(.system(size: 22, weight: .semibold))
                    .multilineTextAlignment(.center)
                
                Text("Enable permissions to use biometrics to protect your JPEGS")
                    .font(.system(size: 17, weight: .regular))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                
                Spacer()
                
                Button {
                    authViewModel.authenticate { ok in
                        didCompleteOnboarding = true
                    }
                } label: {
                    Text("Secure your wallet")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(Color(uiColor: .systemBackground))
                        .modifier(PrimaryButtonModifier(backgroundColor: .label))
                }
                
                Button {
//                    didCompleteOnboarding = true
                } label: {
                    Text("Don't secure my wallet")
                        .font(.system(size: 18, weight: .medium))
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        .background(Color.tertiaryBackground)
    }
}

struct PrivacyPermissionView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            PrivacyPermissionView()
        }
        
        PrivacyPermissionView()
            .preferredColorScheme(.dark)
    }
}

