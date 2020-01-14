//
//  DecoderHelper.swift
//  SocialFeed
//
//  Created by Juan Carlos Correa Arango on 4/12/19.
//  Copyright © 2019 Sereno. All rights reserved.
//

import UIKit

// Piece of code to help decode a local json file with a feed
extension Bundle {
    
    func decode<T: Decodable>(_ type: T.Type, from file: String) -> T {
        
        guard let url = self.url(forResource: file, withExtension: nil) else {
            fatalError("File \(file) was not found in bundle.")
        }

        guard let data = try? Data(contentsOf: url) else {
            fatalError("File \(file) was not found in bundle, or error converting to Data.")
        }

        let decoder = JSONDecoder()
        
        guard let decodedFeed = try? decoder.decode(T.self, from: data) else {
            fatalError("Error decoding file \(file).")
        }

        return decodedFeed
    }
}
