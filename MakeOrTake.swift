//
//  MakeOrTake.swift
//  DocQuest
//
//  Created by Daniel Madjar on 7/13/22.
//

import SwiftUI

struct MakeOrTake: View {
    
    @EnvironmentObject var appState : AppState
    
    let width = UIScreen.main.bounds.size.width
    let height = UIScreen.main.bounds.size.height
    
    var body: some View {
        ZStack {
            Color("backgroundElement").ignoresSafeArea()
            
            VStack {   
                Text("DocQuest")
                    .foregroundColor(Color("shadowColor"))
                    .bold()
                    .font(.system(size: 60))
                
                Spacer()
                    .frame(height: height / 5)
                
                Button {
                    withAnimation {
                        appState.recentView = 2
                        appState.selection = 1
                    }
                } label : {
                    ZStack {
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color("backgroundElement"))
                            .shadow(color: .white, radius: 14, x: -9, y: -9)
                            .shadow(color: Color("shadowColor"), radius: 10, x: 9, y: 9)
                            .frame(width: width / 1.75, height: height / 15)
                        
                        Text("Make A Survey")
                            .foregroundColor(Color("shadowColor"))
                            .bold()
                            .font(.system(size: 25))
                    }
                }
                
                Spacer()
                    .frame(height: height / 15)
                
                Button {
                    appState.selection = 4
                } label : {
                    ZStack {
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color("backgroundElement"))
                            .shadow(color: .white, radius: 14, x: -9, y: -9)
                            .shadow(color: Color("shadowColor"), radius: 10, x: 9, y: 9)
                            .frame(width: width / 1.75, height: height / 15)
                        
                        Text("Take A Survey")
                            .foregroundColor(Color("shadowColor"))
                            .bold()
                            .font(.system(size: 25))
                    }
                }
                
                Spacer()
                    .frame(height: height / 10)
                
                
                
                HStack {
                    Text("Add Patient")
                        .foregroundColor(Color("shadowColor"))
                        .bold()
                    
                    Button {
                        appState.selection = 5
                    } label: {
                        ZStack {
                            Circle()
                                .fill(Color("backgroundElement"))
                                .shadow(color: .white, radius: 14, x: -9, y: -9)
                                .shadow(color: Color("shadowColor"), radius: 10, x: 9, y: 9)
                                .frame(width: 35, height: 35)
                               
                                
                            Image(systemName: "person.fill")
                                .renderingMode(.template)
                                .resizable()
                                .frame(width: 20, height: 20)
                                .foregroundColor(Color("shadowColor"))
                        }
                    }
                }
            }
        }
    }
}

struct MakeOrTake_Previews: PreviewProvider {
    static var previews: some View {
        MakeOrTake()
    }
}
