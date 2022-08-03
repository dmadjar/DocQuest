//
//  EnterPasscode.swift
//  DocQuest
//
//  Created by Daniel Madjar on 7/19/22.
//

import SwiftUI

struct EnterPasscode: View {
    @EnvironmentObject var firstLaunch : FirstLaunch
    @EnvironmentObject var appState : AppState
    @State var isFilledArray : [Bool] = [false, false, false, false, false, false]
    @State var buttonsClicked : Int = 0
    @State var comparisonString : String = ""
    @State var attempts = 0
    
    
    var body: some View {
        
        ZStack {
            Color("backgroundElement").ignoresSafeArea()
            
            VStack(spacing: 25) {
                
                Spacer()
                
                Text("Enter Passcode")
                    .foregroundColor(Color("shadowColor"))
                    .bold()
                    .font(.system(size: 20))
                
                VStack(spacing: 20) {
                    HStack(spacing: 15) {
                        filledCircles(isFilled: $isFilledArray)
                            .modifier(Shake(animatableData: CGFloat(attempts)))
                    }
                }
                
                Spacer()
                
                Group {
                    HStack(spacing: 25) {
                        CodeButtonTwo(buttonClicked: $buttonsClicked, isFilledArray: $isFilledArray, comparisonString: $comparisonString, text: "1", attempts: $attempts)
                        
                        CodeButtonTwo(buttonClicked: $buttonsClicked, isFilledArray: $isFilledArray, comparisonString: $comparisonString, text: "2", attempts: $attempts)
                        
                        CodeButtonTwo(buttonClicked: $buttonsClicked, isFilledArray: $isFilledArray, comparisonString: $comparisonString, text: "3", attempts: $attempts)
                            
                    }
                    
                    HStack(spacing: 25) {
                        CodeButtonTwo(buttonClicked: $buttonsClicked, isFilledArray: $isFilledArray, comparisonString: $comparisonString, text: "4", attempts: $attempts)
                        
                        CodeButtonTwo(buttonClicked: $buttonsClicked, isFilledArray: $isFilledArray, comparisonString: $comparisonString, text: "5", attempts: $attempts)
                        
                        CodeButtonTwo(buttonClicked: $buttonsClicked, isFilledArray: $isFilledArray, comparisonString: $comparisonString, text: "6", attempts: $attempts)
                    }
                    
                    HStack(spacing: 25) {
                        CodeButtonTwo(buttonClicked: $buttonsClicked, isFilledArray: $isFilledArray, comparisonString: $comparisonString, text: "7", attempts: $attempts)
                        
                        CodeButtonTwo(buttonClicked: $buttonsClicked, isFilledArray: $isFilledArray, comparisonString: $comparisonString, text: "8", attempts: $attempts)
                        
                        CodeButtonTwo(buttonClicked: $buttonsClicked, isFilledArray: $isFilledArray, comparisonString: $comparisonString, text: "9", attempts: $attempts)
                    }
                    
                    CodeButtonTwo(buttonClicked: $buttonsClicked, isFilledArray: $isFilledArray, comparisonString: $comparisonString, text: "0", attempts: $attempts)
                }
                
                HStack {
                    Spacer()
                    
                    Button {
                        if comparisonString.count < 6  && comparisonString.count > 0 {
                           deleteNumber()
                        }
                    } label : {
                        Text("Delete")
                            .foregroundColor(Color("shadowColor"))
                            .bold()
                    }
                }
                .padding(.horizontal, 30)
                
                Spacer()

            }
        }
      
    }
    
    func deleteNumber() {
        comparisonString = String(comparisonString.dropLast())
        buttonsClicked -= 1
        isFilledArray[buttonsClicked] = false
    }
}

struct EnterPasscode_Previews: PreviewProvider {
    static var firstLaunch = FirstLaunch()
    
    static var previews: some View {
        EnterPasscode()
            .environmentObject(firstLaunch)
    }
}

struct CodeButtonTwo: View {
    @EnvironmentObject var appState : AppState
    @EnvironmentObject var firstLaunch : FirstLaunch
    @Binding var buttonClicked : Int
    @Binding var isFilledArray : [Bool]
    @Binding var comparisonString : String
    
    var text : String
    @Binding var attempts : Int
    
    var body: some View {
        Button(action: {
                
                addNumber()
            
                print(comparisonString)
            
                if comparisonString.count == 6 {
                    if !checkEqual() {
                       resetPasscode()
                    } else if checkEqual() {
                        changePage()
                    }
                }
        }){
            Text(text)
                .padding()
                .foregroundColor(Color("shadowColor"))
                .font(.system(size: 45))
                .frame(width: 75, height: 75)
                .background(Color("backgroundElement"))
                .clipShape(Circle())
                .shadow(color: .white, radius: 14, x: -9, y: -9)
                .shadow(color: Color("shadowColor"), radius: 10, x: 9, y: 9)
        }
    }
    
    func checkEqual() -> Bool {
        if firstLaunch.confirmedPasscode == comparisonString {
            return true
        } else {
            return false
        }
    }
    
    func addNumber() {
        comparisonString += text
        
        withAnimation {
            isFilledArray[buttonClicked] = true
        }
        
        buttonClicked += 1
    }
    
    func resetPasscode() {
        comparisonString = ""
        buttonClicked = 0
        withAnimation(.default) {
            attempts += 1
        }
        
        for i in 0..<isFilledArray.count {
            withAnimation {
                isFilledArray[i] = false
            }
        }
    }
    
    func changePage() {
        if appState.recentView == 2 {
            appState.selection = 3
        } else if appState.recentView == 4 {
            appState.selection = 2
        }    
    }
}

struct Shake: GeometryEffect {
    var amount: CGFloat = 10
    var shakesPerUnit = 3
    var animatableData: CGFloat

    func effectValue(size: CGSize) -> ProjectionTransform {
        ProjectionTransform(CGAffineTransform(translationX:
            amount * sin(animatableData * .pi * CGFloat(shakesPerUnit)),
            y: 0))
    }
}
