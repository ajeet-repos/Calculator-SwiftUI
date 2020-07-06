//
//  ContentView.swift
//  Calculator SwiftUI
//
//  Created by Ajeet Kumar on 06/07/20.
//  Copyright © 2020 DigitalCurry. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    let rows = [
        ["7", "8", "9", "/"],
        ["4", "5", "6", "x"],
        ["1", "2", "3", "-"],
        [".", "0", "=", "+"]
    ]
    
    @State var noBeingEntered: String = ""
    @State var finalValue:String = "DigitalCurry Recepie"
    @State var calExpression: [String] = []
    
    
    var body: some View {
        VStack {
            VStack {
                Text(self.finalValue)
                    .font(Font.custom("HelveticaNeue-Thin", size: 78))
                    .frame(idealWidth: 100, maxWidth: .infinity, idealHeight: 100, maxHeight: .infinity, alignment: .center)
                    .foregroundColor(Color.white)
                Text(flattenTheExpression(exps: calExpression))
                    .font(Font.custom("HelveticaNeue-Thin", size: 24))
                    .frame(alignment: Alignment.bottomTrailing)
                    .foregroundColor(Color.white)
                Spacer()
            }
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
            .background(Color.blue)
            VStack {
                Spacer(minLength: 48)
                VStack {
                    ForEach(rows, id: \.self) { row in
                        HStack(alignment: .top, spacing: 0) {
                            Spacer(minLength: 13)
                            ForEach(row, id: \.self) { column in
                                Button(action: {
                                    if column == "=" {
                                        self.calExpression = []
                                        self.noBeingEntered = ""
                                        return
                                    } else if checkIfOperator(str: column)  {
                                        self.calExpression.append(column)
                                        self.noBeingEntered = ""
                                    } else {
                                        self.noBeingEntered.append(column)
                                        if self.calExpression.count == 0 {
                                            self.calExpression.append(self.noBeingEntered)
                                        } else {
                                            if !checkIfOperator(str: self.calExpression[self.calExpression.count-1]) {
                                                self.calExpression.remove(at: self.calExpression.count-1)
                                            }
                                            
                                            self.calExpression.append(self.noBeingEntered)
                                        }
                                    }
                                    
                                    self.finalValue = processExpression(exp: self.calExpression)
                                    
                                    print(self.noBeingEntered)
                                }, label: {
                                    Text(column)
                                    .font(.system(size: getFontSize(btnTxt: column)))
                                    .frame(idealWidth: 100, maxWidth: .infinity, idealHeight: 100, maxHeight: .infinity, alignment: .center)
                                })
                                .foregroundColor(Color.white)
                                .background(getBackground(str: column))
                                .mask(CustomShape(radius: 40, value: column))
                            }
                        }
                    }
                }
            }
            .background(Color.black)
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, idealHeight: 414, maxHeight: .infinity, alignment: .topLeading)
        }
        .background(Color.black)
        .edgesIgnoringSafeArea(.all)
    }
}

func getBackground(str:String) -> Color {
    
    if checkIfOperator(str: str) {
        return Color.blue
    }
    return Color.black
}

func getFontSize(btnTxt: String) -> CGFloat {
    
    if checkIfOperator(str: btnTxt) {
        return 28
    }
    return 18
    
}

func checkIfOperator(str:String) -> Bool {
    
    if str == "/" || str == "x" || str == "-" || str == "+" || str == "=" {
        return true
    }
    
    return false
    
}

func flattenTheExpression(exps: [String]) -> String {
    
    var calExp = ""
    for exp in exps {
        calExp.append(exp)
    }
    
    return calExp
    
}

func processExpression(exp:[String]) -> String {
    
    if exp.count < 3 {
        return "0.0"
    }
    
    var a = Double(exp[0])
    var c = Double("0.0")
    let expSize = exp.count
    
    for i in (1...expSize-2) {
        
        c = Double(exp[i+1])
        
        switch exp[i] {
        case "+":
            a! += c!
        case "-":
            a! -= c!
        case "x":
            a! *= c!
        case "/":
            a! /= c!
        default:
            print("skipping the rest")
        }
    }
    
    return String(format: "%.1f", a!)
}

struct CustomShape: Shape {
    let radius: CGFloat
    let value: String
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let tl = CGPoint(x: rect.minX, y: rect.minY)
        let tr = CGPoint(x: rect.maxX, y: rect.minY)
        let br = CGPoint(x: rect.maxX, y: rect.maxY)
        let bl = CGPoint(x: rect.minX, y: rect.maxY)
        
        let tls = CGPoint(x: rect.minX, y: rect.minY+radius)
        let tlc = CGPoint(x: rect.minX + radius, y: rect.minY+radius)
        
        path.move(to: tr)
        path.addLine(to: br)
        path.addLine(to: bl)
        if value == "/" || value == "=" {
            path.addLine(to: tls)
            path.addRelativeArc(center: tlc, radius: radius, startAngle: Angle.degrees(90), delta: Angle.degrees(180))
        } else {
            path.addLine(to: tl)
        }
        
    
        
        return path
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
