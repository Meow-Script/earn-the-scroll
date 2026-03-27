//
//  CompletedList.swift
//  StopDoomScroling
//
//  Created by Brian Bernal on 3/25/26.
//

import SwiftUI

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
