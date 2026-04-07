//
//  MainView.swift
//  StopDoomScroling
//
//  Created by Brian Bernal on 3/25/26.
//

import SwiftUI

struct TaskButton: Identifiable{
    let id = UUID()
    let label: String
    let action: () -> Void
}

struct MainView: View{
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
    
    @Binding var currentScreen: CurrentScreen

    
    
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
                            if expandedTaskID == item.id {
                                expandedTaskID = nil
                            } else {
                                expandedTaskID = item.id
                            }
                            
                        }
                    }
                        
                        if expandedTaskID == item.id {
                            Divider()
                            
                            let buttons = [
                                TaskButton(label: "✅", action: {
                                    taskToConfirm = item}),
                                TaskButton(label: "✏️", action:{
                                    taskBeingEdited = item
                                    editedTitle = item.title}),
                                TaskButton(label: "🗑️", action:{
                                    deleteTaskToConfirm = item})
                            ]

                            HStack(spacing: 100){
                                    
                                    ForEach(buttons) { button in
                                        Button(button.label) {
                                            button.action()
                                        }
                                    }
                                  
                                    .alert(item: $deleteTaskToConfirm){task in
                                        Alert(
                                            title: Text("Are you sure you want to delete task?"),
                                            message: Text("Once confimred deleted for ever"),
                                            primaryButton: .destructive(Text("Delete")){
                                                deleteTask(task: task)  },
                                            secondaryButton: .cancel())}
                                    
                                }
                                .buttonStyle(.plain)
                                .padding()
                            }
                        }
                .contentShape(Rectangle())
               
            }
                .animation(.easeInOut, value: expandedTaskID)
                }
                .alert(item: $taskToConfirm) { task in
                    Alert(
                        title: Text("Have you completed your Task?"),
                        message: Text("Be honest"),
                        primaryButton: .destructive(Text("DONE")) {
                            taskComplete(task: task)
                        },
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
                            updateTask(task: task, title: editedTitle)
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
        currentScreen = .startMenu
    }

    func deleteTask(task: Task){
        userList.removeAll{ $0.id == task.id}
        //🔥 maybe add a - 5 points to penalize the user for making an error
    }
    
    func taskComplete(task: Task) {
        points += 10
        completedTasks.append(task)
        deleteTask(task: task)
    }
    
    func updateTask(task: Task, title: String){
        if let index = userList.firstIndex(of: task) {
            userList[index].title = editedTitle
        }
    }
}
