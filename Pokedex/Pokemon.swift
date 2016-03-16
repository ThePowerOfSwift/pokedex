//
//  Pokemon.swift
//  Pokedex
//
//  Created by Mihail Șalari on 16.03.2016.
//  Copyright © 2016 PlatinumCode. All rights reserved.
//

import Foundation
import Alamofire

class Pokemon {
    
    private var namePrivate: String!
    private var pokedexIDPrivate: Int!
    private var descriptionPrivate: String!
    private var typePrivate: String!
    private var defensePrivate: String!
    private var heightPrivate: String!
    private var weightPrivate: String!
    private var attackPrivate: String!
    private var nextEcolutionTextPrivate: String!
    private var pokemonURLPrivate: String!
    private var nextEvolutionIDPrivate: String!
    private var nextEvolutionLevelPrivate: String!
    
    
    var name: String {
        return namePrivate // is in initializer
    }
    
    var pokedexID: Int {
        return pokedexIDPrivate // is in initializer
    }
    
    
    var description: String {
        if typePrivate == nil {
            typePrivate = ""
        }
        return typePrivate
    }
    
    var defense: String {
        if defensePrivate == nil {
            defensePrivate = ""
        }
        return defensePrivate
    }
    
    var type: String {
        if typePrivate == nil {
            typePrivate = ""
        }
        return typePrivate
    }
    
    var height: String {
        if heightPrivate == nil {
            heightPrivate = ""
        }
        return heightPrivate
    }
    
    var weight: String {
        if weightPrivate == nil {
            weightPrivate = ""
        }
        return weightPrivate
    }
    
    var attack: String {
        if attackPrivate == nil {
            attackPrivate = ""
        }
        return attackPrivate
    }
    
    var nextEvolutionText: String {
        if nextEcolutionTextPrivate == nil {
            nextEcolutionTextPrivate = ""
        }
        return nextEcolutionTextPrivate
    }
    
    var nextEvolutionID: String {
        if nextEvolutionIDPrivate == nil {
            nextEvolutionIDPrivate = ""
        }
        return nextEvolutionIDPrivate
    }
    
    var nextEvolutionLevel: String {
        get {
            if nextEvolutionLevelPrivate == nil {
                nextEvolutionLevelPrivate = ""
            }
            return nextEvolutionLevelPrivate
        }
    }
    
    
    
    init(name: String, pokedexID: Int) {
        self.namePrivate = name
        self.pokedexIDPrivate = pokedexID
        
        pokemonURLPrivate = "\(urlBase)\(urlPokemon)\(self.pokedexID)"
    }
    
    
    
    func downloadPokemonDetails(completed: DownloadComplete) {
        
        let url = NSURL(string: pokemonURLPrivate)!
        
        Alamofire.request(.GET, url).responseJSON { (response) -> Void in
            // this clojure is called if after request is done

            if let dict = response.result.value as? Dictionary<String, AnyObject> {
                
                if let weight = dict["weight"] as? String {
                    self.weightPrivate = weight
                }
                
                if let height = dict["height"] as? String {
                    self.heightPrivate = height
                }
                
                if let attack = dict["attack"] as? Int {
                    self.attackPrivate = String(attack)
                }
                
                if let defense = dict["defense"] as? Int {
                    self.defensePrivate = String(defense)
                }
                
                print(self.weightPrivate)
                print(self.heightPrivate)
                print(self.attackPrivate)
                print(self.defensePrivate)
                
                
                if let types = dict["types"] as? [Dictionary<String, String>] where types.count > 0 { // array of dicts
                    //print(types.debugDescription) for see the types
                    if let name = types[0]["name"] {
                        self.typePrivate = name
                    }
                    
                    if types.count > 1 {
                        for x in 0..<types.count {
                            if let name = types[x]["name"] {
                                self.typePrivate! += "/\(name.capitalizedString)"
                            }
                        }
                    }
                } else {
                self.typePrivate = ""
                }
                print(self.typePrivate)
                
                if let descriptionArray = dict["descriptions"] as? [Dictionary<String, String>] where descriptionArray.count > 0 {
                    
                    if let fixURL = descriptionArray[0]["resurce_uri"] {
                        let nsurl = NSURL(string: "\(urlBase)\(fixURL)")!
                        
                        Alamofire.request(.GET, nsurl).responseJSON(completionHandler: { (response) -> Void in
                           // this clojure is called if after request is done
                            
                            if let descArray = response.result.value as? Dictionary<String, AnyObject> {
                                if let descript = descArray["description"] as? String {
                                    self.descriptionPrivate = descript
                                    print(self.descriptionPrivate)
                                }
                            }
                            
                            completed() //added if rewuest is done
                        })
                        
                    } else {
                        self.descriptionPrivate = ""
                    }
                    // after rewuest Alamofire
                    //Evolution
                    
                    if let evolutions = dict["evolutions"] as? [Dictionary<String, AnyObject>] where evolutions.count > 0 {
                        if let to = evolutions[0]["to"] as? String {
                            
                            // Mega is not found
                            //C'ant support mega pokemon right now but api still has mega data
                            if to.rangeOfString("mega") == nil {
                                if let uri = evolutions[0]["resource_uri"] as? String {
                                    
                                    let newString = uri.stringByReplacingOccurrencesOfString("/api/v1/pokemon/", withString: "")
                                    let num = newString.stringByReplacingOccurrencesOfString("/", withString: "")
                                    
                                    self.nextEvolutionIDPrivate = num
                                    self.nextEcolutionTextPrivate = to
                                    
                                    if let level = evolutions[0]["level"] as? Int {
                                        self.nextEvolutionLevelPrivate = "\(level)"
                                    }
                                }
                                
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}