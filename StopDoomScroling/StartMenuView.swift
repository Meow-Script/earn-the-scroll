//
//  StartMenuView.swift
//  StopDoomScroling
//
//  Created by Brian Bernal on 3/25/26.
//
import SwiftUI

enum CurrentScreen {
    case startMenu
    case taskScreen
    case doomShop
    case completedTasks
}

struct StartMenuView: View{
    @Binding var currentScreen: CurrentScreen
    
    var body: some View{
        VStack{
            Button("Start App"){
                currentScreen = .taskScreen
            }
            .padding()
            Button("Shop"){
                currentScreen = .doomShop
            }
            .padding()
            Button("Completed Tasks"){
                currentScreen = .completedTasks
                
            }
            .padding()
        }
    }
    
}
