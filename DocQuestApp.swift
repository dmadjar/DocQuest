//
//  DocQuestApp.swift
//  DocQuest
//
//  Created by Daniel Madjar on 7/10/22.
//

import SwiftUI

class AppState: ObservableObject {
    @Published var selection : Int = 0
    @AppStorage("recentView") var recentView = 0
    @AppStorage("patients") var patients : [Int] = [Int]()
}

struct Question: Identifiable, Codable, Equatable {
    var id = UUID()
    var question : String = ""
    var answerType : String = ""
}

class SurveyMap: ObservableObject {
   //Now we need the map that will hold the name of the survey, and pair it with the Question
   
   @Published var nameToQuestion : [String : [Question]] = [:]

   init() {
       if let data = UserDefaults.standard.data(forKey: "SavedData") {
           if let decoded = try? JSONDecoder().decode([String : [Question]].self, from: data) {
               nameToQuestion = decoded
               return
           } else {
               print("Nope")
           }
       }

       nameToQuestion = [:]
   }

    func save() {
        if let encoded = try? JSONEncoder().encode(nameToQuestion) {
            UserDefaults.standard.set(encoded, forKey: "SavedData")
        }
    }
}

class Submit: ObservableObject {
    @Published var formattedAnswers : String = ""
}

@main
struct DocQuestApp: App {
    @StateObject private var dataController = DataController()
    @ObservedObject var surveyMap = SurveyMap()
    @ObservedObject var appState = AppState()
    @ObservedObject var firstLaunch = FirstLaunch()
    @ObservedObject var submit = Submit()
    //@ObservedObject var questionObject = Questions()
    
    
    var body: some Scene {
        WindowGroup {
            //FormBuilder()
              //  .environment(\.managedObjectContext, dataController.container.viewContext)
                //.environmentObject(questionObject)
            if appState.selection == 0 {
                CreatePasscode()
                    .environmentObject(appState)
                    .environmentObject(firstLaunch)
                    .onAppear {
                        appState.selection = firstLaunch.selected
                    }
            } else if appState.selection == 1 {
                EnterPasscode()
                    .environmentObject(appState)
                    .environmentObject(firstLaunch)
            } else if appState.selection == 2 {
                MakeOrTake()
                    .environmentObject(appState)
            } else if appState.selection == 3 {
                SurveyView()
                    .environment(\.managedObjectContext, dataController.container.viewContext)
                    .environmentObject(appState)
                    .environmentObject(surveyMap)
            } else if appState.selection == 4 {
                TakeSurveyView()
                    .environment(\.managedObjectContext, dataController.container.viewContext)
                    .environmentObject(appState)
                    .environmentObject(surveyMap)
                    .environmentObject(submit)
            } else if appState.selection == 5 {
                AddPatient()
                    .environmentObject(appState)
            } else if appState.selection == 6 {
                FinishedSurvey()
                    .environmentObject(appState)
            }
        }
        
    }
}

extension Array: RawRepresentable where Element: Codable {
    public init?(rawValue: String) {
        guard let data = rawValue.data(using: .utf8),
              let result = try? JSONDecoder().decode([Element].self, from: data)
        else {
            return nil
        }
        self = result
    }

    public var rawValue: String {
        guard let data = try? JSONEncoder().encode(self),
              let result = String(data: data, encoding: .utf8)
        else {
            return "[]"
        }
        return result
    }
}
