//
//  ExpenseDetailView.swift
//  XExpenso-iOS
//
//  Created by 夏能啟 on 7/31/21.
//

import SwiftUI

struct ExpenseDetailView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    // CoreData
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @ObservedObject private var viewModel: ExpenseDetailViewModel
    @AppStorage(UD_EXPENSE_CURRENCY) var CURRENCY: String = ""
    
    @State private var confirmDelete = false
    
    init(expenseObj: XExpenseCD) {
        viewModel = ExpenseDetailViewModel(expenseObj: expenseObj)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.primary_color.edgesIgnoringSafeArea(.all)
                
                VStack {
                    
                    ToolbarModelView(title: "详情", button1Icon: IMAGE_DELETE_ICON, button2Icon: IMAGE_SHARE_ICON) {
                        self.presentationMode.wrappedValue.dismiss()}
                    button1Method: { self.confirmDelete = true }
                    button2Method: { viewModel.shareNote() }
                        
                    ScrollView(showsIndicators: false) {
                        
                        VStack(spacing: 24) {
                            ExpenseDetailListView(title: "名称", description: viewModel.expenseObj.title ?? "")
                            ExpenseDetailListView(title: "金额", description: "\(CURRENCY)\(viewModel.expenseObj.amount)")
                            ExpenseDetailListView(title: "收|支类型", description: viewModel.expenseObj.type == TRANS_TYPE_INCOME ? "收入" : "支出")
                            ExpenseDetailListView(title: "标签", description: getTransTagTitle(transTag: viewModel.expenseObj.tag ?? ""))
                            ExpenseDetailListView(title: "创建时间", description: getDateFormatter(date: viewModel.expenseObj.occuredOn, format: "EEEE, dd MMM hh:mm a"))
                            if let note = viewModel.expenseObj.note, note != "" {
                                ExpenseDetailListView(title: "笔记", description: note)
                            }
                            if let data = viewModel.expenseObj.imageAttached {
                                VStack(spacing: 8) {
                                    HStack { TextView(text: "附件", type: .caption).foregroundColor(Color.init(hex: "828282")); Spacer()}
                                    Image(uiImage: UIImage(data: data)!)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(height: 250).frame(maxWidth: .infinity)
                                        .background(Color.secondary_color)
                                        .cornerRadius(4)
                                }
                            }
                        }.padding(16)
                        
                        Spacer().frame(height: 24)
                        Spacer()
                    }
                    .alert(isPresented: $confirmDelete,
                           content: {
                        Alert(title: Text(APP_NAME), message: Text("你确定要删除吗？"), primaryButton: .destructive(Text("删除")) {
                            viewModel.deleteNote(managedObjectContext: managedObjectContext)
                        }, secondaryButton: Alert.Button.cancel(Text("取消"), action: { confirmDelete = false })
                        )
                    })
                }.edgesIgnoringSafeArea(.all)
                
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        NavigationLink(destination: AddExpenseView(viewModel: AddExpenseViewModel(expenseObj: viewModel.expenseObj)), label: {
                            Image("pencil_icon").resizable().frame(width: 28.0,height: 28.0)
                            Text("编辑").modifier(InterFont(.semiBold, size: 18)).foregroundColor(.white)
                        })
                            .padding(EdgeInsets(top: 10, leading: 15, bottom: 10, trailing: 20))
                            .background(Color.main_color).cornerRadius(25)
                    }.padding(24)
                }
            }
            .navigationBarHidden(true)
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
}


struct ExpenseDetailListView: View {
    var title: String
    var description: String
    
    var body: some View {
        VStack(spacing: 8) {
            HStack { TextView(text: title, type: .caption).foregroundColor(Color.init(hex: "828282")); Spacer() }
            HStack { TextView(text: description, type: .body_1).foregroundColor(Color.text_primary_color); Spacer() }
        }
    }
}

//struct ExpenseDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        ExpenseDetailView()
//    }
//}
