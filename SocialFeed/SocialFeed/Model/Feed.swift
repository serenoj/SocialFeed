//
//  Feed.swift
//  SocialFeed
//
//  Created by Juan Carlos Correa Arango on 4/12/19.
//  Copyright © 2019 Sereno. All rights reserved.
//

import SwiftUI


protocol OptionalDecodable: KeyedDecodingContainerProtocol {
    func feed_decodeOptional<T>(_ type: T.Type, forKey key: Self.Key) -> T? where T: Decodable
}

extension KeyedDecodingContainer: OptionalDecodable {
    func feed_decodeOptional<T>(_ type: T.Type, forKey key: K) -> T? where T : Decodable {
        do {
            return try decodeIfPresent(type, forKey: key)
        } catch {
            print("feed decoding problem")
            return nil
        }
    }
}



struct Author: Decodable {
    enum CodingKeys: String, CodingKey {
        case account
        case isVerified = "is-verified"
        case name
        case pinctureLink = "picture-link"
    }
    
    let account: String?
    var isVerified: Bool
    let name: String
    let pictureLink: String?
    var userImage: UIImage
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        account = try container.decodeIfPresent(String.self, forKey: .account)
        isVerified = try container.decodeIfPresent(Bool.self, forKey: .isVerified)!
        name = try container.decode(String.self, forKey: .name)
        pictureLink = try container.decodeIfPresent(String.self, forKey: .pinctureLink)
        userImage = UIImage(named: "colibri")!
        if let imageUrl = pictureLink, let url = URL(string: imageUrl) {
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    userImage = image
                }
            }
        }

    }
    
}

struct Markup: Decodable {
    enum CodingKeys: String, CodingKey {
        case length
        case link
        case location
    }
    
    let length: Int
    let link: String
    let location: Int
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        length = try container.decode(Int.self, forKey: .length)
        link = try container.decode(String.self, forKey: .link)
        location = try container.decode(Int.self, forKey: .location)
    }
}

struct FeedText: Decodable {
    enum CodingKeys: String, CodingKey {
        case plain
        case markup
    }
    
    let plain: String
    let markup: [Markup]?
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        markup = container.feed_decodeOptional([Markup].self, forKey: .markup)
        plain = try container.decode(String.self, forKey: .plain)
    }
}

struct Attachment: Decodable {
    enum CodingKeys: String, CodingKey {
        case pictureLink = "picture-link"
        case width
        case height
    }
    
    let pictureLink: String
    let width: Int
    let height: Int
    var attachedImage: UIImage
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        pictureLink = try container.decode(String.self, forKey: .pictureLink)
        width = try container.decode(Int.self, forKey: .width)
        height = try container.decode(Int.self, forKey: .height)
        attachedImage = UIImage(named: "articleImagePlaceholder")!
        let imageUrl = pictureLink
        if let url = URL(string: imageUrl) {
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    attachedImage = image
                }
            }
        }
    }
    
}

struct FeedItem: Decodable {
    enum CodingKeys: String, CodingKey {
        case text
        case attachment
        case network
        case link
        case date
        case author
    }
    
    let text: FeedText
    let attachment: Attachment?
    let author: Author
    let network: String
    let link: String
    let date: String
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        text = try container.decode(FeedText.self, forKey: .text)
        attachment = container.feed_decodeOptional(Attachment.self, forKey: .attachment)
        network = try container.decode(String.self, forKey: .network)
        link = try container.decode(String.self, forKey: .link)
        date = try container.decode(String.self, forKey: .date)
        author = try container.decode(Author.self, forKey: .author)
    }

    static var sampleFeed: [FeedItem] = Bundle.main.decode([FeedItem].self, from: "feedSample2.json")
    static var sampleArticle: FeedItem = Bundle.main.decode(FeedItem.self, from: "itemSample.json")

}





/*
enum FeedNetwork: String, Codable, Hashable, CaseIterable {
    case twitter​ = "twitter​"
    case ​facebook = "facebook"
    case instagram = "instagram"
}

//struct FeedSection: Codable {
//    var items: [FeedItem]
//}

struct FeedAuthor: Codable {
    var account: String
    var isVerified: Bool
    var name: String
    var pictureLink: String
    
    private enum CodingKeys: String, CodingKey {
        
        case account
        case isVerified = "is-verified"
        case name
        case pictureLink = "picture-link"
    }
}

struct FeedMarkup: Codable {
    var length: Int
    var link: String
    var location: Int
    
}

struct FeedText: Codable {
    var plain: String
    var markup: [FeedMarkup]
    
    private enum CodingKeys: String, CodingKey {
        case plain
        case markup
    }
}

struct Attachment: Codable {
    var pictureLink: String
    var width: Int
    var height: Int
    
    private enum CodingKeys: String, CodingKey {
        case pictureLink = "picture-link"
        case width
        case height
    }

}

struct FeedItem: Codable, Identifiable {
    
    var id = UUID()
    var author: FeedAuthor
    var date: String
    var link: String
    var network: FeedNetwork
    var text: FeedText
    var attachment: Attachment

    private enum CodingKeys: String, CodingKey {
        case author
        case date
        case link
        case network
        case text
        case attachment
    }
    
    init(author: FeedAuthor,
         date: String,
         link: String,
         network: FeedNetwork,
         text: FeedText,
         attachment: Attachment) {
        self.author = author
        self.date = date
        self.link = link
        self.network = network
        self.text = text
        self.attachment = attachment
    }
    
    init(from decoder: Decoder) throws {
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        author = try values.decode(FeedAuthor.self, forKey: .author)
        date = try values.decode(String.self, forKey: .date)
        link = try values.decode(String.self, forKey: .link)
        network = try values.decode(FeedNetwork.self, forKey: .network)
        text = try values.decode(FeedText.self, forKey: .text)
        attachment = try values.decode(Attachment.self, forKey: .attachment)
    }
}
*/
