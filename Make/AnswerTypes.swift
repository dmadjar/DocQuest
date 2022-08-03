//
//  AnswerTypes.swift
//  DocQuest
//
//  Created by Daniel Madjar on 7/13/22.
//

import SwiftUI



struct radioButton: View {
    var question : String
    @Binding var qToAMap: [String : String]
    @State var yesSelected : Bool = false
    @State var noSelected : Bool = false
    
    var body: some View {
        HStack {
            HStack {
                Text("Yes")
                
                Button {
                    yesSelected = true
                    noSelected = false
                    qToAMap[question] = "Yes"
                } label : {
                    ZStack {
                        Circle()
                            .fill(Color("backgroundElement"))
                            .shadow(color: .white, radius: 14, x: -9, y: -9)
                            .shadow(color: Color("shadowColor"), radius: 10, x: 9, y: 9)
                            .frame(width: 35, height: 35)
                        
                        if yesSelected {
                            Image(systemName: "checkmark")
                                .renderingMode(.template)
                                .resizable()
                                .frame(width: 20, height: 17.5)
                                .foregroundColor(Color("shadowColor"))
                        }
                    }
                }
            }
            
            HStack {
                Text("No")
                
                Button {
                    yesSelected = false
                    noSelected = true
                    qToAMap[question] = "No"
                } label : {
                    ZStack {
                        Circle()
                            .fill(Color("backgroundElement"))
                            .shadow(color: .white, radius: 14, x: -9, y: -9)
                            .shadow(color: Color("shadowColor"), radius: 10, x: 9, y: 9)
                            .frame(width: 35, height: 35)
                        
                        if noSelected {
                            Image(systemName: "checkmark")
                                .renderingMode(.template)
                                .resizable()
                                .frame(width: 20, height: 17.5)
                                .foregroundColor(Color("shadowColor"))
                        }
                    }
                }
            }
        }
    }
}


struct Scale: View {
    var question : String
    @Binding var qToAMap : [String : String]
    @State var percentage: Float = 25.0// or some value binded
    
        var body: some View {
            VStack {
                GeometryReader { geometry in
                    // TODO: - there might be a need for horizontal and vertical alignments
                    ZStack(alignment: .leading) {
                        Rectangle()
                            .fill(Color("backgroundElement"))
                        
                        Rectangle()
                            .foregroundColor(Color("shadowColor"))
                            .frame(width: geometry.size.width * CGFloat(self.percentage / 100))
                    }
                    .cornerRadius(12)
                    .gesture(DragGesture(minimumDistance: 0)
                        .onChanged({ value in
                            // TODO: - maybe use other logic here
                            self.percentage = min(max(0, Float(value.location.x / geometry.size.width * 100)), 100)
                            qToAMap[question] = String(self.percentage)
                        }))
                }
                
                Text("\(percentage)")
                    .foregroundColor(Color("shadowColor"))
            }
        }
}

struct mildMS: View {
    var question : String
    @Binding var qToAMap : [String : String]
    @State var selection : [String] = ["Pick a Severity", "Mild", "Moderate", "Severe"]
    @State var index = 0
    
    var body: some View {
        Menu {
            Button {
                index = 1
                qToAMap[question] = selection[1]
            } label : {
                Text("Mild")
            }
            
                Button {
                    index = 2
                    qToAMap[question] = selection[2]
                } label : {
                    Text("Moderate")
                }
                    
                    Button {
                        index = 3
                        qToAMap[question] = selection[3]
                    } label : {
                        Text("Severe")
                    }
        } label : {
            Text(selection[index])
                .foregroundColor(Color("shadowColor"))
                .bold()
                .padding()
                .background(Color("backgroundElement"))
                .cornerRadius(15)
                .shadow(color: .white, radius: 14, x: -9, y: -9)
                .shadow(color: Color("shadowColor"), radius: 10, x: 9, y: 9)
        }
    }
}

struct textResponseSmall: View {
    var question : String
    @Binding var qToAMap: [String : String]
    @State var response : String = ""
    
    let width = UIScreen.main.bounds.size.width
    let height = UIScreen.main.bounds.size.height
    
    var body: some View {
            TextField("Answer", text: $response)
                .padding(.leading, 12.5)
                .frame(width: width / 3.5, height: height / 17.5)
                .background(Color("shadowColor"))
                .foregroundColor(.black)
                .border(Color("shadowColor"), width: 1)
                .cornerRadius(15)
                .onChange(of: response) { _ in
                    qToAMap[question] = response
                }
    }
    
    func getResponse() -> String {
        return response
    }
    
}

struct textResponseLarge: View {
    var question : String
    @Binding var qToAMap: [String : String]
    @State var response : String = ""
    
    let width = UIScreen.main.bounds.size.width
    let height = UIScreen.main.bounds.size.height
    
    var body: some View {
            TextField("Answer", text: $response)
                .padding(.leading, 12.5)
                .frame(width: width / 1.1, height: height / 17.5)
                .background(Color("shadowColor"))
                .foregroundColor(.black)
                .border(Color("shadowColor"), width: 1)
                .cornerRadius(15)
                .onChange(of: response) { _ in
                    qToAMap[question] = response
                }
    }
}

struct radioButton_Previews: PreviewProvider {
    static var previews: some View {
        Scale(question: "", qToAMap: .constant([String: String]()))
    }
}

