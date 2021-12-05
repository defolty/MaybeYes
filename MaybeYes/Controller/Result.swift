//
//  Result.swift
//  MaybeYes
//
//  Created by Nikita Nesporov on 25.09.2021.
//

import UIKit
 

class Result: UIViewController {
     
    @IBOutlet var endgame: UILabel!
    @IBOutlet var firstTeam: UILabel!
    @IBOutlet var secondTeam: UILabel!
    
    @IBOutlet var againButton: UIButton!
    @IBOutlet var chooseCategorie: UIButton!
    
    @IBOutlet var resultView: UIView!
    
    var firstResultTeam: String?
    var secondResultTeam: String?
    
    let gameVC = Game()
    let quizbrain = QuizBrain()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        firstTeam.text = firstResultTeam
        secondTeam.text = secondResultTeam
    }
    
    
    @IBAction func backToCategories(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let goToChangeGame = storyboard.instantiateViewController(withIdentifier: "ChangeGameID") as! ChangeGame
        
        /// строка для перехода на следующие экран без модального вида
        goToChangeGame.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
        goToChangeGame.modalTransitionStyle = UIModalTransitionStyle.flipHorizontal
        
        Haptics.impact(.light)
        present(goToChangeGame, animated: true)
    }
    
    @IBAction func gameAgain(_ sender: UIButton) {
        
    }
     
    func boom() {
       endgame.transform = CGAffineTransform(scaleX: 0, y: 0)
       firstTeam.transform = CGAffineTransform(scaleX: 0, y: 0)
       secondTeam.transform = CGAffineTransform(scaleX: 0, y: 0)
       againButton.transform = CGAffineTransform(scaleX: 0, y: 0)
       chooseCategorie.transform = CGAffineTransform(scaleX: 0, y: 0)
       
       UIView.animate(withDuration: 1, delay: 0.4, usingSpringWithDamping: 0.7, initialSpringVelocity: 2, options: .curveEaseOut, animations: {
           self.view.layoutIfNeeded()
           self.endgame.transform = .identity
       }, completion: nil)
       
       UIView.animate(withDuration: 1, delay: 0.7, usingSpringWithDamping: 0.7, initialSpringVelocity: 2, options: .curveEaseOut, animations: {
           self.view.layoutIfNeeded()
           self.firstTeam.transform = .identity
       }, completion: nil)
       
       UIView.animate(withDuration: 1, delay: 1, usingSpringWithDamping: 0.7, initialSpringVelocity: 2, options: .curveEaseOut, animations: {
           self.view.layoutIfNeeded()
           self.secondTeam.transform = .identity
       }, completion: nil)
       
       UIView.animate(withDuration: 1, delay: 1.3, usingSpringWithDamping: 0.7, initialSpringVelocity: 2, options: .curveEaseOut, animations: {
           self.view.layoutIfNeeded()
           self.againButton.transform = .identity
       }, completion: nil)
       
       UIView.animate(withDuration: 1, delay: 1.7, usingSpringWithDamping: 0.7, initialSpringVelocity: 2, options: .curveEaseOut, animations: {
           self.view.layoutIfNeeded()
           self.chooseCategorie.transform = .identity
       }, completion: nil)
    }
}
