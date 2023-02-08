//
//  iQuoteApp.swift
//  iQuote
//
//  Created by Sara Alhumidi on 18/06/1444 AH.
//

import SwiftUI

@main
struct iQuoteApp: App {
    @StateObject var coreDM: CoreDataManager = CoreDataManager()
    var body: some Scene {
        WindowGroup{
            ContentView().environmentObject(coreDM)
        }
    }
}
