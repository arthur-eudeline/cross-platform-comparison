//
//  ContentCard.swift
//  iOS.CrossPlatform.Test
//
//  Created by Arthur Eudeline on 01/05/2021.
//

import Foundation
import SwiftUI

class ContentCardData: Identifiable {
    var uuid = UUID();
    var title: String;
    var date: String;
    var image: String;
    var description: String;
    
    init(title: String, date: String, image: String, description: String) {
        self.title = title;
        self.date = date;
        self.image = image;
        self.description = description;
    }
}

class ContentCardList: ObservableObject, RandomAccessCollection {
    typealias Element = ContentCardData;
    
    @Published var content = [ContentCardData]();
    
    var startIndex: Int { content.startIndex };
    var endIndex: Int { content.endIndex };
    
    var urlBase = "https://jsonplaceholder.typicode.com/posts";
    
    init() {
        loadMore()
    }
    
    subscript(position: Index) -> ContentCardData {
        return content[ position ];
    }
    
    func loadMore() {
        let url = URL(string: urlBase)!
        let task = URLSession.shared.dataTask(
            with: url,
            completionHandler: parseFromResponse(data:response:error:)
        );
        task.resume();
    }

    func parseFromResponse(data: Data?, response: URLResponse?, error: Error?) {
        guard error == nil else {
            print("Error \(error!)")
            return
        }
        guard let data = data else {
            print("No data found")
            return
        }
        
        let contentItem = parseFromData(data: data)
        DispatchQueue.main.async {
            self.content.append(contentsOf: contentItem)
        }
    }
    
    func parseFromData(data:Data) -> [ContentCardData] {
        let jsonObject = try! JSONSerialization.jsonObject(with: data);
        let map = jsonObject as! [[String: Any]];
        
        var items = [ContentCardData]();
        for itemMap in map {
            guard let title = itemMap["title"] as? String else {
                continue;
            };
            guard let description = itemMap["body"] as? String else {
                continue;
            };
            items.append(ContentCardData(title: title, date: "date", image: "image", description: description));
        }
        return items;
    }
}

struct PhoneContentCard: View {
    var data: ContentCardData;
    
    var body: some View {
        return VStack() {
            Image("background")
                .resizable()
                .aspectRatio(contentMode: /*@START_MENU_TOKEN@*/.fill/*@END_MENU_TOKEN@*/)
                .scaledToFill()
                .frame(width: .infinity)
                .clipped()
        
            VStack() {
                Text("PUBLISHED AT \(data.date)")
                    .font(.subheadline)
                    .foregroundColor(Color("DateColor"))
                    .frame(
                        maxWidth: .infinity,
                        alignment: .leading
                    )
        
                // TITLE
                Text(data.title)
                    .font(.title2)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.leading)
                    .lineLimit(1)
                    .frame(
                        maxWidth: .infinity,
                        alignment: .leading
                    )
        
                Spacer(minLength: 15)
        
                Text(data.description)
                    .lineLimit(4)
            }
            .padding()
        
        }.background(/*@START_MENU_TOKEN@*//*@PLACEHOLDER=View@*/Color("CardBody")/*@END_MENU_TOKEN@*/).cornerRadius(10)
    }
}

struct DesktopContentCard: View {
    var data: ContentCardData;
    var screenWidth: CGFloat;
    
    var body: some View {
        return HStack() {
            Image("background")
                .resizable()
                .aspectRatio(contentMode: /*@START_MENU_TOKEN@*/.fill/*@END_MENU_TOKEN@*/)
                .scaledToFill()
                .frame(width: screenWidth > 750 ? 250 : screenWidth / 3)
                .clipped()
        
            VStack() {
                // TITLE
                Text(data.title)
                    .font(.title2)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.leading)
                    .lineLimit(1)
                    .frame(
                        maxWidth: .infinity,
                        alignment: .leading
                    )
                
                Text("PUBLISHED AT \(data.date)")
                    .font(.subheadline)
                    .foregroundColor(Color("DateColor"))
                    .frame(
                        maxWidth: .infinity,
                        alignment: .leading
                    )
        
                Spacer(minLength: 5)
        
                Text(data.description)
                    .lineLimit(4)
            }
            .padding()
        
        }.background(/*@START_MENU_TOKEN@*//*@PLACEHOLDER=View@*/Color("CardBody")/*@END_MENU_TOKEN@*/)
        .cornerRadius(10)
    }
}


@ViewBuilder
func ContentCardBuilder (screenWidth: CGFloat, data: ContentCardData) -> some View {
    if (screenWidth < 600) {
        PhoneContentCard(data: data);
    } else {
        DesktopContentCard(data: data, screenWidth: screenWidth);
    }
}
