//
//  SplashScreenCTD.swift
//  Clucky Chicken Trap Dash
//
//  Created by Dias Atudinov on 31.03.2025.
//

import SwiftUI

struct SplashScreenCTD: View {
    @State private var progress: Double = 0.0
    @State private var timer: Timer?
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                
                VStack {
                    Spacer()
                    ZStack {
                        VStack(spacing: 10) {
                            
                            Image(.logoIconCTD)
                                .resizable()
                                .scaledToFit()
                                .frame(height: CTDDeviceManager.shared.deviceType == .pad ? 400:200)
                            
                            Image(.loadingTextCTD)
                                .resizable()
                                .scaledToFit()
                                .frame(height: CTDDeviceManager.shared.deviceType == .pad ? 40:20)
                            HStack {
                                Spacer()
                                ZStack {
                                    Image(.loaderBgCTD)
                                        .resizable()
                                        .scaledToFit()
                                    
                                    Image(.loaderFrontCTD)
                                        .resizable()
                                        .scaledToFit()
                                        .mask(alignment: .leading) {
                                            Rectangle()
                                                .frame(width: (geometry.size.width * progress))
                                                .animation(.easeInOut, value: progress)
                                        }
                                        .frame(height: CTDDeviceManager.shared.deviceType == .pad ? 36:18)
                                    
                                }.frame(height: CTDDeviceManager.shared.deviceType == .pad ? 54:27)
                                Spacer()
                            }
                        }
                    }
                    .foregroundColor(.black)
                    Spacer()
                }
            }.background(
                Image(.loadingBgCTD)
                    .resizable()
                    .ignoresSafeArea()
                    .scaledToFill()
            )
            .onAppear {
                startTimer()
            }
        }
    }
    
    func startTimer() {
        timer?.invalidate()
        progress = 0
        timer = Timer.scheduledTimer(withTimeInterval: 0.07, repeats: true) { timer in
            if progress < 1 {
                progress += 0.003
            } else {
                timer.invalidate()
            }
        }
    }
}

#Preview {
    SplashScreenCTD()
}
