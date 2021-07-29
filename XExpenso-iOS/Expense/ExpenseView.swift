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
    @FetchRequest(fetchRequest: XExpenseCD.getAllExpenseData(sortBy: ExpenseCDSort.occuredOn, ascending: false)) var expense: FetchedResults<XExpenseCD>
    
    
    @State private var filter: ExpenseCDFilterTime = .all
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
                    ExpenseMainView(filter: filter)
                    Spacer()
                }.edgesIgnoringSafeArea(.all)
                
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        NavigationLink(destination: NavigationLazyView(AddExpenseView(viewModel: AddExpenseViewModel())),
                                       label: { Image("plus_icon").resizable().frame(width: 32.0, height: 32.0) })
                            .padding().background(Color.main_color).cornerRadius(35)
                    }
                }.padding()
            }
            .navigationBarHidden(true)
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
}

struct ExpenseMainView: View {
    var filter: ExpenseCDFilterTime
    var fetchRequest: FetchRequest<XExpenseCD>
    var expense: FetchedResults<XExpenseCD> { fetchRequest.wrappedValue }
    @AppStorage(UD_EXPENSE_CURRENCY) var CURRENCY: String = ""

    init(filter: ExpenseCDFilterTime) {
        let sortDescriptor = NSSortDescriptor(key: "occuredOn", ascending: false)
        self.filter = filter
        if filter == .all {
            fetchRequest = FetchRequest<XExpenseCD>(entity: XExpenseCD.entity(), sortDescriptors: [sortDescriptor])
        } else {
            var startDate: NSDate!
            let endDate: NSDate = NSDate()
            if filter == .week { startDate = Date().getLast7Day()! as NSDate }
            else if filter == .month { startDate = Date().getLast30Day()! as NSDate }
            else { startDate = Date().getLast6Month()! as NSDate }
            let predicate = NSPredicate(format: "occuredOn >= %@ AND occuredOn <= %@", startDate, endDate)
            fetchRequest = FetchRequest<XExpenseCD>(entity: XExpenseCD.entity(), sortDescriptors: [sortDescriptor], predicate: predicate)
        }
    }
    
    private func getTotalBalance() -> String {
        var value = Double(0)
        for i in expense {
            if i.type == TRANS_TYPE_INCOME { value += i.amount }
            else if i.type == TRANS_TYPE_EXPENSE { value -= i.amount }
        }
        return "\(String(format: "%.2f", value))"
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            if fetchRequest.wrappedValue.isEmpty {
                //
            } else {
                VStack(spacing: 16) {
                    TextView(text: "总余额", type: .overline).foregroundColor(Color.init(hex: "828282")).padding(.top, 30)
                    TextView(text: "\(CURRENCY)\(getTotalBalance())", type: .h5)
                        .foregroundColor(Color.text_primary_color).padding(.bottom, 30)
                }.frame(maxWidth: .infinity).background(Color.secondary_color).cornerRadius(4)
            }
        }
    }
}

struct ExpenseView_Previews: PreviewProvider {
    static var previews: some View {
        ExpenseView()
    }
}
