//
//  StartViewController.swift
//  MaybeYes
//
//  Created by Nikita Nesporov on 17.09.2021.
//

import UIKit

class StartViewController: UIViewController {
     
    @IBOutlet var startButton: UIButton!
     
    @IBOutlet var middleView: UIView!
    @IBOutlet var middleImage: UIImageView!
    
    @IBOutlet var leftButtonTeam: UIButton!
    @IBOutlet var rightButtonTeam: UIButton!
    
    @IBOutlet var upLeftView: UIView!
    @IBOutlet var upRightView: UIView!
     
    @IBOutlet var middleViewLabel: UILabel!
    
    let teamImages = [#imageLiteral(resourceName: "First"), #imageLiteral(resourceName: "Second")]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startButton.layer.cornerRadius = 12
        startButton.clipsToBounds = true
        
        upLeftView.layer.cornerRadius = 12
        upRightView.layer.cornerRadius = 12
         
        middleView.layer.cornerRadius = 12
          
        leftButtonTeam.setImage(teamImages[0], for: .normal)
        leftButtonTeam.setTitle("", for: .normal)
        
        rightButtonTeam.setImage(teamImages[1], for: .normal)
        rightButtonTeam.setTitle("", for: .normal)
        
        middleViewLabel.text = ""
    }
     
    override var prefersStatusBarHidden: Bool {
        return true
    }
     
    @IBAction func leftTeamAction(_ sender: UIButton) {
        leftButtonTeam.isSelected = !leftButtonTeam.isSelected
        
        switch leftButtonTeam.isSelected {
        case true:
            Haptics.impact(.heavy)
            rightButtonTeam.isSelected = false
            middleViewLabel.text = "You Play With Jerry!"
            middleImage.image = teamImages[0]
            middleImage.isHidden = false
            //upLeftView.backgroundColor = .systemGray2
        case false:
            Haptics.impact(.light)
            middleViewLabel.text = ""
            middleImage.isHidden = true
            //upLeftView.backgroundColor = .clear
        }
    }
    
    @IBAction func rightTeamAction(_ sender: UIButton) {
        rightButtonTeam.isSelected = !rightButtonTeam.isSelected
        
        switch rightButtonTeam.isSelected {
        case true:
            Haptics.impact(.heavy)
            leftButtonTeam.isSelected = false
            middleViewLabel.text = "You Play With Tom!"
            middleImage.image = teamImages[1]
            middleImage.isHidden = false
            //upRightView.backgroundColor = .systemGray2
        case false:
            Haptics.impact(.light)
            middleViewLabel.text = ""
            middleImage.isHidden = true
            //upRightView.backgroundColor = .clear
        }
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
