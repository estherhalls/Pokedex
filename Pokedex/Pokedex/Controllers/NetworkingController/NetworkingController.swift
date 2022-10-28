//
//  NetworkingController.swift
//  Pokedex
//
//  Created by Esther on 10/7/22.
//

import UIKit

class NetworkingController {
    
    private static let baseURLString = "https://pokeapi.co"
    
    static func fetchPokemon(with searchTerm: String, completion: @escaping (Pokemon?) -> Void) {
        
        guard let baseURL = URL(string: baseURLString) else {return}
        let finalURL = baseURL.appendingPathComponent("/api/v2/pokemon/\(searchTerm.lowercased())")
        //        var urlComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
        //        urlComponents?.path = "/api/v2/pokemon/\(searchTerm.lowercased())"
        //
        //        guard let finalURL = urlComponents?.url else {return}
        //        print(finalURL)
        
        URLSession.shared.dataTask(with: finalURL) { dTaskData, _, error in
            if let error = error {
                print("Encountered error: \(error.localizedDescription)")
                completion(nil)
            }
            
            guard let pokemonData = dTaskData else {completion(nil); return}
            
            do {
                if let topLevelDict = try? JSONSerialization.jsonObject(with: pokemonData) as? [String:Any] {
                    // Because we did the parsing in the Model, we don't have to do it here. Just reference the model
                    let pokemon = Pokemon(topLevelDictionary: topLevelDict)
                    completion(pokemon)
                }
            }
        }.resume()
    }
    // Getting images from the internet requires network call with completion handler
    /// Remember to Import UIKit at top of file
    static func fetchImage(for pokemon: Pokemon, completion: @escaping (UIImage?) -> Void) {
        // Step 1 - Construct URL
        guard let url = URL(string: pokemon.spritePath) else {completion(nil); return}
        //Step 2 - DataTask
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error {
                print("🤬🤬🤬 There was an error with the image data task", error.localizedDescription)
                completion(nil); return
            }
            guard let imageData = data else {completion(nil); return}
            let image = UIImage(data: imageData)
            completion(image)
            
        }.resume()
    }
    
} // End of Class
