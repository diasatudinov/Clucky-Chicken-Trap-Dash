import SwiftUI

struct ShopViewCTD: View {
    @StateObject var user = CTDUser.shared
    @Environment(\.presentationMode) var presentationMode
    private enum ShopType {
        case skills
        case skins
    }
    @State private var shopType: ShopType = .skills
    
    @ObservedObject var viewModel: ShopViewModelCTD
    var body: some View {
        ZStack {
            VStack {
                ZStack {
                    Image(.bigBgCTD)
                        .resizable()
                        .scaledToFit()
                    VStack {
                        Text("Shop")
                            .font(.system(size: CTDDeviceManager.shared.deviceType == .pad ? 84:42, weight: .black))
                            .foregroundStyle(.white)
                            .padding(.top, CTDDeviceManager.shared.deviceType == .pad ? 40:20)
                        
                        HStack(spacing: CTDDeviceManager.shared.deviceType == .pad ? 16:8) {
                            
                            Image(shopType == .skills ? .skillsIconCTD:.skillsOffIconCTD)
                                .resizable()
                                .scaledToFit()
                                .frame(height: CTDDeviceManager.shared.deviceType == .pad ? 100:50)
                                .onTapGesture {
                                    withAnimation {
                                        shopType = .skills
                                    }
                                }
                            
                            Image(shopType == .skins ? .skinsIconCTD : .skinsOffIconCTD)
                                .resizable()
                                .scaledToFit()
                                .frame(height: CTDDeviceManager.shared.deviceType == .pad ? 100:50)
                                .onTapGesture {
                                    withAnimation {
                                        shopType = .skins
                                    }
                                }
                        }
                        HStack(spacing: 0) {
                            if shopType == .skills {
                                
                                ForEach(viewModel.shopTeamItems,
                                        id: \.self)
                                { item in
                                    shopItem(item: item)
                                }
                                
                            } else {
                                VStack {
                                    Image(.firstChickenCTD)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: CTDDeviceManager.shared.deviceType == .pad ? 252:126)
                                    Button {
                                        if user.money >= 0 {
                                            user.minusUserMoney(for: 0)
                                            let item = "hero1"
                                            if !viewModel.boughtItems.contains(item) {
                                                viewModel.boughtItems.append(item)
                                            }
                                        }
                                    } label: {
                                        ZStack {
                                            Image(.deskBgCTD)
                                                .resizable()
                                                .scaledToFit()
                                                .frame(height: CTDDeviceManager.shared.deviceType == .pad ? 100:50)
                                            HStack(spacing: 0) {
                                                Image(.coinIconCTD)
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(height: CTDDeviceManager.shared.deviceType == .pad ? 46:28)
                                                
                                                Text("0")
                                                    .font(.system(size: 20, weight: .black))
                                                    .foregroundStyle(.white)
                                                    .frame(width: CTDDeviceManager.shared.deviceType == .pad ? 110:55)
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
                                        if user.money >= 2000 {
                                            user.minusUserMoney(for: 2000)
                                            let item = "hero2"
                                            if !viewModel.boughtItems.contains(item) {
                                                viewModel.boughtItems.append(item)
                                            }
                                        }
                                    } label: {
                                        ZStack {
                                            Image(.deskBgCTD)
                                                .resizable()
                                                .scaledToFit()
                                                .frame(height: CTDDeviceManager.shared.deviceType == .pad ? 100:50)
                                            HStack(spacing: 0) {
                                                Image(.coinIconCTD)
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(height: CTDDeviceManager.shared.deviceType == .pad ? 46:28)
                                                
                                                Text("2000")
                                                    .font(.system(size: 20, weight: .black))
                                                    .foregroundStyle(.white)
                                                    .frame(width: CTDDeviceManager.shared.deviceType == .pad ? 120:60)
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
                                        if user.money >= 2000 {
                                            user.minusUserMoney(for: 2000)
                                            let item = "hero3"
                                            if !viewModel.boughtItems.contains(item) {
                                                viewModel.boughtItems.append(item)
                                            }
                                        }
                                    } label: {
                                        ZStack {
                                            Image(.deskBgCTD)
                                                .resizable()
                                                .scaledToFit()
                                                .frame(height: CTDDeviceManager.shared.deviceType == .pad ? 100:50)
                                            HStack(spacing: 0) {
                                                Image(.coinIconCTD)
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(height: CTDDeviceManager.shared.deviceType == .pad ? 46:28)
                                                
                                                Text("2000")
                                                    .font(.system(size: 20, weight: .black))
                                                    .foregroundStyle(.white)
                                                    .frame(width: CTDDeviceManager.shared.deviceType == .pad ? 120:60)
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
                    
                    MoneyViewCTD()
                }.padding()
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
    func shopItem(item: Item) -> some View {
        VStack {
            ZStack {
                Image("\(item.name)")
                    .resizable()
                    .scaledToFit()
                
                if item.name != "item6CTD" {
                    VStack {
                        Spacer()
                        Text("\(item.level)")
                            .font(.system(size: CTDDeviceManager.shared.deviceType == .pad ? 38:19, weight: .black))
                            .foregroundStyle(.black)
                            .offset(x: CTDDeviceManager.shared.deviceType == .pad ? 35:28, y: CTDDeviceManager.shared.deviceType == .pad ? -42:-11)
                    }
                }
            }
            .frame(height: CTDDeviceManager.shared.deviceType == .pad ? 240:120)
            
            Button {
                if user.money >= item.cost {
                    user.minusUserMoney(for: item.cost)
                    viewModel.buyItem(for: item)
                }
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
                        Text("\(item.cost)")
                            .font(.system(size: CTDDeviceManager.shared.deviceType == .pad ? 40:20, weight: .black))
                            .foregroundStyle(.white)
                    }
                }
            }
        }
    }
    
}

#Preview {
    ShopViewCTD(viewModel: ShopViewModelCTD())
}
