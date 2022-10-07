//
//  NetworkingController.swift
//  Pokedex
//
//  Created by Esther on 10/7/22.
//

import Foundation

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
                
                guard let pokemonData = dTaskData else {return}
                
                do {
                    
                }
            }.resume()
        }
    
} // End of Class
