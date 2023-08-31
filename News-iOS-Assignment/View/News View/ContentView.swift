//
//  ContentView.swift
//  News-iOS-Assignment
//
//  Created by Jay Firke on 31/08/23.
//

import SwiftUI
// News View
struct ContentView: View {
    @ObservedObject var vm = NewsViewModel()
    @State private var navigateToAuth = false
    var body: some View {
        
        NavigationView {
            ZStack {
                AppColor.outerSpaceColor.ignoresSafeArea()
                VStack {
                    HStack {
                        Spacer()
                        Text("HeadLines")
                            .font(AppFont.mediumBold)
                            .foregroundColor(AppColor.whiteColor)
                        Spacer()
                        Button(action: {
                            saveUserSignedInStatus(false)
                            navigateToAuth.toggle()
                        }, label: {
                            Image(systemName: "rectangle.portrait.and.arrow.right.fill")
                                .font(AppFont.defaultFont)
                                .foregroundColor(AppColor.whiteColor)
                        })

                    }.padding()
                        .frame(maxWidth: .infinity)
                        .background(AppColor.blackColor)
                        .padding(.bottom, 12)
                    
                    ScrollView {
                        ForEach(Array(self.vm.news.enumerated()), id: \.element.url) { index, item in
                            NavigationLink(destination: NewsDetailView(news: self.vm.news, selectedIndex: index)) {
                                if let urlToImage = item.urlToImage,
                                   let title = item.title,
                                   let date = item.publishedAt,
                                   let source = item.source.name {
                                    
                                    NewsCard(url: urlToImage, title: title, date: date, source: source)
                                }
                            }
                        }


                    }.scrollIndicators(.hidden)
                    
                    
                }
                .fullScreenCover(isPresented: $navigateToAuth) {
                    // Present the OTPView using fullScreenCover
                    PhoneAuthView()
                }
                .onAppear(perform: {
                    self.vm.callAPI()
                })
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
