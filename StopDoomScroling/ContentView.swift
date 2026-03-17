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
    
    
   // @State private var taskToEdit: Task?
    
    
    
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





struct MainView: View{
    @Binding var started: Bool
    @State private var userTask = ""
    @Binding var userList: [Task]
    @Binding var completedTasks: [Task]
    @Binding var points: Int
    @State private var editedTitle = ""
    @State private var taskBeingEdited: Task?
    @State private var taskToConfirm: Task?
    @State private var deleteTaskToConfirm: Task?
    @State private var selectedTask: Task?
    @State private var expandedTaskID: UUID?
    
    
    var body: some View{
        VStack{
            HStack{
                Button("Back to Menu", action: backToMenu)
                    .padding(.leading)
                    .padding(.top)
                Spacer() }
            
            
            ZStack {
                Circle()
                    .fill(.thinMaterial)
                    .frame(width: 100, height: 100)
                    .shadow(radius: 5)
                
                Image(systemName: "person.fill")
                    .font(.system(size: 40))  }
            Spacer()
            
            
            Text("Points: \(points)")
            
            //This is the text entry section
            TextField("Enter a task for today!", text:$userTask)
                .textFieldStyle(.roundedBorder)
                .padding()
            
            Button("ADD TASK"){
                if !userTask.isEmpty{
                    userList.append(Task(title: userTask))
                    userTask = ""
                } }
            
            //this is jsut temporary
            Button("resset to 0"){
                points = 0
            }
            .padding(.bottom)
            Button("add 10 points"){
                points += 10
            }
            
            
            
            //The list
            List(userList) { item in
                VStack{
                    HStack{
                        Text(item.title)
                        Spacer()
                        
                        Button("👉  ⚙️"){
                            taskToConfirm = item
                            
                        }
                        // .buttonStyle(.plain)
                    }
                        
                        if expandedTaskID == item.id {
                            Divider()
                            
                                HStack{
                                    Button("✅"){
                                        taskToConfirm = item
                                        
                                    }
                                     .buttonStyle(.plain)
                                    Spacer()
                                    
                                    Button("✏️"){
                                        taskBeingEdited = item
                                        editedTitle = item.title
                                        
                                    }
                                    .buttonStyle(.plain)
                                    Spacer()
                                    
                                    ///ADDDDD ALERT so no accidental delletion
                                    Button("🗑️"){
                                        deleteTaskToConfirm = item
                                        //userList.removeAll{ $0.id == item.id}
                                    }
                                    .buttonStyle(.plain)
                                    .alert(item: $deleteTaskToConfirm){task in
                                        Alert(
                                            title: Text("Are you sure you want to delete task?"),
                                            message: Text("Once confimred deleted for ever"),
                                            primaryButton: .destructive(Text("Delete")){
                                                userList.removeAll{ $0.id == task.id}   },
                                            secondaryButton: .cancel())}
                                    
                                    //Spacer()
                                }
                                .padding()
                            }
                        }
                .contentShape(Rectangle())
                .onTapGesture {
                    withAnimation {
                        if expandedTaskID == item.id {
                            expandedTaskID = nil
                        } else {
                            expandedTaskID = item.id
                        }
                    }
                }
            }
                .animation(.easeInOut, value: expandedTaskID)
                }
                .alert(item: $taskToConfirm) { task in
                    Alert(
                        title: Text("Have you completed your Task?"),
                        message: Text("Be honest"),
                        primaryButton: .destructive(Text("DONE")) {
                            points += 10
                            completedTasks.append(task)
                            userList.removeAll{$0.id == task.id}    },
                        secondaryButton: .cancel()
                    )
                }
                .sheet(item: $taskBeingEdited) { task in
                    VStack(spacing: 20) {
                        Text("Edit Task")
                            .font(.headline)
                        
                        TextField("Edit task", text: $editedTitle)
                            .textFieldStyle(.roundedBorder)
                            .padding()
                        
                        Button("Save") {
                            if let index = userList.firstIndex(of: task) {
                                userList[index].title = editedTitle
                                
                                
                            }
                            taskBeingEdited = nil
                        }
                        
                        Button("Cancel") {
                            taskBeingEdited = nil
                        }
                    }
                    .padding(0)
                }
            }
                
func backToMenu(){
    started = false }
}
    





//For completed list you should add a feature where if you completed it by accident it removes the points gained

struct CompletedList: View{
    @Binding var page2Started: Bool
    @Binding var completedTasks: [Task]
    
    @State private var taskToConfirm2: Task?
    @State private var expandedTaskID: UUID?
    @State private var editedTitle = ""
    @State private var taskBeingEdited: Task?
    @State private var deleteTaskToConfirm: Task?
    @Binding var userList: [Task]



    
    //You have the blue prints to add the drop down menu
    var body: some View {
        VStack{
            HStack{
                Button("Back to Menu", action: backToMenu)
                    .padding(.leading)
                    .padding(.top)
                Spacer()
                
            }
            
            Text("\n🤘 COMPLETED TASKS 🤘")
                .bold()
            //Spacer()
            List(completedTasks) { item in
                VStack{
                    HStack{
                        Text(item.title)
                        //Divider()
                        
                        Spacer()
                        Button(""){
                            taskToConfirm2 = item
                        }
                    }
                    
                    if expandedTaskID == item.id {
                        Divider()
                        
                        HStack{
                            
                            Button("✏️"){
                                taskBeingEdited = item
                                editedTitle = item.title
                            }
                            .buttonStyle(.plain)
                            Spacer()
                            
                            ///ADDDDD ALERT so no accidental delletion
                            Button("🗑️"){
                                deleteTaskToConfirm = item
                                //userList.removeAll{ $0.id == item.id}
                            }
                            .buttonStyle(.plain)
                            .alert(item: $deleteTaskToConfirm){task in
                                Alert(
                                    title: Text("Are you sure you want to delete task?"),
                                    message: Text("Once confimred deleted for ever"),
                                    primaryButton: .destructive(Text("Delete")){
                                        completedTasks.removeAll{ $0.id == item.id}   },
                                    secondaryButton: .cancel())}
                                
                                //Spacer()
                                
                            }
                            .padding()
                            
                        }
                    }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            withAnimation {
                                if expandedTaskID == item.id {
                                    expandedTaskID = nil
                                } else {
                                    expandedTaskID = item.id
                                }
                            }
                        }
                    
                    
                        .sheet(item: $taskBeingEdited) { task in
                            VStack(spacing: 20) {
                                Text("Edit Task")
                                    .font(.headline)
                                
                                TextField("Edit task", text: $editedTitle)
                                    .textFieldStyle(.roundedBorder)
                                    .padding()
                                
                                Button("Save") {
                                    if let index = completedTasks.firstIndex(of: task) {
                                        completedTasks[index].title = editedTitle
                                    }
                                    taskBeingEdited = nil
                                }
                                
                                Button("Cancel") {
                                    taskBeingEdited = nil
                                }
                            }
                            .padding(0)
                            
                        }
                }
            }
        }
    
    func backToMenu(){
        page2Started = false
    }
}



struct ShopStore: View{
    @Binding var page3Started: Bool
    @Binding var points: Int
    
    @State private var shopBuy = false
    
    
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
                    if points < 30{
                        print("You need 30 points !")
                    } else if points >= 30{
                        shopBuy = true
                        points -= 30
                        
                    }
                }
                .padding()
                
                Button("30 Minute D S"){
                    if points < 50{
                        print("You need 50 points !")
                    } else if points >= 50{
                        shopBuy = true
                       // var selection: String = "a"
                        //points -= 50
                    }
                }
                .padding()
                
                Button("1 Hour D S"){
                    if points < 80{
                        print("You need 80 points !")
                    } else if points >= 80{
                        shopBuy = true
                        points -= 80
                    }
                    
                }
                .padding()
            }
            .bold()
            .font(.title)
            .alert(isPresented: $shopBuy){
                Alert(title: Text("Do You want to purchase this!?"),
                      message: Text("DSC will be withdrawn"),
                      primaryButton: .default(Text("YES")){
                  //  if selection = "a"{ //THIS IS WHERE YOU LEFT OFF, YOU WERE TRYING TO MAKE IT SO WHEN EVER A OPTION IS PICKED POINTS WERE REMOVED
                  //      points -= 50

                    //}
                },
                      secondaryButton: .cancel(Text("NO")))
            }
            
                
            }
            
            Spacer()
        
            
            
        }
        
    
            func backToMenu(){
                page3Started = false
            }
    
}

#Preview {
    ContentView()
    }

//THIS IS A GIT TEST 
