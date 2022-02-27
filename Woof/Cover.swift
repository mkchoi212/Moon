//
//  Cover.swift
//  Woof
//
//  Created by Mike Choi on 1/31/22.
//

import Foundation
import SwiftUI

struct Cover: View {
    @EnvironmentObject var authModel: SettingsViewModel
    
    var body: some View {
        ZStack {
            Image("moon")
                .resizable()
                .frame(width: 80, height: 80, alignment: .center)
   
            VStack(spacing: 20) {
                Spacer()
                
                Button {
                    authModel.authenticate()
                } label: {
                    Text("Unlock")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(Color(uiColor: .systemBackground))
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(RoundedRectangle(cornerRadius: 12).foregroundColor(.label))
                        .padding()
                }
                .opacity(authModel.isWaitingAuthentication ? 1 : 0)
                .animation(.easeIn, value: authModel.isWaitingAuthentication)
            }
        }
        .background(Color(uiColor: .secondarySystemBackground))
    }
}

struct Cover_Previews: PreviewProvider {
    static var previews: some View {
        Cover()
            .environmentObject(SettingsViewModel())
            .previewDevice(.init(rawValue: "iPhone 13 Pro"))
        
        Cover()
            .environmentObject(SettingsViewModel())
            .previewDevice(.init(rawValue: "iPhone 13 Pro"))
            .preferredColorScheme(.dark)
    }
}
