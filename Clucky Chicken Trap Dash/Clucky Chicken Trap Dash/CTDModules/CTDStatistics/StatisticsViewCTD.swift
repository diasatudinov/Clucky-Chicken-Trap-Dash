//
//  StatisticsViewCTD.swift
//  Clucky Chicken Trap Dash
//
//  Created by Dias Atudinov on 28.03.2025.
//

import SwiftUI

struct StatisticsViewCTD: View {
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        ZStack {
            ZStack {
                Image(.bigBgCTD)
                    .resizable()
                    .scaledToFit()
                VStack {
                    Spacer()
                    HStack(spacing: 50) {
                        
                        VStack(alignment: .leading) {
                            HStack {
                                Image(.icon1)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 35)
                                Text("Total monsters killed:")
                                    .font(.system(size: 21, weight: .black))
                                    .foregroundStyle(.white)
                                
                                Text("0")
                                    .font(.system(size: 21, weight: .black))
                                    .foregroundStyle(.white)
                            }
                            
                            HStack {
                                Image(.icon3)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 35)
                                Text("Defeated bosses: ")
                                    .font(.system(size: 21, weight: .black))
                                    .foregroundStyle(.white)
                                
                                Text("0")
                                    .font(.system(size: 21, weight: .black))
                                    .foregroundStyle(.white)
                            }
                            
                            HStack {
                                Image(.icon5)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 35)
                                Text("Maximum hero level: ")
                                    .font(.system(size: 21, weight: .black))
                                    .foregroundStyle(.white)
                                
                                Text("0")
                                    .font(.system(size: 21, weight: .black))
                                    .foregroundStyle(.white)
                            }
                        }
                        
                        VStack(alignment: .leading) {
                            HStack {
                                
                                Image(.icon2)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 35)
                                Text("Total gold accumulated:")
                                    .font(.system(size: 21, weight: .black))
                                    .foregroundStyle(.white)
                                
                                Text("0")
                                    .font(.system(size: 21, weight: .black))
                                    .foregroundStyle(.white)
                                
                            }
                            
                            HStack {
                                
                                
                                Image(.icon4)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 35)
                                Text("Total gold spent: ")
                                    .font(.system(size: 21, weight: .black))
                                    .foregroundStyle(.white)
                                
                                Text("0")
                                    .font(.system(size: 21, weight: .black))
                                    .foregroundStyle(.white)
                                
                            }
                            
                            HStack {
                                
                                
                                Image(.icon6)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 35)
                                Text("Matches played: ")
                                    .font(.system(size: 21, weight: .black))
                                    .foregroundStyle(.white)
                                
                                Text("0")
                                    .font(.system(size: 21, weight: .black))
                                    .foregroundStyle(.white)
                            }
                        }
                           
                    }
                    HStack {
                        Image(.icon7)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 35)
                        Text("Total time in the game:")
                            .font(.system(size: 21, weight: .black))
                            .foregroundStyle(.white)
                        
                        Text("0")
                            .font(.system(size: 21, weight: .black))
                            .foregroundStyle(.white)
                    }
                }.padding(.bottom, 50)
            }.frame(width: UIScreen.main.bounds.width)
            
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
}

#Preview {
    StatisticsViewCTD()
}
