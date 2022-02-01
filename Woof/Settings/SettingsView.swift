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
    case share = "Tell your friends"
    
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
            case .share:
                return Image(systemName: "person.2.fill")
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
            case .share:
                return .darkText
        }
    }
}

struct SettingRow: View {
    let setting: Setting
    
    var body: some View {
        HStack {
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

struct SettingsView: View {
    
    @AppStorage("biometrics.enabled") var biometricsEnabled = false
    @Environment(\.presentationMode) var presentationMode
    
    @StateObject var viewModel = SettingsViewModel()
 
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
                
                Section {
                    SettingRow(setting: .about)
                    SettingRow(setting: .rate)
                    SettingRow(setting: .share)
                }
                
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
        .onChange(of: biometricsEnabled) { biometricsEnabled in
            viewModel.authenticate { ok in
                if !ok {
                    self.biometricsEnabled.toggle()
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
