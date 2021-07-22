//
//  ContentView.swift
//  XExpenso-iOS
//
//  Created by 夏能啟 on 7/17/21.
//

import SwiftUI

struct ExpenseView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    // CoreData
    @Environment(\.managedObjectContext) var managedObjectContext
//    @FetchRequest(fetchRequest: XExpenseCD.getAllExpenseDat, animation: <#T##Animation?#>)
    
    @State private var showOptionsSheet = false
    @State private var displayAbout = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.primary_color.edgesIgnoringSafeArea(.all)
                
                VStack {
                    NavigationLink(destination: NavigationLazyView(AboutView()), isActive: $displayAbout, label: {})
                    ToolbarModelView(title: "统计数据", hasBackButt: false, button1Icon: IMAGE_OPTION_ICON) {self.presentationMode.wrappedValue.dismiss()}
                button1Method: { self.showOptionsSheet = true}
                .actionSheet(isPresented: $showOptionsSheet) {
                    ActionSheet(title: Text("选择一个选项"), buttons: [
                        .default(Text("关于")) { self.displayAbout = true },
                        .cancel()
                    ])
                }
                    Spacer()
                }.edgesIgnoringSafeArea(.all)
            }.navigationBarHidden(true)
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
}

//struct ExpenseMainView: View {
//    var body: some View {
//        //
//    }
//}

struct ExpenseView_Previews: PreviewProvider {
    static var previews: some View {
        ExpenseView()
    }
}
