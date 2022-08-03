//
//  DataController.swift
//  DocQuest
//
//  Created by Daniel Madjar on 7/10/22.
//

import Foundation
import CoreData
import CloudKit

class DataController: ObservableObject {
    let container = NSPersistentCloudKitContainer(name: "Surveys")
    
    init() {
        container.loadPersistentStores { desc, error in
            if let error = error {
                print("Failed to load the data \(error.localizedDescription)")
            }
        }
    }
    
    func save(context: NSManagedObjectContext) {
        do {
            try context.save()
            print("Data Saved")
        } catch {
            print("Could not Save")
        }
    }
    
    func addSurvey(name: String, context: NSManagedObjectContext) {
        let survey = SurveyEntity(context: context)
        survey.id = UUID()
        survey.name = name
        
        save(context: context)
    }
    
    func addQuestion(question: String, context: NSManagedObjectContext) {
        let questions = SurveyQuestion(context: context)
        questions.id = UUID()
        questions.question = question
        
        save(context: context)
    }
    
    /* func addTwoSolve(scramble: String, timeDouble: Double, timeString: String, context: NSManagedObjectContext) {
        let solve = TwoSolve(context: context)
        solve.id = UUID()
        solve.date = Date()
        solve.scramble = scramble
        solve.timeDouble = timeDouble
        solve.timeString = timeString
        
        save(context: context)
    }
     */
    
}
