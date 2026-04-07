//
//  CompletedList.swift
//  StopDoomScroling
//
//  Created by Brian Bernal on 3/25/26.
//

import SwiftUI

struct CompletedList: View{
    @State private var expandedTaskID: UUID?
    @State private var editedTitle = ""
    @State private var taskBeingEdited: Task?
    @State private var deleteTaskToConfirm: Task?
    
    @Binding var completedTasks: [Task]
    @Binding var userList: [Task]
    @Binding var currentScreen: CurrentScreen



    
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
            
            List(completedTasks) { item in
                VStack{
                    HStack{
                        Text(item.title)
                        
                        Spacer()
                        Button("⭐️"){
                            if expandedTaskID == item.id {
                                expandedTaskID = nil
                            } else {
                                expandedTaskID = item.id
                            }
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
                            
                            Button("🗑️"){
                                deleteTaskToConfirm = item
                            }
                            .buttonStyle(.plain)
                            .alert(item: $deleteTaskToConfirm){task in
                                Alert(
                                    title: Text("Are you sure you want to delete task?"),
                                    message: Text("Once confimred deleted for ever"),
                                    primaryButton: .destructive(Text("Delete")){
                                        deleteTask(task: task)   },
                                    secondaryButton: .cancel())}
                                
                                //Spacer()
                                
                            }
                            .padding()
                            
                        }
                    }
                        .contentShape(Rectangle())
                    
                    
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
            }
        }
    
    func backToMenu(){
        currentScreen = .startMenu
    }
    
    func deleteTask(task: Task){
        completedTasks.removeAll{ $0.id == task.id}
    }
    
    func updateTask(task: Task, title: String){
        if let index = completedTasks.firstIndex(of: task) {
            completedTasks[index].title = title
            
            
        }
    }
}
