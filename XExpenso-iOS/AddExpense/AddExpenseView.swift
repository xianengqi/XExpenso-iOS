//
//  AddExpenseView.swift
//  XExpenso-iOS
//
//  Created by 夏能啟 on 7/23/21.
//

import SwiftUI

struct AddExpenseView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    //CoreData
    @Environment(\.managedObjectContext) var managedObjectContext
    @State private var confirmDelete = false
    @State var showAttachSheet = false
    
    @StateObject var viewModel: AddExpenseViewModel
    
    let typeOptions = [
        DropdownOption(key: TRANS_TYPE_INCOME, val: "收入"),
        DropdownOption(key: TRANS_TYPE_EXPENSE, val: "支出")
    ]
    
    let tagOptions = [
        DropdownOption(key: TRANS_TAG_TRANSPORT, val: "运输"),
        DropdownOption(key: TRANS_TAG_FOOD, val: "食物"),
        DropdownOption(key: TRANS_TAG_HOUSING, val: "住房"),
        DropdownOption(key: TRANS_TAG_INSURANCE, val: "保险"),
        DropdownOption(key: TRANS_TAG_MEDICAL, val: "医疗"),
        DropdownOption(key: TRANS_TAG_SAVINGS, val: "储蓄"),
        DropdownOption(key: TRANS_TAG_PERSONAL, val: "个人"),
        DropdownOption(key: TRANS_TAG_ENTERTAINMENT, val: "娱乐"),
        DropdownOption(key: TRANS_TAG_OTHERS, val: "其它"),
        DropdownOption(key: TRANS_TAG_UTILITIES, val: "水电"),
    ]
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.primary_color.edgesIgnoringSafeArea(.all)
                
                VStack {
                    
                    Group {
                        if viewModel.expenseObj == nil {
                            ToolbarModelView(title: "添加") { self.presentationMode.wrappedValue.dismiss() }
                        } else {
                            ToolbarModelView(title: "编辑", button1Icon: IMAGE_DELETE_ICON) {
                                self.presentationMode.wrappedValue.dismiss()
                            }
                        button1Method: { self.confirmDelete = true }
                        }
                    }.alert(isPresented: $confirmDelete,
                            content: {
                                Alert(title: Text(APP_NAME), message: Text("确定要删除吗？"),
                                      primaryButton: .destructive(Text("删除")) {
                                    viewModel.deleteTransaction(managedObjectContext: self.managedObjectContext)
                                }, secondaryButton: Alert.Button.cancel(Text("取消"), action: { confirmDelete = false })
                            )
                        })
                    
                    ScrollView(showsIndicators: false ) {
                        
                        VStack(spacing: 12) {
                            
                            TextField("标题", text: $viewModel.title)
                                .modifier(InterFont(.regular, size: 16))
                                .accentColor(Color.text_primary_color)
                                .frame(height: 50).padding(.leading, 16)
                                .background(Color.secondary_color)
                                .cornerRadius(4)
                            
                            TextField("金额", text: $viewModel.amount)
                                .modifier(InterFont(.regular, size: 16))
                                .accentColor(Color.text_primary_color)
                                .frame(height: 50).padding(.leading, 16)
                                .background(Color.secondary_color)
                                .cornerRadius(4)
                            
                            DropdownButton(shouldshowDropdown: $viewModel.showTypeDrop, displayText: $viewModel.typeTitle, options: typeOptions, mainColor: Color.text_primary_color, backgroundColor: Color.secondary_color, cornerRadius: 4, buttonHeight: 50) { key in
                                let selectedObj = typeOptions.filter({ $0.key == key }).first
                                if let object = selectedObj {
                                    viewModel.typeTitle = object.val
                                    viewModel.selectedType = key
                                }
                                viewModel.showTypeDrop = false
                            }
                            
                            DropdownButton(shouldshowDropdown: $viewModel.showTagDrop, displayText: $viewModel.tagTitle, options: tagOptions, mainColor: Color.text_primary_color, backgroundColor: Color.secondary_color, cornerRadius: 4, buttonHeight: 50) { key in
                                let selectedObj = tagOptions.filter({ $0.key == key }).first
                                if let object = selectedObj {
                                    viewModel.tagTitle = object.val
                                    viewModel.selectedTag = key
                                }
                                viewModel.showTagDrop = false
                            }
                            
                            HStack {
                                DatePicker("PickerView", selection: $viewModel.occuredOn,
                                           displayedComponents: [.date, .hourAndMinute]
                                ).labelsHidden().padding(.leading, 16)
                                Spacer()
                            }
                            .frame(height: 50).frame(maxWidth: .infinity)
                            .accentColor(Color.text_primary_color)
                            .background(Color.secondary_color).cornerRadius(4)
                            
                            TextField("笔记", text: $viewModel.note)
                                .modifier(InterFont(.regular, size: 16))
                                .accentColor(Color.text_primary_color)
                                .frame(height: 50).padding(.leading, 16)
                                .background(Color.secondary_color)
                                .cornerRadius(4)
                            
                            Button(action: { viewModel.attachImage() }, label: {
                                HStack {
                                    Image(systemName: "paperclip")
                                        .font(.system(size: 18.0, weight: .bold))
                                        .foregroundColor(Color.text_secondary_color)
                                        .padding(.leading, 16)
                                    TextView(text: "附加图片", type: .button).foregroundColor(Color.text_secondary_color)
                                    Spacer()
                                }
                            })
                                .frame(height: 50).frame(maxWidth: .infinity)
                                .background(Color.secondary_color)
                                .cornerRadius(4)
                                .actionSheet(isPresented: $showAttachSheet) {
                                    ActionSheet(title: Text("要删除图片吗?"), buttons: [
                                        .default(Text("删除")) { viewModel.removeImage() },
                                        .cancel()
                                    ])
                                }
                            
                            if let image = viewModel.imageAttached {
                                Button(action: { showAttachSheet = true }, label: {
                                    Image(uiImage: image)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(height: 250).frame(maxWidth: .infinity)
                                        .background(Color.secondary_color)
                                        .cornerRadius(4)
                                })
                            }
                            
                            Spacer().frame(height: 150)
                            Spacer()
                        }
                        .frame(maxWidth: .infinity).padding(.horizontal, 8)
                        .alert(isPresented: $viewModel.showAlert,
                               content: { Alert(title: Text(APP_NAME), message: Text(viewModel.alertMsg), dismissButton: .default(Text("收到"))) })
                        
                    }
                    
                }.edgesIgnoringSafeArea(.top)
                
                VStack {
                    Spacer()
                    VStack {
                        Button(action: { viewModel.saveTransaction(managedObjectContext: managedObjectContext) }, label: {
                            HStack {
                                Spacer()
                                TextView(text: viewModel.getButtText(), type: .button).foregroundColor(.white)
                                Spacer()
                            }
                        })
                            .padding(.vertical, 12).background(Color.main_color).cornerRadius(8)
                    }.padding(.bottom, 16).padding(.horizontal, 8)
                }
            }
            .navigationBarHidden(true)
        }
        .dismissKeyboardOnTap()
        .navigationViewStyle(StackNavigationViewStyle())
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .onReceive(viewModel.$closePresenter) { close in
            if close { self.presentationMode.wrappedValue.dismiss() }
        }
    }
}

//struct AddExpenseView_Previews: PreviewProvider {
//    static var previews: some View {
//        AddExpenseView()
//    }
//}
