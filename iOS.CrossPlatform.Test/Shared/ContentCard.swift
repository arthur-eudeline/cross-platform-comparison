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
    @ObservedObject var image: ContentCardImage;
    var description: String;
    
    init(title: String, date: String, image: String, description: String) {
        self.title = title;
        self.date = date;
        self.image = ContentCardImage(url: image);
        self.description = description;
    }
}

class ContentCardImage: ObservableObject {
    var url: String;
    @Published var loaded = false;
    
    @Published var image: UIImage? = nil;
    
    init(url:String) {
        self.url = url;
    }
    
    func load() {
        print("LOADING \(url)")
        if (loaded) {
            return
        }
        
        let url = URL(string: self.url)!
        let task = URLSession.shared.dataTask(
            with: url,
            completionHandler: setImageFromData(data:response:error:)
        );
        task.resume();
    }
    
    func setImageFromData(data: Data?, response: URLResponse?, error: Error?) {
        guard let content = data else {
            print("ERROR IMAGE NO DATA \(url)")
            return;
        }
        
        DispatchQueue.main.async {
            print("LOADED")
            self.image = UIImage(data: content);
            self.loaded = true;
        }
    }
}

class ContentCardList: ObservableObject, RandomAccessCollection {
    typealias Element = ContentCardData;
    
    @Published var content = [ContentCardData]();
    
    var startIndex: Int { content.startIndex };
    var endIndex: Int { content.endIndex };
    var currentlyLoading = false;
    
    var maxPages = 10;
    var nextPage = 1;
    var urlBase = "https://raw.githubusercontent.com/arthur-eudeline/cross-platform-comparison/main/fake-api/api-";
    
    init() {
        loadMore()
    }
    
    subscript(position: Index) -> ContentCardData {
        return content[ position ];
    }
    
    func loadMore(currentItem: ContentCardData? = nil ) {
        
        if (!shouldLoadMoreData(currentItem: currentItem)) {
            return;
        }
        currentlyLoading = true;
        
        let urlString = "\(urlBase)\(nextPage).json"
        let url = URL(string: urlString)!
        let task = URLSession.shared.dataTask(
            with: url,
            completionHandler: parseFromResponse(data:response:error:)
        );
        task.resume();
        
        
    }
    
    func shouldLoadMoreData(currentItem: ContentCardData? = nil ) -> Bool {
        if self.currentlyLoading || nextPage > (maxPages) {
            return false;
        }
        
        guard let currentItem = currentItem else {
            return true;
        }
        

        for n in (content.count - 4)...(content.count - 1) {
            if (n >= 0 && currentItem.uuid == content[n].uuid) {
                return true;
            }
        }
        
        return false
    }

    func parseFromResponse(data: Data?, response: URLResponse?, error: Error?) {
        guard error == nil else {
            print("Error \(error!)")
            currentlyLoading = false
            return
        }
        guard let data = data else {
            print("No data found")
            currentlyLoading = false
            return
        }
        
        let contentItem = parseFromData(data: data)
        DispatchQueue.main.async {
            self.content.append(contentsOf: contentItem)
            self.nextPage += 1;
            self.currentlyLoading = false
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
            guard let date = itemMap["date"] as? String else {
                continue;
            };
            guard let imageUrl = itemMap["image"] as? String else {
                continue;
            };
            guard let description = itemMap["description"] as? String else {
                continue;
            };
            items.append(ContentCardData(title: title, date: date, image: imageUrl, description: description));
        }
        return items;
    }
}

struct PhoneContentCard: View {
    var data: ContentCardData;
    @ObservedObject var image: ContentCardImage;
    
    init(data: ContentCardData) {
        self.data = data;
        self.image = data.image
    }

    func getImage() -> some View {
        if (image.loaded) {
            return AnyView(Image(uiImage: image.image!)
                .resizable()
                .scaledToFill()
                .frame(height: 200)
                .clipped(antialiased: true))
        }
        return AnyView(Rectangle()
            .frame(height: 200)
            .foregroundColor(/*@START_MENU_TOKEN@*/Color(hue: 1.0, saturation: 0.0, brightness: 0.582)/*@END_MENU_TOKEN@*/))
        
    }
    
    var body: some View {
        return VStack() {
            Group {
                getImage()
            }
            .onAppear {
                print("Appeared");
                image.load()
            }
            
        
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
    @ObservedObject var image: ContentCardImage;
    
    init(data: ContentCardData, screenWidth: CGFloat) {
        self.data = data;
        self.screenWidth = screenWidth;
        self.image = data.image
    }

    
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
