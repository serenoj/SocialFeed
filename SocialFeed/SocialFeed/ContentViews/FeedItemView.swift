//
//  FeedItemView.swift
//  SocialFeed
//
//  Created by Juan Carlos Correa Arango on 9/12/19.
//  Copyright © 2019 Sereno. All rights reserved.
//

import SwiftUI

struct FeedItemView: View {
    
    var feedItem: FeedItem
    var attachedImage: UIImage {
        get {
            guard let attatchement = feedItem.attachment else {
                return UIImage(named: "articleImagePlaceholder")!
            }

            return attatchement.attachedImage
        }
    }
    var verified: UIImage {
        get {
            return UIImage(named: "verified")!
        }
    }
    var width: CGFloat = UIScreen.main.bounds.size.width - 20.0
    var height: CGFloat {
        get {
            return width / 1.87
        }
    }
    var aspectRatio: CGFloat {
        get {
            guard let attatchement = feedItem.attachment else {
                return 1.87
            }
            
            return CGFloat(attatchement.width / attatchement.height)
        }
    }

    var body: some View {

            VStack(alignment: .leading, spacing: 2.0) {
                HStack(alignment: .center) {
                    Image(uiImage: feedItem.author.userImage)
                        .resizable()
                        .clipShape(Circle())
                        .frame(width: 50, height: 50)
                        .aspectRatio(contentMode: .fit)
                        .padding()
                    
                    VStack(alignment: .leading) {
                        HStack {
                            Text(feedItem.author.account ?? "")
                                .font(.caption)
                            if feedItem.author.isVerified {
                                Image(uiImage: verified)
                                    .resizable()
                                    .frame(width: 18, height: 18)
                                    .aspectRatio(contentMode: .fit)
                            }
                        }
                        Text(feedItem.author.name)
                            .font(.headline)
                    }
                    
                    Spacer()
                    
                    Image(uiImage: UIImage(named: feedItem.network)!)
                        .resizable()
                        .frame(width: 20, height: 20)
                        .aspectRatio(contentMode: .fit)
                        .padding()
                }
                
                Text(feedItem.text.plain)
                    .font(.body)
                    .fontWeight(.thin)
                    .multilineTextAlignment(.leading)
                    .lineLimit(nil)
                    .truncationMode(.head)
                    .padding()
                
                VStack(alignment: .leading, spacing: 4.0) {
                    Image(uiImage: attachedImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: width, height: height, alignment: .center)
                    
                    Text(feedItem.date)
                        .font(.caption)
                        .padding()
                }
            }
            .addBorder(Color.black, width: 2, cornerRadius: 10)

    
    }
}

#if DEBUG
struct FeedItemView_Previews: PreviewProvider {
    static var previews: some View {
        FeedItemView(feedItem: Bundle.main.decode(FeedItem.self, from: "itemSample.json"))
    }
}
#endif
/*
 
 VStack {
 Text(feedItem.author.name)
 Text(feedItem.date)
 }

 */
