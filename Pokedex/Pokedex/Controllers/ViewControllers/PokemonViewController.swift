//
//  PokemonViewController.swift
//  Pokedex
//
//  Created by Karl Pfister on 2/3/22.
//

import UIKit

class PokemonViewController: UIViewController {
// MARK: - Outlets
    @IBOutlet weak var pokemonSearchBar: UISearchBar!
    @IBOutlet weak var pokemonIDLabel: UILabel!
    @IBOutlet weak var pokemonNameLabel: UILabel!
    @IBOutlet weak var pokemonSpriteImageView: UIImageView!
    @IBOutlet weak var pokemonMovesTableView: UITableView!
    
    // MARK: - Properties
    var pokemon: Pokemon?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        /// Assign parent characteristics of table view and search bar to this view
        pokemonMovesTableView.delegate = self
        pokemonMovesTableView.dataSource = self
        pokemonSearchBar.delegate = self
    }
    
    // MARK: - Methods
    func updateViews(pokemon: Pokemon) {
        NetworkingController.fetchImage(for: pokemon) {image in
            guard let image else {return}
            DispatchQueue.main.async {
                self.pokemon = pokemon
                self.pokemonSpriteImageView.image = image
                self.pokemonIDLabel.text = "ID: \(pokemon.id)"
                self.pokemonNameLabel.text = pokemon.name
                self.pokemonMovesTableView.reloadData()
            }
        }
    }
    
}// End

// MARK: - Table View Data Source
extension PokemonViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pokemon?.moves.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "moveCell", for: indexPath)
        guard let pokemon else {return UITableViewCell()}
        let move = pokemon.moves[indexPath.row]
        cell.textLabel?.text = move
        return cell
    }
}

// MARK: - Search Bar Delegate
extension PokemonViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        NetworkingController.fetchPokemon(with: searchText) { pokemon in
            guard let pokemon else {return}
            self.updateViews(pokemon: pokemon)
        }
    }
}
