//
//  StartViewController.swift
//  MaybeYes
//
//  Created by Nikita Nesporov on 17.09.2021.
//

import UIKit

class StartViewController: UIViewController {
     
     
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // something
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    } 
    
    
    @IBAction func startButton(_ sender: UIButton) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let goToChangeGame = storyboard.instantiateViewController(withIdentifier: "ChangeGameID") as! ChangeGame
        
        // строка для перехода на следующие экран без модального вида
        goToChangeGame.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
        goToChangeGame.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        
        Haptics.impact(.medium)
        present(goToChangeGame, animated: true)
    }
}
