//
//  PrivacyPermissionView.swift
//  Woof
//
//  Created by Mike Choi on 2/22/22.
//

import Foundation
import SwiftUI
import LocalAuthentication

// TODO: merge the old auth stuff with this
final class LocalAuthViewModel: ObservableObject {
    
    var biometricsType: String
    var biometricsIconName: String
    
    init() {
        switch LAContext().biometryType {
            case .faceID:
                biometricsIconName = "faceid"
                biometricsType = "Face ID"
            case .touchID:
                biometricsIconName = "touchid"
                biometricsType = "Touch ID"
            case .none:
                biometricsIconName = "touchid"
                biometricsType = "Touch ID"
            @unknown default:
                biometricsType = ""
                biometricsIconName = "questionmark"
        }
    }
    
    func askForPermission(completion: @escaping (Bool) -> ()) {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Secure your wallet with biometrics"
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { ok, _ in
                DispatchQueue.main.async {
                    completion(ok)
                }
            }
        } else {
            DispatchQueue.main.async {
                completion(false)
            }
        }
    }
}

struct PrivacyPermissionView: View {
    
    @State var goToNextView = false
    @StateObject var authViewModel = LocalAuthViewModel()
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
                    
                    Image(systemName: authViewModel.biometricsIconName)
                        .resizable()
                        .frame(width: 70, height: 70)
                        .foregroundColor(.blue)
                }
                .padding(.bottom, 20)
                
                Text("Secure your wallet with \(authViewModel.biometricsType)")
                    .font(.system(size: 22, weight: .semibold))
                    .multilineTextAlignment(.center)
                
                Text("Enable permissions to use biometrics to protect your JPEGS")
                    .font(.system(size: 17, weight: .regular))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                
                Spacer()
                
                Button {
                    authViewModel.askForPermission { ok in
                        didCompleteOnboarding = ok
                    }
                } label: {
                    Text("Use \(authViewModel.biometricsType)")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(Color(uiColor: .systemBackground))
                        .modifier(PrimaryButtonModifier(backgroundColor: .label))
                }
                
                Button {
                    didCompleteOnboarding = true
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

