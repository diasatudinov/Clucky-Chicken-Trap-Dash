
import SwiftUI

struct MoneyViewCTD: View {
    @StateObject var user = CTDUser.shared
    var body: some View {
        ZStack {
            Image(.coinsBg)
                .resizable()
                .scaledToFit()
                
            HStack(spacing: 15) {
                
                Text("\(user.money)")
                    .font(.system(size: CTDDeviceManager.shared.deviceType == .pad ? 40:20, weight: .black))
                    .foregroundStyle(.white)
                    .textCase(.uppercase)
                    
                Image(.coinIconCTD)
                    .resizable()
                    .scaledToFit()
                    .frame(height: CTDDeviceManager.shared.deviceType == .pad ? 74:37)
            }
        }.frame(height: CTDDeviceManager.shared.deviceType == .pad ? 100:50)
    }
}

#Preview {
    MoneyViewCTD()
}
