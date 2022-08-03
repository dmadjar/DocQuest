//
//  PatientSurvey.swift
//  DocQuest
//
//  Created by Daniel Madjar on 7/21/22.
//

import SwiftUI

struct PatientSurvey: View {
    @Environment(\.openURL) var openURL
    var email = Email()
    @EnvironmentObject var appState : AppState
    @EnvironmentObject var submit : Submit
    @EnvironmentObject var surveyMap : SurveyMap
    @State var percentage : Float = 25.0
    @State var isLocked = false
    var surveyName : String
    var answerTypes : [String] = ["Type", "Radio", "Scale", "Text", "Large Text", "MildMS"]
    
    let width = UIScreen.main.bounds.size.width
    let height = UIScreen.main.bounds.size.height
    
    @State var questionAndAnswer : [String : String] = [String : String]()
    @State var toDisplay : String = "None"
    var body: some View {
        ZStack {
            Color("backgroundElement").ignoresSafeArea()
                .onAppear {
                    for questions in surveyMap.nameToQuestion[surveyName] ?? [] {
                        questionAndAnswer[questions.question] = ""
                    }
                    
                    print(questionAndAnswer)
                }
            
            VStack {
                HStack {
                    Text(surveyName)
                        .foregroundColor(.black)
                        .bold()
                        .font(.system(size: 35))
                    
                    Spacer()
                    
                    Menu {
                        ForEach(appState.patients, id: \.self) { userId in
                            Button {
                                toDisplay = idToString(num: userId)
                            } label : {
                                Text(idToString(num: userId))
                                    .foregroundColor(.black)
                                    .bold()
                                    .font(.system(size: 15))
                            }
                        }
                    } label : {
                        Text("ID: \(toDisplay)")
                            .foregroundColor(Color("shadowColor"))
                            .bold()
                            .font(.system(size: 20))
                            .frame(width: width / 4)
                    }
                }
                .padding(.horizontal, 15)
                .frame(width: width, alignment: .leading)
                
                
                ScrollView {
                    if surveyMap.nameToQuestion.count > 0 {
                        ForEach(surveyMap.nameToQuestion[surveyName] ?? []) {
                            question in
                            VStack {
                                Spacer()
                                    .frame(height: 20)
                                
                                if question.answerType == "Radio" || question.answerType == "MildMS" || question.answerType == "Text" {
                                    HStack {
                                        Text(question.question)
                                            .foregroundColor(.black)
                                        
                                        Spacer()
                                        
                                        if question.answerType == "Radio" {
                                            radioButton(question: question.question, qToAMap: $questionAndAnswer)
                                        } else if question.answerType == "Text" {
                                            textResponseSmall(question: question.question, qToAMap: $questionAndAnswer)
                                        } else {
                                            mildMS(question: question.question, qToAMap: $questionAndAnswer)
                                        }
                                    }
                                    .padding(.horizontal, 25)
                                    .frame(width: width)
                                } else if question.answerType == "Scale" || question.answerType == "Large Text" {
                                    VStack(spacing: 15) {
                                        Text(question.question)
                                            .foregroundColor(.black)
                                            .frame(width: width / 1.1, alignment: .center)
                                        
                                        if question.answerType == "Scale" {
                                            Scale(question: question.question, qToAMap: $questionAndAnswer)
                                                .frame(width: width / 1.1)
                                                .shadow(color: .white, radius: 14, x: -9, y: -9)
                                                .shadow(color: Color("shadowColor"), radius: 10, x: 9, y: 9)
                                                
                                        } else if question.answerType == "Large Text" {
                                            textResponseLarge(question: question.question, qToAMap: $questionAndAnswer)
                                        }
                                    }
                                    .padding(.horizontal, 25)
                                    .frame(width: width)
                                }
                                
                                Spacer()
                                    .frame(height: 20)
                            }
                        }
                        
                        Spacer()
                            .frame(height: 20)
                        
                        Button {
                            for (q, a) in questionAndAnswer {
                                submit.formattedAnswers += "\(q): \(a)\n"
                            }
                            
                            email.toAddress = "dmadjar@umich.edu"
                            email.subject = surveyName
                            email.messageHeader = "101302"
                            email.body = submit.formattedAnswers
                            
                            email.send(openURL: openURL)
                            
                            appState.selection = 6
                        } label : {
                            
                            Text("Submit")
                                .foregroundColor(Color("shadowColor"))
                                .bold()
                                .padding()
                                .background(Color("backgroundElement"))
                                .cornerRadius(15)
                                .shadow(color: .white, radius: 14, x: -9, y: -9)
                                .shadow(color: Color("shadowColor"), radius: 10, x: 9, y: 9)
                        }
                        .disabled(!isLocked)
                        
                    }
                }
                
                Button {
                    isLocked = true
                } label: {
                    if !isLocked {
                        Image(systemName: "lock.open.fill")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(Color("shadowColor"))
                    } else {
                        Image(systemName: "lock.fill")
                            .resizable()
                            .frame(width: 25, height: 30)
                            .foregroundColor(Color("shadowColor"))
                    }
                }
                .frame(height: height / 10)
            }
        }
        .navigationBarBackButtonHidden(isLocked)
    }
    
    func idToString(num: Int) -> String {
        let stringNumber : String = String(num)
        var toReturn : String = ""
        
        if stringNumber.count == 1 {
            toReturn = "0000" + stringNumber
        } else if String(num).count == 2 {
            toReturn = "000" + stringNumber
        } else if String(num).count == 3 {
            toReturn = "00" + stringNumber
        } else if String(num).count == 4 {
            toReturn = "0" + stringNumber
        } else {
            return stringNumber
        }
        
        return toReturn
    }
}

struct PatientSurvey_Previews: PreviewProvider {
    
    static let surveyMap = SurveyMap()
    static let appState = AppState()
    
    static var previews: some View {
        PatientSurvey(surveyName: "Survey Preview")
            .environmentObject(surveyMap)
            .environmentObject(appState)
    }
}
