import SwiftUI

struct PickChickenViewCTD: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: ShopViewModelCTD
    @ObservedObject var statVM: StatisticsViewModelCTD
    @State private var showGame = false
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
                            
                            viewModel.currentTeamItem = "hero1"
                            
                            showGame = true
                        } label: {
                            Image(.goBgCTD)
                                .resizable()
                                .scaledToFit()
                                .frame(height: CTDDeviceManager.shared.deviceType == .pad ? 100:50)
                                .opacity(viewModel.boughtItems.contains("hero1") ? 1 : 0.5)
                        }
                    }
                    
                    
                    VStack {
                        Image(.secondChickenCTD)
                            .resizable()
                            .scaledToFit()
                            .frame(height: CTDDeviceManager.shared.deviceType == .pad ? 252:126)
                        Button {
                            if viewModel.boughtItems.contains("hero2") {
                                viewModel.currentTeamItem = "hero2"
                                showGame = true
                                
                            }
                        } label: {
                            Image(.goBgCTD)
                                .resizable()
                                .scaledToFit()
                                .frame(height: CTDDeviceManager.shared.deviceType == .pad ? 100:50)
                                .opacity(viewModel.boughtItems.contains("hero2") ? 1 : 0.5)
                        }
                    }
                    
                    
                    VStack {
                        Image(.thirdChickenCTD)
                            .resizable()
                            .scaledToFit()
                            .frame(height: CTDDeviceManager.shared.deviceType == .pad ? 252:126)
                        Button {
                            if viewModel.boughtItems.contains("hero3") {
                                viewModel.currentTeamItem = "hero3"
                                showGame = true
                            }
                            
                        } label: {
                            Image(.goBgCTD)
                                .resizable()
                                .scaledToFit()
                                .frame(height: CTDDeviceManager.shared.deviceType == .pad ? 100:50)
                                .opacity(viewModel.boughtItems.contains("hero3") ? 1 : 0.5)
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
        .fullScreenCover(isPresented: $showGame) {
            GameViewCTD(statVM: statVM)
        }
    }
}

#Preview {
    PickChickenViewCTD(viewModel: ShopViewModelCTD(), statVM: StatisticsViewModelCTD())
}
