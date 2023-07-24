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
    
    @IBOutlet weak var pickerView: UIPickerView!
    private var thisJoke: JokeStruct?
    private var thisJokeSaved: Joke?
    
    private let manager: NetworkManagerProtocol = NetworkManger()
    private var categories: [String] = ["any"]
    private var thisCategory: String = "any"
    
    
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
        loadCategories()
        loadNewJoke()
        pickerView.dataSource = self
        pickerView.delegate = self
    }
    
    func loadCategories() {
        if self.categories.count == 1 {
            manager.fetchCategories { result in
                switch result {
                case let .success(response):
                    for category in response {
                        self.categories.append(category)
                    }
                case let .failure(error):
                    print(error)
                }
            }
            pickerView.reloadComponent(0)
        }
    }

    @IBAction func saveJoke(_ sender: Any) {
        if !saveJokeButton.isSelected {
            saveJokeButton.isSelected = true
            PersistentContainer.shared.performBackgroundTask { backgroundTask in
                let newJoke = Joke(context: backgroundTask)
                newJoke.id = self.thisJoke?.id
                newJoke.jokeText = self.thisJoke?.value
                self.thisJokeSaved = newJoke
                PersistentContainer.shared.saveContext(backgroundContext: backgroundTask)
            }
        } else {
            saveJokeButton.isSelected = false
            
            PersistentContainer.shared.viewContext.delete(self.thisJokeSaved!)
            self.thisJokeSaved = nil
            PersistentContainer.shared.saveContext()
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
        print(self.thisCategory)
        if self.thisCategory == "any" {
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
        } else {
            manager.fetchJokeCategory(self.thisCategory) { result in
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
}

extension ViewController: SavedJokesViewControllerDelegate {
    func goBack() {
        dismiss(animated: true)
    }
}

extension ViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 17
    }
    
    
}

extension ViewController: UIPickerViewDelegate {
    internal func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if row < self.categories.count {
            return self.categories[row]
        } else {
            return self.categories[0]
        }
    }
    internal func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if row < self.categories.count {
            self.thisCategory = self.categories[row]
        } else {
            self.thisCategory = self.categories[0]
        }
    }
}

