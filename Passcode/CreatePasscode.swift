//
//  CreatePasscode.swift
//  DocQuest
//
//  Created by Daniel Madjar on 7/18/22.
//

import SwiftUI

class FirstLaunch: ObservableObject {
    @AppStorage("Selected") var selected: Int = 0
    @AppStorage("Passcode") var passcode: String = ""
    @AppStorage("ConfirmedPasscode") var confirmedPasscode: String = ""
}

struct CreatePasscode: View {
    @EnvironmentObject var firstLaunch : FirstLaunch
    @EnvironmentObject var appState : AppState
    @State var isFilledArray : [Bool] = [false, false, false, false, false, false]
    @State var isConfirmedFilled : [Bool] = [false, false, false, false, false, false]
    @State var buttonsClicked : Int = 0
    @State var attempts = 0
    
    var body: some View {
        
        ZStack {
            Color("backgroundElement").ignoresSafeArea()
            
            VStack(spacing: 25) {
                
                Spacer()
                
                if firstLaunch.passcode.count < 6 {
                    Text("Create Passcode")
                        .foregroundColor(Color("shadowColor"))
                        .bold()
                        .font(.system(size: 20))
                } else if firstLaunch.passcode.count == 6 {
                    Text("Confirm Passcode")
                        .foregroundColor(Color("shadowColor"))
                        .bold()
                        .font(.system(size: 20))
                }
                
                
                VStack(spacing: 20) {
                    HStack(spacing: 15) {
                        filledCircles(isFilled: $isFilledArray)
                            .modifier(Shake(animatableData: CGFloat(attempts)))
                    }
                    
                    if firstLaunch.passcode.count == 6 {
                        HStack(spacing: 15) {
                            filledCircles(isFilled: $isConfirmedFilled)
                                .modifier(Shake(animatableData: CGFloat(attempts)))
                        }
                    }
                }
                
                Spacer()
                
                Group {
                    HStack(spacing: 25) {
                        CodeButton(isConfirmedFilled: $isConfirmedFilled, buttonClicked: $buttonsClicked, isFilledArray: $isFilledArray, text: "1", attempts: $attempts)
                        
                        CodeButton(isConfirmedFilled: $isConfirmedFilled, buttonClicked: $buttonsClicked, isFilledArray: $isFilledArray, text: "2", attempts: $attempts)
                        
                        CodeButton(isConfirmedFilled: $isConfirmedFilled, buttonClicked: $buttonsClicked, isFilledArray: $isFilledArray, text: "3", attempts: $attempts)
                            
                    }
                    
                    HStack(spacing: 25) {
                        CodeButton(isConfirmedFilled: $isConfirmedFilled, buttonClicked: $buttonsClicked, isFilledArray: $isFilledArray, text: "4", attempts: $attempts)
                        
                        CodeButton(isConfirmedFilled: $isConfirmedFilled, buttonClicked: $buttonsClicked, isFilledArray: $isFilledArray, text: "5", attempts: $attempts)
                        
                        CodeButton(isConfirmedFilled: $isConfirmedFilled, buttonClicked: $buttonsClicked, isFilledArray: $isFilledArray, text: "6", attempts: $attempts)
                    }
                    
                    HStack(spacing: 25) {
                        CodeButton(isConfirmedFilled: $isConfirmedFilled, buttonClicked: $buttonsClicked, isFilledArray: $isFilledArray, text: "7", attempts: $attempts)
                        
                        CodeButton(isConfirmedFilled: $isConfirmedFilled, buttonClicked: $buttonsClicked, isFilledArray: $isFilledArray, text: "8", attempts: $attempts)
                        
                        CodeButton(isConfirmedFilled: $isConfirmedFilled, buttonClicked: $buttonsClicked, isFilledArray: $isFilledArray, text: "9", attempts: $attempts)
                    }
                    
                    CodeButton(isConfirmedFilled: $isConfirmedFilled, buttonClicked: $buttonsClicked, isFilledArray: $isFilledArray, text: "0", attempts: $attempts)
                }
                
                Spacer()
                
                
                HStack {
                    Spacer()
                    
                    Button {
                        if firstLaunch.passcode.count < 6  && firstLaunch.passcode.count > 0 {
                           deleteNumber()
                        } else if firstLaunch.passcode.count == 6 {
                           deleteNumberConfirmed()
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
    
    func resetPasscode() {
        firstLaunch.passcode = ""
        firstLaunch.confirmedPasscode = ""
        buttonsClicked = 0
        
        for i in 0..<isFilledArray.count {
            isFilledArray[i] = false
        }
        
        for i in 0..<isConfirmedFilled.count {
            isConfirmedFilled[i] = false
        }
    }
    
    func deleteNumber() {
        firstLaunch.passcode = String(firstLaunch.passcode.dropLast())
        buttonsClicked -= 1
        isFilledArray[buttonsClicked] = false
    }
    
    func deleteNumberConfirmed() {
        if firstLaunch.confirmedPasscode == "" {
            firstLaunch.passcode = String(firstLaunch.passcode.dropLast())
            buttonsClicked -= 1
            
            isFilledArray[buttonsClicked] = false
        } else {
            firstLaunch.confirmedPasscode = String(firstLaunch.confirmedPasscode.dropLast())
            buttonsClicked -= 1
            
            isConfirmedFilled[buttonsClicked - 6] = false
        }
    }
}


struct CreatePasscode_Previews: PreviewProvider {
    static var firstLaunch = FirstLaunch()
    
    static var previews: some View {
        CreatePasscode()
            .environmentObject(firstLaunch)
    }
}


struct CodeButton: View {
    @EnvironmentObject var appState : AppState
    @EnvironmentObject var firstLaunch : FirstLaunch
    @Binding var isConfirmedFilled : [Bool]
    @Binding var buttonClicked : Int
    @Binding var isFilledArray : [Bool]
    var text : String
    @Binding var attempts : Int
    
    
    var body: some View {
        Button(action: {
            if firstLaunch.passcode.count < 6 {
                addNumber()
            } else if firstLaunch.passcode.count == 6 {
                addNumberConfirmed()
                
                if firstLaunch.confirmedPasscode.count == 6 && !checkEqual() {
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
        if firstLaunch.passcode == firstLaunch.confirmedPasscode {
            return true
        } else {
            return false
        }
    }
    
    func addNumber() {
        firstLaunch.passcode += text
        
        withAnimation {
            isFilledArray[buttonClicked] = true
        }
        
        buttonClicked += 1
    }
    
    func addNumberConfirmed() {
        withAnimation {
            isConfirmedFilled[buttonClicked - 6] = true
        }
        buttonClicked += 1
        firstLaunch.confirmedPasscode += text
    }
    
    func resetPasscode() {
        firstLaunch.passcode = ""
        firstLaunch.confirmedPasscode = ""
        buttonClicked = 0
        withAnimation(.default) {
            attempts += 1
        }
        
        for i in 0..<isFilledArray.count {
            withAnimation {
                isFilledArray[i] = false
            }
        }
        
        for i in 0..<isConfirmedFilled.count {
            withAnimation {
                isConfirmedFilled[i] = false
            }
        }
    }
    
    func changePage() {
        firstLaunch.confirmedPasscode = firstLaunch.passcode
        firstLaunch.selected = 2
        appState.selection = 2
    }
}

struct filledCircles: View {
    
    @EnvironmentObject var firstLaunch : FirstLaunch
    @Binding var isFilled : [Bool]
    
    var body: some View {
        HStack {
            if !isFilled[0] {
                Circle()
                    .stroke(Color("shadowColor"), lineWidth: 2)
                    .frame(width: 25, height: 25)
            } else {
                Circle()
                    .fill(Color("shadowColor"))
                    .frame(width: 25, height: 25)
            }
            
            if !isFilled[1] {
                Circle()
                    .stroke(Color("shadowColor"), lineWidth: 2)
                    .frame(width: 25, height: 25)
            } else {
                Circle()
                    .fill(Color("shadowColor"))
                    .frame(width: 25, height: 25)
            }
            
            if !isFilled[2] {
                Circle()
                    .stroke(Color("shadowColor"), lineWidth: 2)
                    .frame(width: 25, height: 25)
            } else {
                Circle()
                    .fill(Color("shadowColor"))
                    .frame(width: 25, height: 25)
            }
            
            if !isFilled[3] {
                Circle()
                    .stroke(Color("shadowColor"), lineWidth: 2)
                    .frame(width: 25, height: 25)
            } else {
                Circle()
                    .fill(Color("shadowColor"))
                    .frame(width: 25, height: 25)
            }
            
            if !isFilled[4] {
                Circle()
                    .stroke(Color("shadowColor"), lineWidth: 2)
                    .frame(width: 25, height: 25)
            } else {
                Circle()
                    .fill(Color("shadowColor"))
                    .frame(width: 25, height: 25)
            }
            
            if !isFilled[5] {
                Circle()
                    .stroke(Color("shadowColor"), lineWidth: 2)
                    .frame(width: 25, height: 25)
            } else {
                Circle()
                    .fill(Color("shadowColor"))
                    .frame(width: 25, height: 25)
            }
            
            
        }
    }
}
