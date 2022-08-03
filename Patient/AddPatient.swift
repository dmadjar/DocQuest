//
//  AddPatient.swift
//  DocQuest
//
//  Created by Daniel Madjar on 7/23/22.
//

import SwiftUI



struct AddPatient: View {
    @EnvironmentObject var appState : AppState
    
    let width = UIScreen.main.bounds.width
    let height = UIScreen.main.bounds.height
    
    @State var intRepresented = "00000"
    @State var id = 0
    @State var numberTaken = false
    @State var buttonClicked = false
    
    var body: some View {
        ZStack {
            Color("backgroundElement").ignoresSafeArea()
            
            VStack {
                Spacer()
                
                Button {
                    buttonClicked.toggle()
                } label: {
                    Text("Delete All Patients")
                        .foregroundColor(.red)
                        .bold()
                }
                .alert("Remove Patients", isPresented: $buttonClicked) {
                    Button(role: .destructive) {
                        clearPatients()
                        print(appState.patients)
                    } label: {
                        Text("Yes")
                    }
                } message: {
                    Text("Are you sure you want to delete all patient ID's?")
                }
                
                Spacer()
                
                Group {
                    Text("To keep information confidential, it is up to the doctor using the app to store which user ID is connected to which patient.")
                        .foregroundColor(Color("shadowColor"))
                        .bold()
                        .frame(width: width / 1.2)
                        .multilineTextAlignment(.center)
                    
                    Spacer()
                
                
                    Text(idToString(num: id))
                        .foregroundColor(.black)
                        .bold()
                        .font(.system(size: 80))
                    
                    Spacer()
                    
                    Button {
                        id = generateID()
                        intRepresented = String(id)
                        numberTaken = false
                        
                        if !checkNumber(id: id) {
                            appState.patients.append(id)
                        } else {
                            numberTaken = true
                        }
                        
                        print(appState.patients)
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 15)
                                .fill(Color("backgroundElement"))
                                .shadow(color: .white, radius: 1.5, x: -1, y: -1)
                                .shadow(color: Color("shadowColor"), radius: 10, x: 9, y: 9)
                                .frame(width: width / 2.25, height: height / 15)
                            
                            Text("Generate Patient ID")
                                .foregroundColor(Color("shadowColor"))
                                .bold()
                            
                        }
                    }
                }
                
                Spacer()
                
                if numberTaken {
                    Text("Number already in use try again!")
                        .foregroundColor(Color("shadowColor"))
                        .bold()
                }
                
                Spacer()
                
                Spacer()
                
                
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
                }
                .frame(width: width / 1.2, height: height / 10, alignment: .leading)
                
            }
        }
    }
    
    func generateID() -> Int {
        let id = Int.random(in: 1...10000)
        
        return id
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
    
    func checkNumber(id: Int) -> Bool {
        if appState.patients.contains(id) {
            return true
        } else {
            return false
        }
    }
    
    func clearPatients() {
        appState.patients.removeAll()
    }
}

struct AddPatient_Previews: PreviewProvider {
    static var previews: some View {
        AddPatient()
    }
}
