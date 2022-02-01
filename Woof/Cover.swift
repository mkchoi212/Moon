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
                .frame(width: 50, height: 50, alignment: .center)
   
            VStack(spacing: 20) {
                Spacer()
                
                Button {
                    authModel.authenticate()
                } label: {
                    Text("Unlock")
                        .font(.system(size: 17, weight: .semibold))
                        .padding()
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.blue)
                        .overlay(RoundedRectangle(cornerRadius: 12).foregroundColor(.lightBlue))
                        .padding()
                }
                .opacity(authModel.isWaitingAuthentication ? 1 : 0)
                .animation(.easeIn, value: authModel.isWaitingAuthentication)
                
                Text("MOON")
                    .foregroundColor(Color(uiColor: .secondaryLabel))
                    .font(.system(size: 16, weight: .semibold, design: .default))
            }
        }
    }
}

struct Cover_Previews: PreviewProvider {
    static var previews: some View {
        Cover()
            .environmentObject(SettingsViewModel())
            .previewDevice(.init(rawValue: "iPhone 13 Pro"))
    }
}
