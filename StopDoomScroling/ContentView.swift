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
    @State private var started = false
    @State private var page2Started = false
    @State private var page3Started = false
    @State private var userList: [Task] = []
    @State private var completedTasks: [Task] = []
    @State var points = 0
    
    var body: some View {
        VStack{
            if started {
                MainView(started: $started, userList: $userList, completedTasks: $completedTasks, points: $points)
            } else if page2Started{
                CompletedList(page2Started: $page2Started,completedTasks: $completedTasks, userList: $userList)
            } else if page3Started{
                ShopStore(page3Started: $page3Started, points: $points)
                }else {
                    StartMenuView(started: $started, page2Started: $page2Started, page3Started: $page3Started) }
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
