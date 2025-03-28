//
//  PickChickenViewCTD.swift
//  Clucky Chicken Trap Dash
//
//  Created by Dias Atudinov on 28.03.2025.
//

import SwiftUI

struct PickChickenViewCTD: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            VStack {
                Image(.pickChickenTextCTD)
                    .resizable()
                    .scaledToFit()
                    .frame(height: CTDDeviceManager.shared.deviceType == .pad ? 216:108)
                Spacer()
                HStack {
                    
                    VStack {
                        Image(.firstChickenCTD)
                            .resizable()
                            .scaledToFit()
                            .frame(height: CTDDeviceManager.shared.deviceType == .pad ? 252:126)
                        Button {
                            
                        } label: {
                            Image(.goBgCTD)
                                .resizable()
                                .scaledToFit()
                                .frame(height: CTDDeviceManager.shared.deviceType == .pad ? 100:50)
                        }
                    }
                    
                    
                    VStack {
                        Image(.secondChickenCTD)
                            .resizable()
                            .scaledToFit()
                            .frame(height: CTDDeviceManager.shared.deviceType == .pad ? 252:126)
                        Button {
                            
                        } label: {
                            Image(.goBgCTD)
                                .resizable()
                                .scaledToFit()
                                .frame(height: CTDDeviceManager.shared.deviceType == .pad ? 100:50)
                        }
                    }
                    
                    
                    VStack {
                        Image(.thirdChickenCTD)
                            .resizable()
                            .scaledToFit()
                            .frame(height: CTDDeviceManager.shared.deviceType == .pad ? 252:126)
                        Button {
                            
                        } label: {
                            Image(.goBgCTD)
                                .resizable()
                                .scaledToFit()
                                .frame(height: CTDDeviceManager.shared.deviceType == .pad ? 100:50)
                        }
                    }
                    
                }
                Spacer()
            }.padding()
            
            VStack(spacing: 0) {
                HStack {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Image(.backIconCTD)
                            .resizable()
                            .scaledToFit()
                            .frame(height: CTDDeviceManager.shared.deviceType == .pad ? 100:50)
                    }
                    
                    Spacer()
                }
                Spacer()
                
                
            }.padding([.leading, .top])
        }.background(
            ZStack {
                Image(.menuBgCTD)
                    .resizable()
                    .edgesIgnoringSafeArea(.all)
                    .scaledToFill()
            }
            
        )
    }
}

#Preview {
    PickChickenViewCTD()
}
