//
//  ContentService.swift
//  iOS.CrossPlatform.Test
//
//  Created by Arthur Eudeline on 02/05/2021.
//

import Foundation

struct ContentService {
    
    func get() -> [ContentCardData] {
        let url = URL(string: "https://jsonplaceholder.typicode.com/posts")!

        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
            guard let data = data else { return }
            print(String(data: data, encoding: .utf8)!)
        }

        task.resume();
        
        return [
            ContentCardData(title: "test", date: "test", image: "test", description: "test")
        ];
    }
    
}
