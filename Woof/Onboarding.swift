//
//  Onboarding.swift
//  Woof
//
//  Created by Mike Choi on 2/21/22.
//

import Foundation
import SwiftUI


struct OnboardingView: View {
    @State var degrees: Double = 0
    var timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            VStack(spacing: -30) {
                Circle()
                    .foregroundColor(.red)
                    .frame(width: 250, height: 250)
                
                Circle()
                    .foregroundColor(.blue)
                    .frame(width: 250, height: 250)
            }
            .rotationEffect(.degrees(degrees))
            
            Rectangle()
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundColor(.clear)
                .background(.thinMaterial)
            
            VStack(spacing: 30) {
                HStack {
                    Text("MOON")
                        .font(.system(size: 17, weight: .semibold, design: .default))
                    
                    Spacer()
                }
                
                Separator()
                
                VStack(alignment: .leading, spacing: 40) {
                    Text("the last crypto wallet")
                        .font(.system(size: 80, weight: .semibold)) +
                    Text(" you need")
                        .font(.system(size: 80, weight: .bold))
                    
                   Text("Explore the world of cryptocurrency without wanting to blow your brains")
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                Spacer()
                
                HStack {
                    Button {
                    } label: {
                        Text("Create Wallet")
                            .foregroundColor(.black)
                            .font(.system(size: 15, weight: .semibold, design: .monospaced))
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 12).foregroundColor(.white))
                    }
                    Spacer()
                    Button {
                    } label: {
                        Text("Connect Wallet")
                            .foregroundColor(.white)
                            .font(.system(size: 15, weight: .semibold, design: .monospaced))
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 12))
                    }
                }
                .frame(maxWidth: .infinity, alignment: .center)
            }
            .padding()
        }
        .onReceive(timer) { _ in
            if degrees == 365 {
                degrees = 0
            }
            
            degrees += 2
        }
    }
}

struct Onboarding_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}
