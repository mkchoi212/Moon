//
//  SettingsView.swift
//  Woof
//
//  Created by Mike Choi on 12/5/21.
//

import SwiftUI
import LocalAuthentication

enum Setting: String, CaseIterable, Identifiable {
    case myWallets = "My Wallets"
    case biometrics = "Require"
    case about = "About Moon"
    case rate = "Rate Moon"
    case followOnTwitter = "Follow us on Twitter"
    case feedback = "Feedback and support"
    
    var id: String {
        rawValue
    }
    
    var description: String {
        switch self {
            case .biometrics:
                let type = LAContext().biometricType
                if type == .none {
                    return "Biometrics unavailable"
                } else {
                    return "Require \(type == .faceID ? "FaceID" : "TouchID")"
                }
            default:
                return rawValue
        }
    }
    
    var image: Image {
        switch self {
            case .myWallets:
                return Image(systemName: "wallet.pass.fill")
            case .biometrics:
                let type = LAContext().biometricType
                if type == .none {
                    return Image(systemName: "xmark")
                } else {
                    return Image(systemName: type == .faceID ? "faceid" : "touchid")
                }
            case .about:
                return Image(systemName: "info")
            case .rate:
                return Image(systemName: "star.fill")
            case .followOnTwitter:
                return Image("bird")
            case .feedback:
                return Image(systemName: "mail.fill")
        }
    }
    
    var backgroundColor: UIColor {
        switch self {
            case .myWallets:
                return .systemBlue
            case .biometrics:
                return .systemGreen
            case .about:
                return .systemPurple
            case .rate:
                return .systemOrange
            case .followOnTwitter:
                return .black
            case .feedback:
                return .lightGray
        }
    }
}

struct SettingRow: View {
    let setting: Setting
    
    var body: some View {
        HStack(spacing: 12) {
            setting.image
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding(6)
                .frame(width: 28, height: 28)
                .foregroundColor(Color.white)
                .background(Color(setting.backgroundColor))
                .clipShape(RoundedRectangle(cornerRadius: 8))
            
            Text(setting.description)
        }
    }
}

struct SettingsExtraSection: View {
    @State var mailData = ComposeMailData(subject: "Moon Feedback - v\(Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "unknown")",
                                          recipients: ["mkchoi212@icloud.com"],
                                          message: "",
                                          attachments: nil)
    @State var showFeedbackMailModal = false
    @State var showAboutModal = false
    @State var rateButtonTapped = false
    @State var openTwitter = false
    @Binding var toastPayload: ToastPayload?
    
    var body: some View {
        Section {
            Button {
                showFeedbackMailModal = true
            } label: {
                SettingRow(setting: .feedback)
            }
            
            SettingRow(setting: .about)
            SettingRow(setting: .rate)
            
            Button {
                UIApplication.shared.open(URL(string: "twitter://twitter://user?screen_name=guard_if")!, options: [:])
            } label : {
                SettingRow(setting: .followOnTwitter)
            }
        }
        .sheet(isPresented: $showFeedbackMailModal) {
            MailView(data: $mailData) { result in
                if case .success(let result) = result, result == .sent {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        toastPayload = ToastPayload(message: "Feedback sent successfully")
                    }
                }
            }
        }
        .sheet(isPresented: $showAboutModal) {
        }
    }
}

struct SettingsView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @State var showToast = false
    @State var toastPayload: ToastPayload?
    @State var biometricsEnabled = false
    @EnvironmentObject var authModel: LocalAuthModel
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    NavigationLink {
                        SettingsWalletListView()
                            .navigationTitle("Wallets")
                            .navigationBarTitleDisplayMode(.inline)
                    } label: {
                        SettingRow(setting: .myWallets)
                    }
                }
                
                Section {
                    HStack {
                        SettingRow(setting: .biometrics)
                        Toggle(isOn: $biometricsEnabled, label: {})
                            .tint(nil)
                    }
                }
                
                SettingsExtraSection(toastPayload: $toastPayload)
                
                Section {
                    VStack(alignment: .center, spacing: 12) {
                        Image(systemName: "moon.fill")
                            .foregroundColor(.gray)
                            .font(.system(size: 25))
                        
                        Text("Version 1.0")
                            .foregroundColor(.gray)
                            .font(.system(size: 14, weight: .medium, design: .rounded))
                    }
                    .frame(maxWidth: .infinity)
                }
                .listRowBackground(Color(uiColor: .systemGroupedBackground))
            }
            .listStyle(.insetGrouped)
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear {
            biometricsEnabled = authModel.isBiometricsEnabled
        }
        .toast(isPresenting: $showToast) {
            AlertToast(displayMode: .hud, type: .regular, title: toastPayload?.message)
        }
        .onChange(of: toastPayload) { _ in
            showToast = true
        }
        .onChange(of: biometricsEnabled) { biometricsEnabled in
            if !authModel.isBiometricsEnabled || (!biometricsEnabled && authModel.isBiometricsEnabled) {
                authModel.authenticate { ok in
                    if !ok {
                        self.biometricsEnabled.toggle()
                    }
                }
            }
        }
    }
}

#if DEBUG
struct SettingsView_Previews : PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
#endif
