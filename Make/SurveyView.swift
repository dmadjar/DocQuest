//
//  SurveyView.swift
//  DocQuest
//
//  Created by Daniel Madjar on 7/11/22.
//

import SwiftUI

struct SurveyView: View {
    @EnvironmentObject var appState : AppState
    @EnvironmentObject var surveyMap : SurveyMap
    
    @Environment(\.managedObjectContext) var managedObjContext
    @FetchRequest(sortDescriptors: []) var surveys: FetchedResults<SurveyEntity>
    
    let width = UIScreen.main.bounds.size.width
    let height = UIScreen.main.bounds.size.height
    
    @State var surveyName = ""
    @State var addingSurvey : Bool = false
    @State var isDeleting : Bool = false
    @State var noCharacters : Bool = false
 
    
    var body: some View {
        NavigationView {
            
            ZStack {
                Color("backgroundElement").ignoresSafeArea()
                    .brightness(addingSurvey ? -0.125 : 0)
                VStack {
                ScrollView {
                    ForEach(surveys) { survey in
                        NavigationLink(destination: EditSurveyView(surveyName: survey.name!)
                            .environmentObject(surveyMap)) {
                            VStack {
                                Spacer()
                                    .frame(height: 10)
                                
                                ZStack {
                                    
                                    RoundedRectangle(cornerRadius: 15)
                                        .fill(Color("backgroundElement"))
                                        .shadow(color: .white, radius: 14, x: -9, y: -9)
                                        .shadow(color: Color("shadowColor"), radius: 10, x: 9, y: 9)
                                        .frame(width: width / 1.2, height: height / 12.5)
                                    
                                    HStack {
                                        Text(survey.name!)
                                            .foregroundColor(Color("shadowColor"))
                                            .bold()
                                        
                                        Spacer()
                                        
                                        if isDeleting {
                                            Button {
                                                surveyMap.nameToQuestion.removeValue(forKey: survey.name!)
                                                surveyMap.save()
                                                
                                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                                    if let index = surveys.firstIndex(of: survey) {
                                                        self.deleteSurvey(at: IndexSet(integer: index))
                                                    }
                                                }
                                                
                                                print(surveyMap.nameToQuestion.count)
                                            } label : {
                                                Image(systemName: "xmark.circle.fill")
                                                    .renderingMode(.template)
                                                    .resizable()
                                                    .frame(width: 25, height: 25)
                                                    .foregroundColor(.red)
                                            }
                                        } else {
                                            Image(systemName: "chevron.right")
                                                .renderingMode(.template)
                                                .resizable()
                                                .frame(width: 10, height: 15)
                                                .foregroundColor(Color("shadowColor"))
                                        }
                                    }
                                    .padding(.horizontal, 50)
                                }
            
                                Spacer()
                                    .frame(height: 10)
                            }
                        }
                    }
                    .navigationBarTitle(Text("Survey Builder"))
                }
                .brightness(addingSurvey ? -0.05 : 0)
                
                    HStack {
                        Button {
                            appState.selection = 2
                        } label : {
                            ZStack {
                                Circle()
                                    .fill(Color("backgroundElement"))
                                    .shadow(color: .white, radius: 14, x: -9, y: -9)
                                    .shadow(color: Color("shadowColor"), radius: 10, x: 9, y: 9)
                                    .frame(width: 35, height: 35)
                                
                                Image(systemName: "house.fill")
                                    .renderingMode(.template)
                                    .resizable()
                                    .frame(width: 20, height: 17.5)
                                    .foregroundColor(Color("shadowColor"))
                                
                            }
                        }
                        .frame(height: height / 10)
                        
                        Spacer()
                        
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
                                    addingSurvey = true
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
                    .padding(.horizontal, 25)
            }
                VStack {
                    Spacer()
                        .frame(height: 10)
                    
                    if addingSurvey {
                        VStack {
                            
                            Spacer()
                            
                            Spacer()
                            
                            ZStack {
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(Color("backgroundElement"))
                                    .shadow(color: .white, radius: 1.5, x: -1, y: -1)
                                    .shadow(color: Color("shadowColor"), radius: 10, x: 9, y: 9)
                                    .frame(width: width / 1.2, height: height / 5)
                                    
                                VStack(spacing: 15) {
                                    HStack {
                                        Text("Survey Name:")
                                            .foregroundColor(Color("shadowColor"))
                                            .bold()
                                        
                                        Spacer()
                                        
                                        Text("\(surveyName.count) / 50")
                                            .foregroundColor((surveyName.count == 0 || surveyName.count > 50) ? Color(.red) : Color("shadowColor"))
                                            .bold()
                                    }
                                    .frame(width: width / 1.4)
                                    
                                        TextField("", text: $surveyName)
                                            .padding(.leading, 12.5)
                                            .frame(width: width / 1.4, height: height / 26)
                                            .background(Color("shadowColor"))
                                            .foregroundColor(.black)
                                            .border(Color("shadowColor"), width: 1)
                                            .cornerRadius(15)
                                    
                                        HStack {
                                            Button {
                                                withAnimation {
                                                    addingSurvey = false
                                                }
                                                
                                                surveyName = ""
                                            } label : {
                                                Text("Cancel")
                                                    .foregroundColor(Color("shadowColor"))
                                                    .bold()
                                            }
                                            
                                            Spacer()
                                                .frame(width: 15)
                                            
                                            Button {
                                                if surveyName.count > 0 {
                                                DataController().addSurvey(name: surveyName, context: managedObjContext)
                                                
                                                    withAnimation {
                                                        addingSurvey = false
                                                        noCharacters = false
                                                    }
                                                
                                                surveyMap.nameToQuestion[surveyName] = [Question]()
                                                surveyMap.save()
                                                
                                                    surveyName = ""
                                                } else {
                                                    withAnimation {
                                                        noCharacters = true
                                                    }
                                                }
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
                                            .frame(alignment: .trailing)
                                        }
                                    }
                                    .padding(.horizontal)
                                    .frame(width: width / 1.2, height: height / 7.5)
                                    
                            }
                        
                            
                            Spacer()
                        }
                    }
                    
                    Spacer()
                }
               
            }
        }
       
    }
        func deleteSurvey(at offsets: IndexSet) {
            withAnimation {
                offsets.map { surveys[$0] }
                    .forEach(managedObjContext.delete)
                
                DataController().save(context: managedObjContext)
            }
        }
}

struct SurveyView_Previews: PreviewProvider {
    static let appState = AppState()
    
    static var previews: some View {
        SurveyView()
            .environmentObject(appState)
    }
}
