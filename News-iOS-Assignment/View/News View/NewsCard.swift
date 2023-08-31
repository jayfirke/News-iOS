//
//  NewsView.swift
//  News-iOS-Assignment
//
//  Created by Jay Firke on 31/08/23.
//

import SwiftUI

struct NewsCard: View {
    let url: String
    let title: String
    let date: String
    let source: String
    
    var formattedDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        
        if let originalDate = dateFormatter.date(from: date) {
            dateFormatter.dateFormat = "yyyy-MM-dd"
            return dateFormatter.string(from: originalDate)
        }
        
        return date
    }
    var body: some View {
        ZStack {
            AsyncImage(url: URL(string: url)!) { image in
                image
                    .resizable()
                    .cornerRadius(20)
                    .frame(maxWidth: .infinity,maxHeight: 250, alignment: .center)
                    .overlay(content: {
                        HStack {
                            VStack(alignment: .leading, spacing: 24){
                                Spacer()
                                Text(title)
                                    .font(AppFont.defaultFont)
                                    .fontWeight(.bold)
                                    .foregroundColor(AppColor.lightGrayColor)
                                    .multilineTextAlignment(.leading)
                                HStack {
                                    Text(source)
                                        .multilineTextAlignment(.leading)
                                    Text(formattedDate)
                                        .multilineTextAlignment(.leading)
                                    
                                }
                                .font(AppFont.footnote)
                                .padding(.bottom, 12)
                                    .fontWeight(.bold)
                                    .foregroundColor(AppColor.grayColor)
                            }
                            Spacer()
                        }.padding(.horizontal, 16)
                    
                    })
                
            } placeholder: {
                ProgressView()
            }
            .padding(.horizontal,16)
            .padding(.bottom, 24)
            
        }
    }
}
