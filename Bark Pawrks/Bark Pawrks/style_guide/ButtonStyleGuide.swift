//
//  ButtonStyleGuide.swift
//  Bark Pawrks
//
//  Created by Amelia Martin on 10/28/22.
//

import SwiftUI

struct ButtonStyleGuide: View {
    var body: some View {
        VStack{
        Text("Button Styles")
            
            Button {
                
            } label: {
                Text("small primary button")
            }.buttonStyle(PrimaryButtonStyle())
    
            
            Button {
                
            } label: {
                Text("small primary button - disabled")
            }.buttonStyle(PrimaryButtonStyle())
                .disabled(true)
        }
    }
}

struct PrimaryButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) var isEnabled
    
    var shadowColor:  Color{ isEnabled ? Color("button-shadow-green") : Color("disabled-shadow")
    }
    
    var backgroundColor:  Color{ isEnabled ? Color("AccentColor") : Color("disabled")
    }
    
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            //.modifier(CaptionStyle())
            .foregroundColor(Color.white)
            .padding(12.5)
            .background(Capsule().fill(backgroundColor)
                .shadow(color: (shadowColor), radius: 5, x: 5, y: 5))
            .scaleEffect(configuration.isPressed ? 0.9 : 1)
    }
}

struct SmallButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) var isEnabled
    
    var shadowColor:  Color{ isEnabled ? Color("button-shadow-green") : Color("disabled-shadow")
    }
    
    var backgroundColor:  Color{ isEnabled ? Color("AccentColor") : Color("disabled")
    }
    
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            //.modifier(CaptionStyle())
            .foregroundColor(Color.white)
            .padding(5)
            .background(Capsule().fill(backgroundColor)
                .shadow(color: (shadowColor), radius: 5, x: 5, y: 5))
            .scaleEffect(configuration.isPressed ? 0.9 : 1)
    }
}
struct ButtonStyleGuide_Previews: PreviewProvider {
    static var previews: some View {
        ButtonStyleGuide()
    }
}
