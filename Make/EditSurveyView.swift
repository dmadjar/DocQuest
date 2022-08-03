//
//  EditSurveyView.swift
//  DocQuest
//
//  Created by Daniel Madjar on 7/11/22.
//

import SwiftUI

struct EditSurveyView: View {
    @EnvironmentObject var surveyMap : SurveyMap
    
    @State var isDeleting = false
    @State var addingQuestion = false
    @State var question = ""
    @State var percentage : Float = 25.0
    
    @State var map : [String : String] = [String : String]()
    
    let width = UIScreen.main.bounds.size.width
    let height = UIScreen.main.bounds.size.height
    
    var surveyName : String
    
    var answerTypes : [String] = ["Type", "Radio", "Scale", "Text", "Large Text", "MildMS"]
    @State var selection : Int = 0
    @State var isText : Bool = false
    
    var body: some View {
        ZStack {
            Color("backgroundElement").ignoresSafeArea()
                .brightness(addingQuestion ? -0.125 : 0)
            
            VStack {
                Text(surveyName)
                    .foregroundColor(.black)
                    .bold()
                    .font(.system(size: 45))
                    .frame(width: width / 1.1, alignment: .leading)
                  
                  
                ScrollView {
                    if surveyMap.nameToQuestion.count > 0 {
                        ForEach(surveyMap.nameToQuestion[surveyName] ?? []) { question in
                            VStack {
                                Spacer()
                                    .frame(height: 20)
                               
                                if question.answerType == "Radio" || question.answerType == "MildMS" || question.answerType == "Text" {
                                        HStack {
                                            Text(question.question)
                                                .foregroundColor(.black)
                                            
                                            Spacer()
                                            
                                            if !isDeleting {
                                                if question.answerType == "Radio" {
                                                    radioButton(question: "", qToAMap: $map)
                                                } else if question.answerType == "Text" {
                                                    textResponseSmall(question: "", qToAMap: $map)
                                                } else {
                                                    mildMS(question: "", qToAMap: $map)
                                                }
                                            } else {
                                                Button {
                                                    if let index = surveyMap.nameToQuestion[surveyName]!.firstIndex(of: question) {
                                                        surveyMap.nameToQuestion[surveyName]!.remove(at: index)
                                                        surveyMap.save()
                                                        print(surveyMap.nameToQuestion[surveyName]!)
                                                    }
                                                } label : {
                                                    Image(systemName: "xmark.circle.fill")
                                                        .renderingMode(.template)
                                                        .resizable()
                                                        .frame(width: 25, height: 25)
                                                        .foregroundColor(.red)
                                                }
                                            }
                                        }
                                        .padding(.horizontal, 25)
                                        .frame(width: width)
                                    
                                } else if question.answerType == "Scale" || question.answerType == "Large Text" {
                                    VStack(spacing: 15) {
                                        Text(question.question)
                                            .foregroundColor(.black)
                                            .frame(width: width / 1.1, alignment: .center)
                                        
                                        if isDeleting {
                                            Button {
                                                if let index = surveyMap.nameToQuestion[surveyName]!.firstIndex(of: question) {
                                                    surveyMap.nameToQuestion[surveyName]!.remove(at: index)
                                                    surveyMap.save()
                                                    print(surveyMap.nameToQuestion[surveyName]!)
                                                }
                                            } label : {
                                                Image(systemName: "xmark.circle.fill")
                                                    .renderingMode(.template)
                                                    .resizable()
                                                    .frame(width: 25, height: 25)
                                                    .foregroundColor(.red)
                                            }
                                        } else {
                                            if question.answerType == "Scale" {
                                                Scale(question: "", qToAMap: $map)
                                                    .frame(width: width / 1.1, height: 15)
                                                    .shadow(color: .white, radius: 14, x: -9, y: -9)
                                                    .shadow(color: Color("shadowColor"), radius: 10, x: 9, y: 9)
                                                    
                                            } else if question.answerType == "Large Text" {
                                                textResponseLarge(question: "", qToAMap: $map)
                                            }
                                        }
                                    }
                                    .padding(.horizontal, 25)
                                    .frame(width: width)

                                }
                                
                                Spacer()
                                    .frame(height: 20)
                            }
                        }
                    }
                }
                .brightness(addingQuestion ? -0.05 : 0)
                
                HStack {
                    HStack {
                        if isDeleting {
                            Text("Done")
                                .foregroundColor(Color("shadowColor"))
                                .bold()
                        }
                        
                        Button {
                            withAnimation {
                                isDeleting.toggle()
                            }
                        } label : {
                            ZStack {
                                Circle()
                                    .fill(Color("backgroundElement"))
                                    .shadow(color: .white, radius: 14, x: -9, y: -9)
                                    .shadow(color: Color("shadowColor"), radius: 10, x: 9, y: 9)
                                    .frame(width: 35, height: 35)
                                   
                                if !isDeleting {
                                    Image(systemName: "minus")
                                        .renderingMode(.template)
                                        .resizable()
                                        .frame(width: 20, height: 2)
                                        .foregroundColor(Color("shadowColor"))
                                } else {
                                        Image(systemName: "checkmark")
                                            .renderingMode(.template)
                                            .resizable()
                                            .frame(width: 20, height: 17.5)
                                            .foregroundColor(Color("shadowColor"))
                                }
                            }
                            .padding(.trailing, 10)
                        }
                        .frame(height: height / 10)
                    }
                    
                
                    if !isDeleting {
                        Button {
                            withAnimation {
                                addingQuestion = true
                            }
                        } label: {
                            ZStack {
                                Circle()
                                    .fill(Color("backgroundElement"))
                                    .shadow(color: .white, radius: 14, x: -9, y: -9)
                                    .shadow(color: Color("shadowColor"), radius: 10, x: 9, y: 9)
                                    .frame(width: 35, height: 35)
                                   
                                    
                                Image(systemName: "plus")
                                    .renderingMode(.template)
                                    .resizable()
                                    .frame(width: 20, height: 20)
                                    .foregroundColor(Color("shadowColor"))
                            }
                            .padding(.trailing, 10)
                        }
                        .frame(height: height / 10)
                    }
                    
                }

            }
            
                if addingQuestion {
                    ZStack {
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color("backgroundElement"))
                            .shadow(color: .white, radius: 1.5, x: -1, y: -1)
                            .shadow(color: Color("shadowColor"), radius: 10, x: 9, y: 9)
                            .frame(width: width / 1.2, height: height / 3)
                        
                        VStack {
                            Text("Question:")
                                .foregroundColor(Color("shadowColor"))
                                .bold()
                                .frame(width: width / 1.4, alignment: .leading)
                            
                            TextField("", text: $question)
                                .padding(.leading, 12.5)
                                .frame(width: width / 1.4, height: height / 20)
                                .background(Color("shadowColor"))
                                .foregroundColor(.black)
                                .border(Color("shadowColor"), width: 1)
                                .cornerRadius(15)
                               
                            Spacer()
                                .frame(height: height / 25)
                            
                            HStack {
                                
                                Text("Answer Type:")
                                    .foregroundColor(Color("shadowColor"))
                                    .bold()
                                
                                Spacer()
                                
                                Menu {
                                    Button {
                                        selection = 1
                                    } label : {
                                        Text(answerTypes[1])
                                            .foregroundColor(Color("shadowColor"))
                                            .bold()
                                    }
                                    
                                    Button {
                                        selection = 2
                                    } label : {
                                        Text(answerTypes[2])
                                            .foregroundColor(Color("shadowColor"))
                                            .bold()
                                    }
                                    
                                    Button {
                                        selection = 3
                                        withAnimation {
                                            isText = true
                                        }
                                    } label : {
                                        Text(answerTypes[3])
                                            .foregroundColor(Color("shadowColor"))
                                            .bold()
                                    }
                                    
                                    Button {
                                        selection = 4
                                    } label : {
                                        Text(answerTypes[4])
                                            .foregroundColor(Color("shadowColor"))
                                            .bold()
                                    }
                                    
                                    Button {
                                        selection = 5
                                    } label : {
                                        Text(answerTypes[5])
                                            .foregroundColor(Color("shadowColor"))
                                            .bold()
                                    }
                                    
                                } label : {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 15)
                                            .fill(Color("backgroundElement"))
                                            .shadow(color: .white, radius: 14, x: -9, y: -9)
                                            .shadow(color: Color("shadowColor"), radius: 10, x: 9, y: 9)
                                            .frame(width: width / 4, height: height / 20)
                                        
                                        Text(answerTypes[selection])
                                            .foregroundColor(Color("shadowColor"))
                                    }
                                }
                            }
                            .frame(width: width / 1.4, alignment: .leading)
                            
                            Spacer()
                                .frame(height: height / 25)
                            
                            Button {
                                surveyMap.nameToQuestion[surveyName]!.append(Question(question: question, answerType: answerTypes[selection]))
                                surveyMap.save()
                                print(surveyMap.nameToQuestion[surveyName]!)
                                
                                addingQuestion = false
                                question = ""
                            } label : {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 15)
                                        .fill(Color("backgroundElement"))
                                        .shadow(color: .white, radius: 14, x: -9, y: -9)
                                        .shadow(color: Color("shadowColor"), radius: 10, x: 9, y: 9)
                                        .frame(width: width / 4, height: height / 20)
                                    
                                    Text("Done")
                                        .foregroundColor(Color("shadowColor"))
                                }
                            }
                            .disabled(question.count == 0 || selection == 0)
                        }
                    }
                }
            }
    }
}

struct EditSurveyView_Previews: PreviewProvider {
    static var previews: some View {
        EditSurveyView(surveyName: "Penis Survey")
    }
}
