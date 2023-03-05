//
//  CameraScanText.swift
//  iQuote
//
//  Created by Sara Alhumidi on 18/06/1444 AH.
//

import SwiftUI

struct CameraScanText: View {
    @EnvironmentObject var coreDM: CoreDataManager
    @Binding var startScanning: Bool
    @Binding var scanResult: String
    @Binding var listQuote: [String]
    @State var listAllQuote: [QuotesData] = []
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        NavigationView {
            CameraScannerViewController(startScanning: $startScanning, scanResult: $scanResult)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                      
                        Button {
                            self.presentationMode.wrappedValue.dismiss()
                         
                        } label: {
                            Text("Cancel").accessibilityLabel("Cancel")
                            
                        }
                    }
                }
                .interactiveDismissDisabled(true)
        }
        .onChange(of: scanResult) { newValue in
            if (!scanResult.isEmpty) {
                saveText()
           
//                populateQuotes()
                self.presentationMode.wrappedValue.dismiss()
            }
        }
    }
    func pupdateAllQuotes() {
        coreDM.quotes = coreDM.updateQuotes()
    }
    func populateQuotes() {
        coreDM.quotes = coreDM.getAllQuotes()
   }
    func saveText(){
//        listQuote.append(scanResult)
        coreDM.saveQuotes(quotesText: scanResult)
   
    }
}

struct CameraScanText_Previews: PreviewProvider {
    static var previews: some View {
        CameraScanText(startScanning: .constant(true), scanResult: .constant(""), listQuote: .constant([""]))
    }
}
