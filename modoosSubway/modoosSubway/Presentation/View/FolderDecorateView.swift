//
//  FolderDecorateView.swift
//  modoosSubway
//
//  Created by 임재현 on 11/11/24.
//

import SwiftUI

struct FolderDecorateView: View {
    @State var name: String = ""
    @State private var textFieldString: String = ""
    var body: some View {
        VStack {
            
            HStack {
                Text("폴더 꾸미기")
                    .font(.pretendard(size: 20, family: .bold))
                    .foregroundStyle(.black)
                    .padding(.leading, 20)
               
                Spacer()
            }
            
            HStack {
                
                TextField("폴더명을 입력해주세요", text: self.$textFieldString)
                    .frame(height: 45)
                    .textFieldStyle(PlainTextFieldStyle())
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
                    .toolbar {
                        ToolbarItem(placement: .keyboard) {
                            HStack {
                                Spacer()
                            
                                Button(action: {
                                    //      hideKeyboard()
                                
                                    if textFieldString.isEmpty {
                                        //     isSearchViewHidden = true
                                        //     vm.stations = []
                                    }
                                }) {
                                    Image(systemName: "keyboard.chevron.compact.down")
                                        .foregroundColor(.blue)
                                }
                            }
                        }
                    }
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                }
                .background(.clear)
                .padding(.trailing, 16)
                .padding(.leading, 20)
                .padding(.vertical, 4)
            
            
            HStack {
                VStack {
                    Image(systemName: "camera")
                        .resizable()
                        .frame(width:36,height:36)
                     
                    Text("사진 촬영하기")
                }
                .frame(width: 170,height: 120)
                .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(.EDEDED, lineWidth: 1)
                )
                
                VStack {
                    Image(systemName: "camera")
                        .resizable()
                        .frame(width:36,height:36)
                     
                    Text("사진 촬영하기")
                }
                .frame(width: 170,height: 120)
                .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(.EDEDED, lineWidth: 1)
                )
            }
            .padding(13)
            Button {
                
            } label: {
                Text("완료")
                    .frame(maxWidth: .infinity)
                    .frame(height: 36)
                    .padding(.horizontal, 20)
            }
            .buttonStyle(.borderedProminent)
            .padding(.horizontal, 20)
      

           
            }
        }
    }

#Preview {
    FolderDecorateView()
}
