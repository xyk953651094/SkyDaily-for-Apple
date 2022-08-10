//
//  SkyDailyApp.swift
//  Shared
//
//  Created by 肖云开 on 2022/8/3.
//

import SwiftUI

@main
struct SkyDailyApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
