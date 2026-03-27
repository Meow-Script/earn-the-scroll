//
//  ShopStore.swift
//  StopDoomScroling
//
//  Created by Brian Bernal on 3/25/26.
//

import SwiftUI


struct ShopStore: View{
    @Binding var page3Started: Bool
    @Binding var points: Int
    
    @State private var shopBuy = false
    @State private var selectedItem: String? = nil
    
    
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
                   if selectedItem == "15Min"{
                       buy15Min()
                       shopBuy = false
                    } else if selectedItem == "30Min"{
                       buy30Min()
                       shopBuy = false
                   } else if selectedItem == "1Hour"{
                        buy1Hour()
                        shopBuy = false
                   } else {
                       print("Brother you have an issue")
                       shopBuy = false
                   }
                   
                            
                },
                      secondaryButton: .cancel(Text("NO")))
            }
            
                
            }
            
            Spacer()
        
            
            
        }
        
    
            func backToMenu(){
                page3Started = false
            }
    
    func buy15Min(){
        if points < 30{
            print("You need 30 points !")
        } else if points >= 30{
            shopBuy = true
            points -= 30
        }
    }
    
    func buy30Min(){
        if points < 50{
            print("You need 50 points !")
        } else if points >= 50{
            shopBuy = true
                points -= 50
            
        }
    }
    
    func buy1Hour(){
        if points < 80{
            print("You need 80 points !")
        } else if points >= 80{
            shopBuy = true
            points -= 80
        }
    }
  
    
}
