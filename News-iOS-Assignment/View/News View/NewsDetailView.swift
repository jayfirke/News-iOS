//
//  NewsDetailView.swift
//  News-iOS-Assignment
//
//  Created by Jay Firke on 01/09/23.
//

import SwiftUI

struct NewsDetailView: View {
    var news: [Article]
    var selectedIndex: Int
    @Environment(\.presentationMode) var presentationMode
    
    var formattedPublishedDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        
        if let originalDate = dateFormatter.date(from: news[selectedIndex].publishedAt ?? "") {
            dateFormatter.dateFormat = "yyyy-MM-dd"
            return dateFormatter.string(from: originalDate)
        }
        
        return news[selectedIndex].publishedAt ?? ""
    }
    
    var body: some View {
        ZStack {
            AsyncImage(url: URL(string: news[selectedIndex].urlToImage ?? "")!) { image in
                image
                    .resizable()
                    .cornerRadius(20)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    .overlay(content: {
                        VStack(alignment: .leading) {
                            Spacer()
                            Text(news[selectedIndex].title ?? "")
                                .font(AppFont.mediumBold)
                                .multilineTextAlignment(.leading)
                                .padding()
                            
                            HStack {
                                Text(news[selectedIndex].source.name ?? "")
                                    .font(AppFont.defaultBold)
                                    .padding()
                                
                                Spacer()
                                
                                Text(formattedPublishedDate)
                                    .font(AppFont.defaultBold)
                                    .padding()
                            }
                            
                            Text(news[selectedIndex].content ?? "")
                                .font(AppFont.footnote)
                                .multilineTextAlignment(.leading)
                                .padding()
                            
                        }
                        .foregroundColor(AppColor.whiteColor)
                        .navigationBarTitle("", displayMode: .inline)
                        .navigationBarBackButtonHidden(true)
                        .navigationBarItems(leading: backButton)
                    })
                
            } placeholder: {
                ProgressView()
            }
        }
        .ignoresSafeArea()
    }
    
    private var backButton: some View {
        Button(action: {
            presentationMode.wrappedValue.dismiss()
        }, label: {
            Image(systemName: "arrow.left")
                .resizable()
                .frame(width: 25, height: 20)
                .foregroundColor(.white)
                .font(.title)
        })
    }
}
