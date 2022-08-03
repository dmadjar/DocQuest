//
//  FinishedSurvey.swift
//  DocQuest
//
//  Created by Daniel Madjar on 7/25/22.
//

import SwiftUI

struct FinishedSurvey: View {
    @EnvironmentObject var appState : AppState
    
    let width = UIScreen.main.bounds.width
    let height = UIScreen.main.bounds.height
    
    var body: some View {
        ZStack {
            Color("backgroundElement").ignoresSafeArea()
            
            VStack(spacing: 10) {
                Spacer()
                
                Text("Finished Survey")
                    .foregroundColor(Color("shadowColor"))
                    .bold()
                    .font(.system(size: 45))
               
                Text("Await further instructions from your doctor!")
                    .foregroundColor(Color("shadowColor"))
                    .bold()
                    .font(.system(size: 15))
                
                Spacer()
                
                Image(systemName: "checkmark.circle")
                    .resizable()
                    .frame(width: width / 1.5, height: width / 1.5)
                    .foregroundColor(Color("shadowColor"))
                
                Spacer()
                
                Spacer()
                
                Spacer()
                
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
                .frame(height: height / 10)
            }
        }
    }
}

struct FinishedSurvey_Previews: PreviewProvider {
    static var previews: some View {
        FinishedSurvey()
    }
}
