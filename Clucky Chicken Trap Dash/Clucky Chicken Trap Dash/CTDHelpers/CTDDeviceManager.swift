//
//  CTDDeviceManager.swift
//  Clucky Chicken Trap Dash
//
//  Created by Dias Atudinov on 28.03.2025.
//


import UIKit

class CTDDeviceManager {
    static let shared = CTDDeviceManager()
    
    var deviceType: UIUserInterfaceIdiom
    
    private init() {
        self.deviceType = UIDevice.current.userInterfaceIdiom
    }
}
