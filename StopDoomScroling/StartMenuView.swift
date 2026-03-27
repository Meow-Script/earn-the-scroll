//
//  StartMenuView.swift
//  StopDoomScroling
//
//  Created by Brian Bernal on 3/25/26.
//
import SwiftUI

struct StartMenuView: View{
    @Binding var started: Bool
    @Binding var page2Started: Bool
    @Binding var page3Started: Bool
    
    var body: some View{
        VStack{
            Button("Start App", action: startGame)
                .padding()
            Button("Shop", action: tokenShop)
                .padding()
            Button("Completed Tasks", action: gameHistory)
                .padding()
        } }
    func startGame(){
        started = true
        page2Started = false
        page3Started = false
    }
    
    func tokenShop(){
        started = false
        page2Started = false
        page3Started = true
    }
    
    func gameHistory(){
        started = false
        page2Started = true
        page3Started = false
    }
    
}
