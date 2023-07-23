//
//  ViewController.swift
//  chuckjokes
//
//  Created by Ренат Хайруллин on 14.07.2023.
//

import UIKit
import CoreData

class ViewController: UIViewController, NSFetchedResultsControllerDelegate {
    

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

    
    @IBOutlet weak var goToSavedButton: UIButton!
    @IBOutlet weak var saveJokeButton: UIButton!
    @IBOutlet weak var jokeView: UILabel!
    @IBOutlet weak var chuckImageVIew: UIImageView!
    @IBOutlet weak var newJokeButton: UIButton!
    
    private var thisJoke: JokeStruct?
    
    private let manager: NetworkManagerProtocol = NetworkManger()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        do {
            try frc.performFetch()
        } catch {
            print(error)
        }
        self.view.backgroundColor = .white
        jokeView.numberOfLines = 0
        chuckImageVIew.download(from: "https://img.icons8.com/plasticine/12x/chuck-norris.png")
        loadNewJoke()
    }

    @IBAction func saveJoke(_ sender: Any) {
        saveJokeButton.isSelected = true
        PersistentContainer.shared.performBackgroundTask { backgroundTask in
            let newJoke = Joke(context: backgroundTask)
            newJoke.id = self.thisJoke?.id
            newJoke.jokeText = self.thisJoke?.value
            PersistentContainer.shared.saveContext(backgroundContext: backgroundTask)
        }
    }
    
    
    @IBAction func goToSaved(_ sender: Any) {
        
        guard let savedJokesViewController = storyboard?.instantiateViewController(withIdentifier: "SavedJokesViewController") as? SavedJokesViewController else { return }
        
        present(savedJokesViewController, animated: true)
        
        savedJokesViewController.delegate = self
        
    }
    
    
    @IBAction func newJokePushed(_ sender: Any) {
        loadNewJoke()
    }
    
    func pushDataToView() {
        jokeView.text = self.thisJoke?.value
    }
    
    func loadNewJoke() {
        saveJokeButton.isSelected = false
        manager.fetchJoke() { result in
            switch result {
            case let .success(response):
                self.thisJoke = response
                self.pushDataToView()
            case let .failure(error):
                print(error)
            }
        }
    }
}

extension ViewController: SavedJokesViewControllerDelegate {
    func goBack() {
        dismiss(animated: true)
    }
}

