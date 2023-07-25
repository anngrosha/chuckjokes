//
//  SavedJokesViewController.swift
//  chuckjokes
//
//  Created by Ренат Хайруллин on 15.07.2023.
//

import UIKit
import CoreData

protocol SavedJokesViewControllerDelegate {
    func goBack()
}

class SavedJokesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate {

    
    @IBOutlet weak var goBackButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    lazy var frc: NSFetchedResultsController<Joke> = {
        let request = Joke.fetchRequest()
        request.sortDescriptors = [
            .init(key: "id", ascending: true)
        ]
        
        let frc = NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: PersistentContainer.shared.viewContext,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        
        frc.delegate = self
        
        return frc
    }()
    
    var delegate: SavedJokesViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        do {
            try frc.performFetch()
        } catch {
            print(error)
        }
        tableView.dataSource = self
        tableView.delegate = self
        

    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.reloadData()
    }
    
    // MARK - UITableViewDataSource, UITableViewDelegate
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let joke = frc.object(at: indexPath)
        guard let jokeCell = tableView.dequeueReusableCell(withIdentifier: "JokeTableViewCell", for: indexPath) as? JokeTableViewCell
        else { return UITableViewCell() }
        
        jokeCell.setUpData(joke)
        jokeCell.jokeView.numberOfLines = 0
        jokeCell.delegate = self
        jokeCell.indexPath = indexPath
        
        return jokeCell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = frc.sections {
            return sections[section].numberOfObjects
        } else {
            return 0
        }
    }
    @IBAction func goBackPushed(_ sender: Any) {
        delegate?.goBack()
    }
    
}


extension SavedJokesViewController: JokeTableViewCellDelegate {
    func deleteCell(_ jokeIndexPath: IndexPath) {
        let joke = frc.object(at: jokeIndexPath)
        PersistentContainer.shared.viewContext.delete(joke)
        PersistentContainer.shared.saveContext()
    }
    
    
}
