//
//  SettingsViewModelSL.swift
//  Clucky Chicken Trap Dash
//
//  Created by Dias Atudinov on 28.03.2025.
//


import SwiftUI

class SettingsViewModelCTD: ObservableObject {
    @AppStorage("soundEnabled") var soundEnabled: Bool = true
    @AppStorage("musicEnabled") var musicEnabled: Bool = true
}
