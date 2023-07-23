//
//  JokeTableViewCell.swift
//  chuckjokes
//
//  Created by Ренат Хайруллин on 15.07.2023.
//

import UIKit


final class JokeTableViewCell: UITableViewCell {

    
    
    @IBOutlet weak var jokeView: UILabel!
    
    
    var thisJoke: Joke?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func setUpData(_ joke: Joke) {
        self.thisJoke = joke
        jokeView.text = joke.jokeText
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        jokeView.text = nil
    }
}
