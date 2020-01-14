//
//  ContentView.swift
//  SocialFeed
//
//  Created by Juan Carlos Correa Arango on 4/12/19.
//  Copyright © 2019 Sereno. All rights reserved.
//

import SwiftUI

extension View {
    public func addBorder<S>(_ content: S, width: CGFloat = 1, cornerRadius: CGFloat) -> some View where S : ShapeStyle {
        return overlay(RoundedRectangle(cornerRadius: cornerRadius).strokeBorder(content, lineWidth: width))
    }
}

struct ContentView: View {
    
    var feedItems = Bundle.main.decode([FeedItem].self, from: "feedSample2.json")
//    @State var socialFeedNetworking = SocialFeedNetworking()
    
    var body: some View {
        NavigationView {
            List(feedItems, id: \.link) { item in
                
                    FeedItemView(feedItem: item)
            }
            .navigationBarTitle("Social Feed")
            
//            List(socialFeedNetworking.feed) { article in
//                Text(article.author.name)
//            }.navigationBarTitle("Social Feed")
        }
    }
    
}

#if DEBUG
struct ContentView_Previews: PreviewProvider {

    static var previews: some View {
        ContentView()
//        ContentView(feedItems: Bundle.main.decode([FeedItem].self, from: "feedSample.json"))
    }
}
#endif
