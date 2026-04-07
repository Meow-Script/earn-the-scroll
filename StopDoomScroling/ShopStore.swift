//
//  ShopStore.swift
//  StopDoomScroling
//
//  Created by Brian Bernal on 3/25/26.
//

import SwiftUI


struct ShopStore: View{
    @State private var shopBuy = false
    @State private var selectedItem: String? = nil
    
    @Binding var points: Int
    @Binding var currentScreen: CurrentScreen
    
    
    var body: some View{
        VStack{
            HStack{
                Button("Back to Menu", action: backToMenu)
                    .padding(.leading)
                    .padding(.top)
                Spacer()
            }
            Text("Scrolling Shop")
            Text("Points: \(points)")
            Spacer()
            
            VStack{
                
                Button("15 Minute D S"){
                    selectedItem = "15Min"
                    shopBuy = true
                }
                .padding()
                
                Button("30 Minute D S"){
                  selectedItem = "30Min"
                  shopBuy = true
                }
                .padding()
                
                Button("1 Hour D S"){
                    selectedItem = "1Hour"
                    shopBuy = true
                    
                }
                .padding()
            }
            .bold()
            .font(.title)
            .alert(isPresented: $shopBuy){
                Alert(title: Text("Do You want to purchase this!?"),
                      message: Text("DSC will be withdrawn"),
                      primaryButton: .default(Text("YES")){
                 
                    buyTime()
                    shopBuy = false
                   
                            
                },
                      secondaryButton: .cancel(Text("NO")))
            }
            
                
            }
            
            Spacer()
        
            
            
        }
        
    
            func backToMenu(){
                currentScreen = .startMenu
            }
    
  
    
    func buyTime(){
        let prices = [
            "15Min": 30,
            "30Min": 50,
            "1Hour": 80
        ]
        
        guard let selectedItem = selectedItem else{
            print("No item selected")
            return
        }
        
        guard let cost = prices[selectedItem] else {
            print("invalid item")
            return
        }
        guard points >= cost else{
            print("You need \(cost - points) points!")
            return
        }
        shopBuy = true
        points -= cost
      
    }
  
    
}
