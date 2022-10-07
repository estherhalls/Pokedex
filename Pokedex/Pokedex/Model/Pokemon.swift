//
//  Pokemon.swift
//  Pokedex
//
//  Created by Esther on 10/7/22.
//

import Foundation
class Pokemon {
    let name: String
    let id: Int
    let spritePath: String
    let height: Int
    let moves: [String]
    let abilities: [String]
    
    // Designated Initializer
    init(name: String, id: Int, spritePath: String, height: Int, moves: [String], abilities: [String]) {
        self.name = name
        self.id = id
        self.spritePath = spritePath
        self.height = height
        self.moves = moves
        self.abilities = abilities
    }
    
} // End of Class

extension Pokemon {
    // This is different than the NEO and Monster projects because we are parsing from the top level instead of starting from the specific nested dictionary.
    // Don't go in order - do top level first
    /// Instead of parsing in NetworkController as before, we are parsing within this extension
    /// Abilities and Moves are not accessible at top level because we want the values within their array of dictionaries
    /// spritePath is not accessible from top level because it is within sprite which is top level
    
    convenience init?(topLevelDictionary: [String:Any]) {
        guard let name = topLevelDictionary["name"] as? String,
              let id = topLevelDictionary["id"] as? Int,
              let height = topLevelDictionary["height"] as? Int,
              let abilitiesArray = topLevelDictionary["abilities"] as? [[String:Any]],
              let movesArray = topLevelDictionary["moves"] as? [[String:Any]],
        let spriteDict = topLevelDictionary["sprites"] as? [String:Any] else {return nil}
        
        // Abilties:
        // Temporary Abilities Array to break it out of for-in loop
        var tempAbilitiesArray: [String] = []
        // Second Level In - for-in loop
        for abilityDictionary in abilitiesArray {
            // Third Level
            guard let deeperAbilityDict = abilityDictionary["ability"] as? [String:String],
                  // Fourth level
                  let name = deeperAbilityDict["name"] else {return nil}
            // Break this string out of the for-in by appending
            tempAbilitiesArray.append(name)
        }
        
        // Moves:
        // Temporary Moves Array
        var tempMovesArray: [String] = []
        // Second level in for Moves
        for movesDictionary in movesArray {
            // Third Level
            guard let moveDictionary = movesDictionary["move"] as? [String:Any],
                  // Fourth Level
                  let name = moveDictionary["name"] as? String else {return nil}
            tempMovesArray.append(name)
        }
        
        // Sprite:
        // No for-in because the dictionary is NOT within an array
        guard let spritePath = spriteDict["front_shiny"] as? String else {return nil}
        
        // Designated initializer to create Pokemon object
        self.init(name: name, id: id, spritePath: spritePath, height: height, moves: tempMovesArray, abilities: tempAbilitiesArray)
    }
} // End of Extension
