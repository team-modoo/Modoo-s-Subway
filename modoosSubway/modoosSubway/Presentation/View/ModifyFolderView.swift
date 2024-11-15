//
//  ModifyFolderView.swift
//  modoosSubway
//
//  Created by 임재현 on 11/12/24.
//

import SwiftUI

struct ModifyFolderView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    dismiss()
                }) {
                    Image(.back)
                    Text("폴더 수정하기")
                        .padding(.leading, -10)
                        .tint(._333333)
                }
                
                Spacer()
                
                Button(action: {
                    dismiss()
                }) {
                   
                    Text("완료")
                        .padding(.leading, -10)
                        .tint(._333333)
                }
                
                
            }
            .background(.white)
            .padding(.horizontal, 20)
            .padding(.top, 22)
            
            FolderCardView()
                .padding(.top, 20)
            Spacer()
            
            
        }
        .background(.white)
        .toolbar(.hidden, for: .navigationBar)

    }
}

struct ModifyView: View {
    @State private var folderTextFieldString: String = ""
    @State private var descriptionTextFieldString: String = ""
    
    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                Text("폴더명")
                    .font(.pretendard(size: 14, family: .medium))
                    .foregroundStyle(.black)
                    .padding(.leading,24)
                TextFieldView(text: $folderTextFieldString, placeholder: "폴더명을 입력해 주세요")
            }
            
            VStack(alignment: .leading) {
                Text("설명")
                    .font(.pretendard(size: 14, family: .medium))
                    .foregroundStyle(.black)
                    .padding(.leading,24)
                TextFieldView(text: $descriptionTextFieldString, placeholder: "설명을 입력해 주세요")
                
            }
            
            VStack {
                Text("사진")
                    .font(.pretendard(size: 14, family: .medium))
                    .foregroundStyle(.black)
                    .padding(.leading,24)
                
                
            }
  
            
            
        }
        .toolbar {
            ToolbarItem(placement: .keyboard) {
                HStack {
                    Spacer()
                
                    Button(action: {
                              hideKeyboard()
                    }) {
                        Image(systemName: "keyboard.chevron.compact.down")
                            .foregroundColor(.blue)
                    }
                }
            }
        }
    }
    
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct TextFieldView: View {
    @Binding var text: String
    var placeholder: String
    
    init(text: Binding<String>, placeholder: String) {
        self._text = text
        self.placeholder = placeholder
    }
    
    var body: some View {
        HStack {
            TextField(placeholder, text: self.$text)
                .frame(height: 56)
                .textFieldStyle(.plain)
                .padding([.horizontal], 4)
                .cornerRadius(16)
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray))
                .padding([.horizontal], 4)
                .submitLabel(.search)
                .onSubmit {
                    //   handleSearch()
                }
                .onAppear {
                    UITextField.appearance().clearButtonMode = .whileEditing
                }
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
            }
            .background(.clear)
            .padding(.trailing, 16)
            .padding(.leading, 20)
            .padding(.vertical, 4)

    }
}

//
//
//
//
//struct FolderDecorateView: View {
//    @State var name: String = ""
//    @State private var textFieldString: String = ""
//    var body: some View {
//        VStack {
//            
//            HStack {
//                Text("폴더 꾸미기")
//                    .font(.pretendard(size: 20, family: .bold))
//                    .foregroundStyle(.black)
//                    .padding(.leading, 20)
//               
//                Spacer()
//            }
//            
//            HStack {
//                
//                TextField("폴더명을 입력해주세요", text: self.$textFieldString)
//                    .frame(height: 45)
//                    .textFieldStyle(PlainTextFieldStyle())
//                    .padding([.horizontal], 4)
//                    .cornerRadius(16)
//                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray))
//                    .padding([.horizontal], 4)
//                    .submitLabel(.search)
//                    .onSubmit {
//                        //   handleSearch()
//                    }
//                    .onAppear {
//                        UITextField.appearance().clearButtonMode = .whileEditing
//                    }
//                    .toolbar {
//                        ToolbarItem(placement: .keyboard) {
//                            HStack {
//                                Spacer()
//                            
//                                Button(action: {
//                                    //      hideKeyboard()
//                                
//                                    if textFieldString.isEmpty {
//                                        //     isSearchViewHidden = true
//                                        //     vm.stations = []
//                                    }
//                                }) {
//                                    Image(systemName: "keyboard.chevron.compact.down")
//                                        .foregroundColor(.blue)
//                                }
//                            }
//                        }
//                    }
//                    .autocorrectionDisabled()
//                    .textInputAutocapitalization(.never)
//                }
//                .background(.clear)
//                .padding(.trailing, 16)
//                .padding(.leading, 20)
//                .padding(.vertical, 4)
//            
//            
//            HStack {
//                VStack {
//                    Image(systemName: "camera")
//                        .resizable()
//                        .frame(width:36,height:36)
//                     
//                    Text("사진 촬영하기")
//                }
//                .frame(width: 170,height: 120)
//                .overlay(
//                RoundedRectangle(cornerRadius: 10)
//                    .stroke(.EDEDED, lineWidth: 1)
//                )
//                
//                VStack {
//                    Image(systemName: "camera")
//                        .resizable()
//                        .frame(width:36,height:36)
//                     
//                    Text("사진 촬영하기")
//                }
//                .frame(width: 170,height: 120)
//                .overlay(
//                RoundedRectangle(cornerRadius: 10)
//                    .stroke(.EDEDED, lineWidth: 1)
//                )
//            }
//            .padding(13)
//            Button {
//                
//            } label: {
//                Text("완료")
//                    .frame(maxWidth: .infinity)
//                    .frame(height: 36)
//                    .padding(.horizontal, 20)
//            }
//            .buttonStyle(.borderedProminent)
//            .padding(.horizontal, 20)
//      
//
//           
//            }
//        }
//    }
