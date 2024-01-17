//
//  ContentView.swift
//  Animations
//
//  Created by ahmad kaddoura on 1/16/24.
//


import SwiftUI

struct CornerRotateModifier : ViewModifier{
    let amount : Double
    let anchor  : UnitPoint
    
    func body(content : Content) -> some View{
        content
            .rotationEffect(.degrees(amount),anchor: anchor)
            .clipped()
    }
    
    
}

struct SlideModifier : ViewModifier{
    let amount : Double
    
    func body(content : Content) -> some View{
        content
            .offset(y:amount)
            .clipped()
    }
    
    
}

extension AnyTransition{
    static var slide1 : AnyTransition{
        .modifier(active: SlideModifier(amount: 800), identity: SlideModifier(amount:0)
        )
    }
    
    static var slide2 : AnyTransition{
        .modifier(active: SlideModifier(amount: -800), identity: SlideModifier(amount:0)
        )
    }
    static var pivot : AnyTransition{
        .modifier(active: CornerRotateModifier(amount: 270, anchor: .bottomLeading), identity: CornerRotateModifier(amount:0,anchor: .bottomLeading)
        )
    }
}

struct ContentView: View {
    
    @State private var animationAmt = 0.0
    @State private var rad = 0.5
    @State private var colorChange = false
    @State private var dragAmt = CGSize.zero
    @State private var explicitAnimation = false
    
    @State private var bgColor = Color.black
    
    let letters = Array("Hello World!")
    
    func randomColor() -> Color {
        let r = Double.random(in: 0...1)
        let g = Double.random(in: 0...1)
        let b = Double.random(in: 0...1)
        
        return Color(red: r, green: g, blue: b)
    }
    
    @State private var enabled = false
    var body: some View {
        VStack{
            Button("Reset Scale"){
                rad = 0.5
            }
            Toggle("Use Explicit Animation", isOn: $explicitAnimation)
                            .padding()
            LinearGradient(colors: [.purple,.red,.orange,.yellow,.green,.blue,.indigo], startPoint: .topLeading, endPoint: .bottomTrailing)
                .frame(width: .infinity,height: 150)
                .offset(dragAmt)
                .gesture(
                    DragGesture()
                        .onChanged{dragAmt = $0.translation}
                        // }
                        .onEnded{ _ in
                            if explicitAnimation {
                                withAnimation(.linear) {
                                    dragAmt = .zero
                                }
                            } else {
                                dragAmt = .zero
                                                        }
                        }
                )
                .animation(explicitAnimation ? .linear : .bouncy, value: dragAmt)
                //technically they're both implicit
            
            HStack(spacing: 0){
                ForEach(0..<letters.count,id:\.self){num in Text(String(letters[num]))
                        .padding(5)
                        .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                        .background(colorChange ? .blue : .pink)
                        .offset(dragAmt)
                        .animation(.linear.delay(Double(num)/20), value: dragAmt)
                }
            }.gesture(
                DragGesture()
                    .onChanged{dragAmt = $0.translation}
                    .onEnded{_ in
                        dragAmt = .zero
                        colorChange.toggle()}
                
            )
            ZStack{
                Rectangle()
                    .fill(.blue)
                    .frame(width:200,height:200)
                
                if explicitAnimation{
                    Rectangle()
                        .fill(.green)
                        .frame(width: 200,height: 200)
                        .transition(.slide1)
                }else{
                    Rectangle()
                        .fill(.red)
                        .frame(width: 200,height: 200)
                        .transition(.slide2)
                }
            }.onTapGesture {
                withAnimation{
                    explicitAnimation.toggle()
                }
            }
            
            
            ZStack{
                
                Button("Tap"){
                    withAnimation{
                        enabled.toggle()
                        animationAmt += 360.0
                    }
                    bgColor = randomColor()
                    colorChange.toggle()
                    rad = (rad > 0.75) ? 0.75 : (rad + 0.05)
                }
                .padding(150)
                .background(bgColor)
                .foregroundStyle(.white)
                .clipShape(.rect(cornerRadius: colorChange ? 20 : 0) )
                .scaleEffect(rad)
                .animation(.default, value: colorChange)
                /*.rotation3DEffect(
                    .degrees(animationAmt),
                    axis: (x: 0.0, y: 1.0, z: 0.0)
                )*/
                .animation(.bouncy,value: colorChange)
                .onTapGesture {
                    withAnimation{
                        enabled.toggle()
                    }
                }
                }
            }
        }
    }


#Preview {
    ContentView()
}
