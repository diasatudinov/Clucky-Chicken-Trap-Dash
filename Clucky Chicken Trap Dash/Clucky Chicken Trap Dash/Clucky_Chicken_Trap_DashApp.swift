import SwiftUI

@main
struct Clucky_Chicken_Trap_DashApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene {
        WindowGroup {
            RootViewSL()
                .preferredColorScheme(.light)
            
        }
    }
}
