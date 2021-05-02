//
//  ContentView.swift
//  Shared
//
//  Created by Arthur Eudeline on 01/05/2021.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var contentCardList = ContentCardList();
    
    var body4: some View {
        GeometryReader{ geometry in
                ScrollView {
                    LazyVStack(
                        alignment: .leading,
                        spacing: 30,
                        content: {
                        ForEach(1...100, id: \.self) { count in
                            
                        }
                    }).padding()
                }
            }
    }
    
    var body: some View {
        GeometryReader{ geometry in
            List(contentCardList) { (content: ContentCardData) in
                ContentCardBuilder(
                    screenWidth: geometry.size.width,
                    data: content
                )
                
                .onAppear {
                    self.contentCardList.loadMore(currentItem: content)
                }
            }
        }
    }
    
    var body2: some View {
        GeometryReader{ geometry in
                ScrollView {
                    LazyVStack(
                        alignment: .leading,
                        spacing: 30,
                        content: {
                        ForEach(1...100, id: \.self) { count in
                            ContentCardBuilder(
                                screenWidth: geometry.size.width,
                                data: ContentCardData(
                                    title: "Mon titre",
                                    date: "Ma date",
                                    image: "Mon image",
                                    description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
                                )
                            )
                        }
                    }).padding()
                }
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    
    static var previews: some View {
        ContentView()
//            .preferredColorScheme(.dark)
//            .frame(width: 1920.0, height: 1080.0)
            .environment(\.sizeCategory, .extraLarge)
    }
}
