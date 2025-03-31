//
//  ShopViewCTD.swift
//  Clucky Chicken Trap Dash
//
//  Created by Dias Atudinov on 28.03.2025.
//

import SwiftUI

struct ShopViewCTD: View {
    @Environment(\.presentationMode) var presentationMode
    private enum ShopType {
        case skills
        case skins
    }
    @State private var shopType: ShopType = .skills
    var body: some View {
        ZStack {
            VStack {
                ZStack {
                    Image(.bigBgCTD)
                        .resizable()
                        .scaledToFit()
                    VStack {
                        Text("Shop")
                            .font(.system(size: 42, weight: .black))
                            .foregroundStyle(.white)
                            .padding(.top, 20)
                        
                        HStack(spacing: 8) {
                            
                            Image(shopType == .skills ? .skillsIconCTD:.skillsOffIconCTD)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 50)
                                .onTapGesture {
                                    withAnimation {
                                        shopType = .skills
                                    }
                                }
                            
                            Image(shopType == .skins ? .skinsIconCTD : .skinsOffIconCTD)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 50)
                                .onTapGesture {
                                    withAnimation {
                                        shopType = .skins
                                    }
                                }
                        }
                        HStack(spacing: 40) {
                            if shopType == .skills {
                                shopItem()
                            } else {
                                VStack {
                                    Image(.firstChickenCTD)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: CTDDeviceManager.shared.deviceType == .pad ? 252:126)
                                    Button {
                                        
                                    } label: {
                                        ZStack {
                                            Image(.deskBgCTD)
                                                .resizable()
                                                .scaledToFit()
                                                .frame(height: CTDDeviceManager.shared.deviceType == .pad ? 100:50)
                                            HStack {
                                                Image(.coinIconCTD)
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(height: CTDDeviceManager.shared.deviceType == .pad ? 46:28)
                                            }
                                        }
                                    }
                                }
                                
                                VStack {
                                    Image(.secondChickenCTD)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: CTDDeviceManager.shared.deviceType == .pad ? 252:126)
                                    Button {
                                        
                                    } label: {
                                        ZStack {
                                            Image(.deskBgCTD)
                                                .resizable()
                                                .scaledToFit()
                                                .frame(height: CTDDeviceManager.shared.deviceType == .pad ? 100:50)
                                            HStack {
                                                Image(.coinIconCTD)
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(height: CTDDeviceManager.shared.deviceType == .pad ? 46:28)
                                            }
                                        }
                                    }
                                }
                                
                                VStack {
                                    Image(.thirdChickenCTD)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: CTDDeviceManager.shared.deviceType == .pad ? 252:126)
                                    Button {
                                        
                                    } label: {
                                        ZStack {
                                            Image(.deskBgCTD)
                                                .resizable()
                                                .scaledToFit()
                                                .frame(height: CTDDeviceManager.shared.deviceType == .pad ? 100:50)
                                            HStack {
                                                Image(.coinIconCTD)
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(height: CTDDeviceManager.shared.deviceType == .pad ? 46:28)
                                            }
                                        }
                                    }
                                }
                            }
                            
                        }
                        Spacer()
                    }.padding(.vertical, 20)
                }.frame(width: UIScreen.main.bounds.width)
                Spacer()
            }.ignoresSafeArea()
            
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
                
                
            }.padding([.leading, .top], 30)
            
        }.ignoresSafeArea()
            .background(
            ZStack {
                Image(.menuBgCTD)
                    .resizable()
                    .edgesIgnoringSafeArea(.all)
                    .scaledToFill()
            }
            
        )
    }
    
    @ViewBuilder
    func shopItem() -> some View {
        VStack {
            Image(.item1CTD)
                .resizable()
                .scaledToFit()
                .frame(height: CTDDeviceManager.shared.deviceType == .pad ? 252:126)
            Button {
                
            } label: {
                ZStack {
                    Image(.deskBgCTD)
                        .resizable()
                        .scaledToFit()
                        .frame(height: CTDDeviceManager.shared.deviceType == .pad ? 100:50)
                    HStack {
                        Image(.coinIconCTD)
                            .resizable()
                            .scaledToFit()
                            .frame(height: CTDDeviceManager.shared.deviceType == .pad ? 46:28)
                        Text("100")
                            .font(.system(size: 20, weight: .black))
                            .foregroundStyle(.white)
                    }
                }
            }
        }
    }
    
}

#Preview {
    ShopViewCTD()
}
