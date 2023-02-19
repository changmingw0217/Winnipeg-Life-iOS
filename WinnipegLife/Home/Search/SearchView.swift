//
//  SearchView.swift
//  WinnipegLife
//
//  Created by changming wang on 8/15/21.
//

import SwiftUI
import UIKit
import SwiftUIX
import ActivityIndicatorView
import Combine


struct SearchView: View {
    
    
    
    @Environment(\.presentationMode) var presentation
    
    @StateObject var search:SearchModel = SearchModel()
        
    
    var body: some View {
        NavigationView{
            ZStack(){
                VStack{
                    
                    HStack{
                        
                        Button(action: { presentation.wrappedValue.dismiss() }) {
                            Image(systemName: "chevron.left")
                                .imageScale(.large)
                                .foregroundColor(.orange)
                        }.padding(.leading, 10)
                        
                        SearcBarView(text: $search.text)
                            .frame(height: 37)
                        
                    }
                    
                    ScrollView(){
                        ForEach(search.threadResult.indices, id: \.self){ index in
                            NavigationLink(destination: SearchDetailView(thread: search.threadResult[index])) {
                                NavigationLink(destination: EmptyView()) {
                                    EmptyView()
                                }
                                SearchRowView(thread: search.threadResult[index])
                            }

                        }
                    }
                }
                
                if search.isLoading{
                    ZStack{
                        Color.black.opacity(0.2).ignoresSafeArea()
                        RoundedRectangle(cornerRadius: 5.0)
                            .frame(width: 200.0, height: 200.0)
                            .foregroundColor(Color.black.opacity(0.6))
                        VStack {
                            Text("Searching").foregroundColor(.white)
                            ActivityIndicatorView(isVisible: $search.isLoading, type: .growingArc())
                                .frame(width: 50.0, height: 50.0)
                                .foregroundColor(.red)
                        }
                    }
                }
                
            }
            .environmentObject(search)
            .navigationBarTitle("search")
            .navigationBarHidden(true)
        }
        .navigationBarTitle("search")
        .navigationBarHidden(true)
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}

extension SearchView{
    
    struct SearcBarView: View {
        
        @EnvironmentObject var search: SearchModel
        
        @Binding var text:String
        
        @State var firstResponder: Bool = true
        
        
        var body: some View{
            HStack{
                
                SearchTextField(text:$text){
                    UIApplication.shared.endEditing()
                    search.search()
                }
                .padding(7)
                .padding(.leading, 25)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .padding(.horizontal, 10)
                .overlay(
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 18)
                        
                    }
                )
                
                Button(action: {
                    UIApplication.shared.endEditing()
//                    print(text)
                    search.search()
                }) {
                    Text("Search")
                        .foregroundColor(.orange)
                }
                .padding(.trailing, 10)
                
            }
        }
    }
    
    struct SearchTextField: UIViewRepresentable {
        
        @AppStorage("appLanguage") var appLanguage: String = Locale.current.languageCode ?? "en"
        
        typealias UIViewType = UITextField
        
        @Binding var text:String
        
        var onDone: (() -> Void)?
        
        func makeUIView(context: UIViewRepresentableContext<SearchTextField>) -> UITextField {
            let textField = UITextField()
            
            textField.delegate = context.coordinator
            
            textField.placeholder = appLanguage == "zh" ? "搜索..." : "Search..."
            
            textField.autocapitalizationType = .none
            textField.keyboardType = .default
            textField.clearButtonMode = .whileEditing
            textField.enablesReturnKeyAutomatically = true
            textField.returnKeyType = .search
            
            textField.clearsOnBeginEditing = true
            
            textField.becomeFirstResponder()
            
            
            return textField
        }
        
        func updateUIView(_ view: UITextField, context: Context) {
//            view.text = text
        }
        
        func makeCoordinator() -> Coordinator {
            return Coordinator(text: $text, onDone: {
                self.onDone?()
            })
        }
        
        class Coordinator: NSObject, UITextFieldDelegate {
            
            @Binding var text:String
            var onDone: () -> Void
            
            
            init(text: Binding<String>, onDone: @escaping () -> Void) {
                self._text = text
                self.onDone = onDone
            }
            
            func textFieldDidChangeSelection(_ textField: UITextField) {
                DispatchQueue.main.async {
                    self.text = textField.text ?? "" // 2. Write to the binded
                }
            }
            
            
            func textFieldShouldReturn(_ textField: UITextField) -> Bool {

                onDone()
                return true
            }
            
        }
        
        
    }
    
}
