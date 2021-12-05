//
//  ViewController.swift
//  MaybeYes
//
//  Created by Nikita Nesporov on 29.08.2021.
//

import UIKit
  
 
// MARK: - Extension

public extension UIPanGestureRecognizer {
    var direction: Direction? {
        let velocity = velocity(in: view)
        let vertical = abs(velocity.y) > abs(velocity.x)
        switch (vertical, velocity.x, velocity.y) {
        case (true, _, let y) where y < -55: return .Up
        case (true, _, let y) where y > 55: return .Down
        case (false, let x, _) where x > 0: return .Right
        case (false, let x, _) where x < 0: return .Left
        default: return nil
        }
    }
}

extension UIViewController {
    func showAlert(withTitle title: String, withMessage message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: { action in })
        alert.addAction(ok)
         
        DispatchQueue.main.async(execute: {
            self.present(alert, animated: true)
        })
    }
}

// MARK: - Enum

public enum Direction: Int {
    
    case Up
    case Down
    case Left
    case Right
    
    public var isX: Bool { return self == .Left || self == .Right }
    public var isY: Bool { return !isX }
}



// MARK: - class Game

class Game: UIViewController {
 
    @IBOutlet var contentView: UIView!
    @IBOutlet var mainView: UIView!
    @IBOutlet var centralView: UIView!
    @IBOutlet var imageView: UIImageView!
    
    @IBOutlet var questionLabel: UILabel!
    @IBOutlet var upLabel: UILabel!
    @IBOutlet var downLabel: UILabel!
    
    @IBOutlet var progressBar: UIProgressView!
    @IBOutlet var viewWithButtons: UIView!
    
    @IBOutlet var scoreLabel: UILabel!
    @IBOutlet var lostScore: UILabel!
    
    @IBOutlet var outletBackButton: UIButton!
     
    private var panGesture: UIPanGestureRecognizer!
    private var animator: UIDynamicAnimator!
    private var snapping: UISnapBehavior!
    private var continuousPush: UIPushBehavior!
    private var instantaneousPush: UIPushBehavior!
    
    var losted = 0
    
    var touch: Bool?
    
    var quizBrain = QuizBrain()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
         
        outletBackButton.setTitle("", for: .normal)
        
        animator = UIDynamicAnimator(referenceView: view)
        snapping = UISnapBehavior(item: centralView, snapTo: view.center) //snapTo: mainView.center
        
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(draggedView))
         
        animator.addBehavior(snapping)
          
        centralView.addGestureRecognizer(panGesture)
        centralView.isUserInteractionEnabled = true
             
        updateUI()
    }
    
     
    // MARK: - Dragger View
    
    @objc func draggedView(_ sender: UIPanGestureRecognizer) {
         
        /// ограничения поля, за который мы не должны выходить
        let leftSideRestriction = self.mainView.frame.minX
        let rightSideRestriction = self.mainView.frame.maxX
        // let upSideRestriction = self.mainView.frame.minY
        // let downSideRestriction = self.mainView.frame.maxY
        
        /// отправная точка для отсчёта координат
        let centralViewHeight = self.centralView.frame.size.height
        let centralViewWidth = self.centralView.frame.size.width
        
        /// для определния координат вьюxи со словом
        let relativeLocation = panGesture.location(in: mainView)
          
        switch sender.state {
        case .began:
            animator.removeBehavior(snapping)
        case .changed:
            let translation = sender.translation(in: view) //view
            centralView.center = CGPoint(x: centralView.center.x + translation.x, y: centralView.center.y + translation.y)
            sender.setTranslation(.zero, in: view) //CGPoint
               
            /// текущее положение centralView
            let cvCurrentOriginXValue = self.centralView.frame.origin.x
            let cvCurrentOriginYValue = self.centralView.frame.origin.y
            
            /// left or right
            let imageViewRightEdgePosition = cvCurrentOriginXValue + centralViewWidth
            
            if cvCurrentOriginXValue <= leftSideRestriction {
                centralView.frame = CGRect(x: leftSideRestriction, y: cvCurrentOriginYValue, width: centralViewWidth, height: centralViewHeight)
            }
            
            if imageViewRightEdgePosition >= rightSideRestriction {
                centralView.frame = CGRect(x: rightSideRestriction - centralViewWidth, y: cvCurrentOriginYValue, width: centralViewWidth, height: centralViewHeight)
            }
              
            /// лейбл стрелки активация по скорости
            let vel = sender.velocity(in: view) //было : view
            if vel.y > 0 {
                upLabel.text = ""
                downLabel.text = "\u{25BC}" //"НЕ УГАДАНО \n\u{25BC}"
                   
            } else if vel.y < 0 {
                downLabel.text = ""
                upLabel.text = "\u{25B2}" //"\u{25B2} \nУГАДАНО"
                   
            } else {
                upLabel.text = ""
                downLabel.text = ""
            }
              
            /// действия по координатам
            switch relativeLocation.y {
            case 0...50:
                print("this is up")
                   
                upLabel.text = ""
                downLabel.text = ""
                
                animator.addBehavior(snapping)
                panGesture.isEnabled = false
                touch = true
                
                
                /// к следующему слову
                checkTouches()
            
            case 525...1000:
                print("this is down")
 
                // animator.addBehavior(continuousPush)
                animator.addBehavior(snapping)
                panGesture.isEnabled = false
                touch = false
                 
                /// к следующему слову
                checkTouches()
                
            default:
                break
            }
            
        default:
            animator.addBehavior(snapping)
            panGesture.isEnabled = true
            upLabel.text = ""
            downLabel.text = ""
        }
    }
      
    
    // MARK: - Show Alert For Main View
    
    func showAlertAction(withTitle title: String, withMessage message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in
            self.mainView.isHidden = false
            
            switch self.quizBrain.timeToRefresh {
            case true:
                self.quizBrain.refresh()
            case false:
                print("case false")
            default:
                print("default")
            }
        })
        alert.addAction(ok)
        
        DispatchQueue.main.async(execute: {
            self.present(alert, animated: true)
        })
    }
    
    
    // MARK: - Update UI
    
    @objc func updateUI() {
        questionLabel.text = quizBrain.getQuestionText()
        progressBar.progress = quizBrain.getProgress()
        scoreLabel.text = "\(quizBrain.getScore())"
        lostScore.text = "\(quizBrain.getLostScore())"
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let resultVC = storyboard.instantiateViewController(withIdentifier: "ResultID") as! Result
         
        if quizBrain.getScore() > quizBrain.getLostScore() && quizBrain.score + quizBrain.lostScore == quizBrain.quiz.count {
            mainView.isHidden = true
                
            resultVC.firstResultTeam = "\(quizBrain.getScore())"
            resultVC.secondResultTeam = "\(quizBrain.getLostScore())"
            
            resultVC.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
             
            present(resultVC, animated: true)
            
        } else if quizBrain.getScore() < quizBrain.getLostScore() && quizBrain.score + quizBrain.lostScore == quizBrain.quiz.count {
            mainView.isHidden = true
            
            self.showAlertAction(withTitle: NSLocalizedString("Конец игры!", comment: ""),
                                 withMessage: NSLocalizedString("Победила команда quizLostScore", comment: ""))
        } else {
            print("the game is not over yet")
        }
        
        print("Score = \(quizBrain.getScore()), LostScore = \(quizBrain.getLostScore()), questionNumber = \(quizBrain.questionNumber), quizCount = \(quizBrain.quiz.count)")
    }
    
    
    // MARK: - Check Touches
    
    func checkTouches() { 
        switch touch {
        case true:
            print("this is up")
            
            Haptics.impact(.success)
            
            upLabel.text = ""
            downLabel.text = ""

            let userAnswer = "True"

            quizBrain.checkAnswer(userAnswer: userAnswer) // было _ = quizBrain.checkAnswer(userAnswer: userAnswer)

            quizBrain.nextQuestion()
             
            imageView.transform = CGAffineTransform(scaleX: 0, y: 0)
            questionLabel.transform = CGAffineTransform(scaleX: 0, y: 0)
            
            UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 2, options: .curveEaseOut, animations: {
                self.view.layoutIfNeeded()
                self.imageView.transform = .identity
            }, completion: nil)
            
            UIView.animate(withDuration: 1.2, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 2, options: .curveEaseInOut, animations: {
                //self.view.layoutIfNeeded()
                self.questionLabel.transform = .identity
            }, completion: nil)

            Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(updateUI), userInfo: nil, repeats: false)

            panGesture.isEnabled = true
            
        case false:
            print("this is down")
            
            Haptics.impact(.error)
            
            upLabel.text = ""
            downLabel.text = ""
            
            let userAnswer = "False"
             
            quizBrain.checkAnswer(userAnswer: userAnswer) // было _ = quizBrain.checkAnswer(userAnswer: userAnswer)
            
            quizBrain.nextQuestion()
            
            imageView.transform = CGAffineTransform(scaleX: 0, y: 0)
            questionLabel.transform = CGAffineTransform(scaleX: 0, y: 0)
            
            UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 2, options: .curveEaseOut, animations: {
                self.view.layoutIfNeeded()
                self.imageView.transform = .identity
            }, completion: nil)
            
            UIView.animate(withDuration: 1.2, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 2, options: .curveEaseInOut, animations: {
                //self.view.layoutIfNeeded()
                self.questionLabel.transform = .identity
            }, completion: nil)
            
            Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(updateUI), userInfo: nil, repeats: false)
             
            panGesture.isEnabled = true
            
        default:
            animator.addBehavior(snapping)
        }
    }
    
    
    @IBAction func backButton(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let goToChangeGame = storyboard.instantiateViewController(withIdentifier: "ChangeGameID") as! ChangeGame
        
        /// строка для перехода на следующие экран без модального вида
        goToChangeGame.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
        goToChangeGame.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        
        Haptics.impact(.light)
        present(goToChangeGame, animated: true)
    }
    
}

//print("relativeLocation.x = \(relativeLocation.x)")
//print("relativeLocation.y = \(relativeLocation.y)")

/* обычные свайпы, рабочие (viewDidLoad)
let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
swipeLeft.direction = .left
self.view!.addGestureRecognizer(swipeLeft)

let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
swipeRight.direction = .right
self.view!.addGestureRecognizer(swipeRight)

let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
swipeUp.direction = .up
self.view!.addGestureRecognizer(swipeUp)

let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
swipeDown.direction = .down
self.view!.addGestureRecognizer(swipeDown)
*/

/* для простых свайпов
@objc func handleGesture(gesture: UISwipeGestureRecognizer) -> Void {
  
  switch gesture.direction {
  
  case UISwipeGestureRecognizer.Direction.left:
      print("Swipe Left")
      
  case UISwipeGestureRecognizer.Direction.right:
      print("Swipe Right")
      
  case UISwipeGestureRecognizer.Direction.up:
      let userAnswer = "True"
      
      _ = quizBrain.checkAnswer(userAnswer: userAnswer)
       
      let top = CGAffineTransform(translationX: 0, y: -65)
      let back = CGAffineTransform(translationX: 0, y: 0)
      
      imageView.transform = CGAffineTransform(scaleX: 0, y: 0)
      questionLabel.transform = CGAffineTransform(scaleX: 0, y: 0)
       
//            UIView.animate(withDuration: 0.4, delay: 0.0, options: [], animations: {
//                self.imageView.transform = top
//                self.questionLabel.transform = top
//            }, completion: nil)
      
      UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 1.5, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
          self.imageView.transform = top
          self.questionLabel.transform = top
      }, completion: nil)
       
      UIView.animate(withDuration: 0.4, delay: 0.8, usingSpringWithDamping: 0.1, initialSpringVelocity: 3, options: .curveLinear, animations: {
          self.imageView.transform = back
          self.questionLabel.transform = back
      }, completion: nil)
        
      quizBrain.nextQuestion()
       
      Timer.scheduledTimer(timeInterval: 1.2, target: self, selector: #selector(updateUI), userInfo: nil, repeats: false)
      
      print("Swipe Up")
      
  case UISwipeGestureRecognizer.Direction.down:
      let userAnswer = "False"
      
      _ = quizBrain.checkAnswer(userAnswer: userAnswer)
        
      let top = CGAffineTransform(translationX: 0, y: +65)
      let back = CGAffineTransform(translationX: 0, y: 0)
      
      imageView.transform = CGAffineTransform(scaleX: 0, y: 0)
      questionLabel.transform = CGAffineTransform(scaleX: 0, y: 0)
      
      UIView.animate(withDuration: 0.4, delay: 0.0, options: [], animations: {
          self.imageView.transform = top
          self.questionLabel.transform = top
      }, completion: nil)
       
      UIView.animate(withDuration: 0.4, delay: 0.8, usingSpringWithDamping: 0.1, initialSpringVelocity: 3, options: .curveLinear, animations: {
          self.imageView.transform = back
          self.questionLabel.transform = back
      }, completion: nil)
        
      quizBrain.nextQuestion()
      
      Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(updateUI), userInfo: nil, repeats: false)
      
      print("Swipe Down")
      
  default:
      print("Nothing to swipe")
  }
}
*/
