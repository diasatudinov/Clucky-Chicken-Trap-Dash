import SwiftUI

struct SettingsViewCTD: View {
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var settings: SettingsViewModelCTD
    
    var body: some View {
        ZStack {
            
            VStack {
                ZStack {
                    
                    Image(.settingsBgCTD)
                        .resizable()
                        .scaledToFit()
                    
                    
                    VStack {
                        Text("Settings")
                            .font(.system(size: 42, weight: .black))
                            .foregroundStyle(.white)
                        
                        VStack {
                            
                            Text("Sounds")
                                .font(.system(size: 21, weight: .black))
                                .foregroundStyle(.white)
                            HStack(spacing: CTDDeviceManager.shared.deviceType == .pad ? 140:70) {
                                
                                Button {
                                    settings.soundEnabled = false
                                } label: {
                                    Image(.offCTD)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: CTDDeviceManager.shared.deviceType == .pad ? 110:55)
                                }
                                Button {
                                    settings.soundEnabled = true
                                } label: {
                                    Image(.onCTD)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: CTDDeviceManager.shared.deviceType == .pad ? 110:55)
                                }
                            }
                        }
                        
                        VStack {
                            Text("Language")
                                .font(.system(size: 21, weight: .black))
                                .foregroundStyle(.white)
                            
                            HStack(spacing: 30) {
                                Image(.enCTD)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: CTDDeviceManager.shared.deviceType == .pad ? 110:55)
                                
                                Image(.frCTD)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: CTDDeviceManager.shared.deviceType == .pad ? 110:55)
                                
                                Image(.grCTD)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: CTDDeviceManager.shared.deviceType == .pad ? 110:55)
                                
                                Image(.itCTD)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: CTDDeviceManager.shared.deviceType == .pad ? 110:55)
                            }
                        }
                        
                        
                        
                        
                        
                    }
                    
                }.frame(width: CTDDeviceManager.shared.deviceType == .pad ? 920:460, height: CTDDeviceManager.shared.deviceType == .pad ? 780:390)
            
                
                
            }
            
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
                Button {
                    
                } label: {
                    Image(.resetIconCTD)
                        .resizable()
                        .scaledToFit()
                        .frame(height: CTDDeviceManager.shared.deviceType == .pad ? 120:61)
                }
                
            }.padding([.leading, .top])
            
        }
        .background(
            ZStack {
                Image(.menuBgCTD)
                    .resizable()
                    .edgesIgnoringSafeArea(.all)
                    .scaledToFill()
                VStack {
                    Spacer()
                    HStack(alignment: .bottom) {
                        Image(.chickenMenuCTD)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 250)
                        Spacer()
                        Image(.cookerCTD)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 350)
                            
                    }
                }.edgesIgnoringSafeArea(.bottom)
            }
            
        )
        
    }
}


#Preview {
    SettingsViewCTD(settings: SettingsViewModelCTD())
}
