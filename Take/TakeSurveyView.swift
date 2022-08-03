//
//  TakeSurveyView.swift
//  DocQuest
//
//  Created by Daniel Madjar on 7/21/22.
//

import SwiftUI

struct TakeSurveyView: View {
    @EnvironmentObject var surveyMap : SurveyMap
    @EnvironmentObject var submit : Submit
    @EnvironmentObject var appState : AppState
    
    @Environment(\.managedObjectContext) var managedObjContext
    @FetchRequest(sortDescriptors: []) var surveys: FetchedResults<SurveyEntity>
    
    let width = UIScreen.main.bounds.size.width
    let height = UIScreen.main.bounds.size.height
    
    var body: some View {
        NavigationView {
            ZStack {
                Color("backgroundElement").ignoresSafeArea()
                
                VStack {
                    ScrollView {
                        ForEach(surveys) { survey in
                            NavigationLink(destination: PatientSurvey(surveyName: survey.name!)
                                                                .environmentObject(surveyMap)
                                                                .environmentObject(submit)
                                                                .environmentObject(appState)) {
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
                                            
                                            Image(systemName: "chevron.right")
                                                .renderingMode(.template)
                                                .resizable()
                                                .frame(width: 10, height: 15)
                                                .foregroundColor(Color("shadowColor"))
                                        }
                                        .padding(.horizontal, 50)
                                    }
                                    
                                    Spacer()
                                        .frame(height: 10)
                                }
                            }
                        }
                        .navigationBarTitle(Text("Take A Survey"))
                    }
                    
                    HStack {
                        Button {
                            appState.selection = 1
                            appState.recentView = 4
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
                    }
                    .frame(width: width / 1.2, height: height / 10, alignment: .leading)
                }
            }
            
        }
    }
}

struct TakeSurveyView_Previews: PreviewProvider {
    static var previews: some View {
        TakeSurveyView()
    }
}
