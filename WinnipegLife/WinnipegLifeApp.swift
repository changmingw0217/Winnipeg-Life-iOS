//
//  WinnipegLifeApp.swift
//  WinnipegLife
//
//  Created by changming wang on 6/5/21.
//

import SwiftUI

@main
struct WinnipegLifeApp: App {
    
    @AppStorage("appLanguage") var appLanguage: String = Locale.current.languageCode ?? "zh"

    @StateObject var appModel = AppModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appModel)
                .environment(\.locale, .init(identifier: appLanguage))

        }
    }
}

