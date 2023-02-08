//
//  CoreDataManager.swift
//  iQuote
//
//  Created by Sara Alhumidi on 18/06/1444 AH.
//

import Foundation

import CoreData

class CoreDataManager : ObservableObject {

    let persistentContainer: NSPersistentContainer
    @Published var quotes: [QuotesData] = []
    
 
 init() {
     persistentContainer = NSPersistentContainer(name: "QuotesModel")
     persistentContainer.loadPersistentStores { (description, error) in
         if let error = error {
             fatalError("Core Data Store failed \(error.localizedDescription)")
         }else
         {
             print("Sucssfully loaded")
         }
     }
 }
 
     func updateQuotes() -> [QuotesData] {
     do {
         try persistentContainer.viewContext.save()
     } catch {
         persistentContainer.viewContext.rollback()
         
     }
         return []
 }

 func deleteQuotes(quotesData: QuotesData) {

     persistentContainer.viewContext.delete(quotesData)

     do {
         try persistentContainer.viewContext.save()
     } catch {
         persistentContainer.viewContext.rollback()
         print("Failed to save context \(error)")
     }

 }

 func getAllQuotes() -> [QuotesData] {

     let fetchRequest: NSFetchRequest<QuotesData> = QuotesData.fetchRequest()

     do {
         return try persistentContainer.viewContext.fetch(fetchRequest)
     } catch {
         return []
     }

 }

 
 
 func saveQuotes(quotesText: String) {

     let quotesData = QuotesData(context: persistentContainer.viewContext)
     quotesData.quotes_text = quotesText
     quotes.append(quotesData)
     do {
         try persistentContainer.viewContext.save()
     } catch {
         print("Failed to save movie \(error)")
     }

 }

}
