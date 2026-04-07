//
//  ContentView.swift
//  StopDoomScroling
//
//  Created by Brian Bernal on 1/30/26.
//

import SwiftUI

struct Task: Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    var title: String
    var isCompleted: Bool = false
}

struct ContentView: View {
    @State private var currentScreen: CurrentScreen = .startMenu
    @State private var userList: [Task] = []
    @State private var completedTasks: [Task] = []
    @State var points = 0
    
    var body: some View {
        VStack{
            switch currentScreen {
            case .startMenu:
                StartMenuView(currentScreen: $currentScreen)
            case .taskScreen:
                MainView(
                    userList: $userList,
                    completedTasks: $completedTasks,
                    points: $points,
                    currentScreen: $currentScreen)
            case .doomShop:
                ShopStore(
                    points: $points,
                    currentScreen: $currentScreen)
            case .completedTasks:
                CompletedList(completedTasks: $completedTasks, userList: $userList, currentScreen: $currentScreen)
            }
        }
        .onAppear{
            //This boots up past points
            points = UserDefaults.standard.integer(forKey: "points")
       
            //this boots up all completed tasks
        if let data = UserDefaults.standard.data(forKey: "completedTasks"),
           let decoded = try? JSONDecoder().decode([Task].self, from: data) {
            completedTasks = decoded
        }
            //THIS IS FOR THE MAIN LIST
            if let data = UserDefaults.standard.data(forKey: "userList"),
               let decoded = try? JSONDecoder().decode([Task].self, from: data) {
                userList = decoded
            }
    }
            .onChange(of: points){
                UserDefaults.standard.set(points, forKey: "points")
            } .onChange(of: completedTasks){
                UserDefaults.standard.set(try? JSONEncoder().encode(completedTasks), forKey: "completedTasks")
                } .onChange(of: userList){
                UserDefaults.standard.set(try? JSONEncoder().encode(userList), forKey: "userList")
        }
    }
}




#Preview {
    ContentView()
    }
