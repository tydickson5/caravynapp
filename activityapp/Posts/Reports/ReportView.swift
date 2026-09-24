//
//  ReportView.swift
//  caravyn
//
//  Created by Ty Dickson on 9/22/26.
//

import SwiftUI

struct ReportView: View {
    
    var userId: String
    var postId: String?
    var commentId: String?
    @State var uploadReason: String = ""
    @State var textBoxReason: String = ""
    
    var type: String
    
    @State var isLoading: Bool = false
    @FocusState private var isTextEditorFocused: Bool
    
    var reportService = ReportService()
    
    let postReasons = [
        "Innapropriate Content",
        "Use of AI",
        "Misinformation",
        "Plagarism",
        "Harrasment",
    ]
    
    let commentReasons = [
        "Innapropriate Content",
        "Use of AI",
        "Misinformation",
        "Plagarism",
        "Harrasment",
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 30) {
            Text("Thank you for taking the time to report")
                .font(.title3)
            VStack(alignment: .leading, spacing: 10){
                ForEach(type == "post" ? postReasons : commentReasons, id: \.self){ reason in
                    Button(action: {
                        textBoxReason = ""
                        uploadReason = reason
                    }){
                        Text(reason)
                            .frame(maxWidth: .infinity)
                            .frame(height: 15)
                            .tint(.black)
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(uploadReason == reason ? .lightBlue : .lightGray)
                            .stroke(Color.dark.opacity(0.5), lineWidth: 2)
                    )
                }
                Button(action: {
                    textBoxReason = ""
                    uploadReason = ""
                }){
                    Text("Other")
                        .frame(maxWidth: .infinity)
                        .frame(height: 15)
                        .tint(.black)
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(uploadReason == "" ? .lightBlue : .lightGray)
                        .stroke(Color.dark.opacity(0.5), lineWidth: 2)
                )
                VStack(alignment: .leading){
                    Text("Other (Type here)")
                        .font(.footnote)
                    TextEditor(text: $textBoxReason)
                        .focused($isTextEditorFocused)
                        .frame(height: 100)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.dark.opacity(0.5), lineWidth: 2)
                        )
                        .onChange(of: textBoxReason){
                            if(!textBoxReason.isEmpty){
                                uploadReason = ""
                            }
                        }
                        .toolbar {
                            ToolbarItemGroup(placement: .keyboard) {
                                Spacer()

                                Button {
                                    isTextEditorFocused = false
                                } label: {
                                    Image(systemName: "checkmark")
                                }
                                
                            }
                        }
                }
                
            }
            .onTapGesture {
                isTextEditorFocused = false
            }
            Button(action: {
                Task{
                    isLoading = true
                    if(!textBoxReason.isEmpty){
                        uploadReason = textBoxReason
                    }
                    var response = false
                    if(type == "post"){
                        response = await reportService.createPostReport(userId: userId, postId: postId!, reason: uploadReason)
                        
                    } else {
                        response = await reportService.createCommentReport(userId: userId, commentId: commentId!, reason: uploadReason)
                    }
                    if(response){
                        uploadReason = ""
                        textBoxReason = ""
                    }
                    
                    isLoading = false
                }
            }){
                if(isLoading){
                    ProgressView()
                        .frame(maxWidth: .infinity)
                        .frame(height: 15)
                        .tint(.white)
                } else {
                    Text("Report")
                        .frame(maxWidth: .infinity)
                        .frame(height: 15)
                        .tint(.white)
                }
                
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(.red)
                    .stroke(Color.red.opacity(0.5), lineWidth: 2)
            )
            .disabled(isLoading)
        }
        .padding()
        .background(Color.background)
    }
}
