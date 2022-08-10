//
//  ContentView.swift
//  Shared
//
//  Created by 肖云开 on 2022/8/3.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>
    
    @State var topDaily:String = ""
    
    @State private var topDate: String = "今日 " + "2022年8月3日" + " 星期" + "三"
    @State private var topExpanded: Bool = true

    var body: some View {
        NavigationView {
            VStack {
                Form{
                    List{
                        HStack {
                            Text("2022年8月3日")
                            Spacer()
                            Text("星期三")
                        }
                    }
                    
                    Section(header:Text("置顶")){
                        List{
                            HStack {
                                Text("距离" + "上班")
                                Spacer()
                                Text("30天")
                            }
                            HStack {
                                Text("距离" + "上班")
                                Spacer()
                                Text("30天")
                            }
                        }
                    }
                
                    Section(header:Text("标签")){
                        List {
                            // 内置分组
                            DisclosureGroup("内置标签") {
                                NavigationLink {
                                    List {
                                        HStack {
                                            Text("距离" + "上班")
                                            Spacer()
                                            Text("30天")
                                        }
                                        HStack {
                                            Text("距离" + "上班")
                                            Spacer()
                                            Text("30天")
                                        }
                                        #if os(iOS)
                                            .navigationBarTitle("工作")
                                        #endif
                                    }
                                } label: {
                                    Label("工作", systemImage: "desktopcomputer")
                                }
                                                
                                NavigationLink {
                                    Text("生活")
                                    #if os(iOS)
                                        .navigationBarTitle("生活")
                                    #endif
                                } label: {
                                    Label("生活", systemImage: "house")
                                }

                                NavigationLink {
                                    Text("节日")
                                    #if os(iOS)
                                        .navigationBarTitle("节日")
                                    #endif
                                } label: {
                                    Label("节日", systemImage: "umbrella")
                                }
                            }
                            
                            // 自定义分组
                            DisclosureGroup("自定义标签") {
                                ForEach(items) { item in
                                    NavigationLink {
                                        Text("Item at \(item.timestamp!, formatter: itemFormatter)")
                                    } label: {
                                        Text(item.timestamp!, formatter: itemFormatter)
                                    }
                                }.onDelete(perform: deleteItems)
                            }
                        }
                    }
                }
            }
            .toolbar {
#if os(iOS)
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
#endif
                ToolbarItem {
                    Button(action: addItem) {
                        Label("添加自定义标签", systemImage: "plus")
                    }
                }
            }
            .navigationTitle("Sky倒数日")
            
            // iPadOS与macOS的首页
            VStack {
                Label("日暮里" + " 2022年8月3日" + " 星期三", systemImage: "sunset").font(.title).foregroundColor(.black)
                #if os(iOS)
                    .navigationBarTitle("欢迎")
                #endif
            }
        }
    }

    private func addItem() {
        withAnimation {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext).previewInterfaceOrientation(.portrait)
    }
}
