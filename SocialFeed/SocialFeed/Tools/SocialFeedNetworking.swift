//
//  SocialFeedNetworking.swift
//  SocialFeed
//
//  Created by Juan Carlos Correa Arango on 7/12/19.
//  Copyright © 2019 Sereno. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

class SocialFeedNetworking: ObservableObject {
    
    var didChange = PassthroughSubject<SocialFeedNetworking, Never>()
    
    var feed = [FeedItem]() {
        didSet {
            didChange.send(self)
        }
    }
    
    init() {
        guard let url = URL(string: "https://storage.googleapis.com/cdn-og-test-api/test-task/social/2.json") else { return }
        
        URLSession.shared.dataTask(with: url) { (data, _, _) in
            guard let data = data else { return }
            
            let feedList = try! JSONDecoder().decode([FeedItem].self, from: data)
            
            DispatchQueue.main.async {
                self.feed = feedList
            }
        }.resume()
    }
}
