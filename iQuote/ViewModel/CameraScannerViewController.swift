//
//  CameraScannerViewController.swift
//  iQuote
//
//  Created by Sara Alhumidi on 18/06/1444 AH.
//

import Foundation
import SwiftUI
import VisionKit

struct CameraScannerViewController: UIViewControllerRepresentable {
   
   @Binding var startScanning: Bool
   @Binding var scanResult: String
  
   func makeCoordinator() -> Coordinator {
       Coordinator(scanResult: $scanResult)
   }
   
   func makeUIViewController(context: Context) -> DataScannerViewController {
       let viewController = DataScannerViewController(
           recognizedDataTypes: [.text()],
           qualityLevel: .fast,
           recognizesMultipleItems: false,
           isHighFrameRateTrackingEnabled: false,
           isHighlightingEnabled: true)
       
       viewController.delegate = context.coordinator

       return viewController
   }
   
   func updateUIViewController(_ viewController: DataScannerViewController, context: Context) {
       if startScanning {
           try? viewController.startScanning()
       } else {
           viewController.stopScanning()
       }
   }
   
   class Coordinator: NSObject, DataScannerViewControllerDelegate {
       @Binding var scanResult: String
    
       init(scanResult: Binding<String>) {
           self._scanResult = scanResult
       }
       func dataScanner(_ dataScanner: DataScannerViewController, didTapOn item: RecognizedItem) {
           switch item {
           case .text(let text):
               scanResult = text.transcript
               
           default:
               break
           }
       }
   }
}

