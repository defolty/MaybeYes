//
//  ChangeCommandVC.swift
//  MaybeYes
//
//  Created by Nikita Nesporov on 17.09.2021.
//

import UIKit
 

// MARK: - Category Cards

struct Category {
    
    var name: String
    var image: UIImage
    var forLabel: String
    var numForCatagories: Int
}
/*
 func changeEx(choosedCategorie
 */

class Menu {
    
    var categories = [Category]()
    
    init() {
        setup()
    }
    
    func setup() {
        
        let firstCategory = Category(name: "CategoryFirst",
                                     image: UIImage(named: "firstCategory")!, forLabel: "Любое", numForCatagories: 1)
        let secondCategory = Category(name: "CategorySecond",
                                      image: UIImage(named: "secondCategory")!, forLabel: "Новогоднее", numForCatagories: 2)
        let thirdCategory = Category(name: "CategoryThird",
                                     image: UIImage(named: "thirdCategory")!, forLabel: "Животные", numForCatagories: 3)
        let fourthCategory = Category(name: "CategoryFourth",
                                      image: UIImage(named: "fourthCategory")!, forLabel: "Предметы", numForCatagories: 4)
        let fivesCategory = Category(name: "CategoryFives",
                                     image: UIImage(named: "fivesCategory")!, forLabel: "Игры", numForCatagories: 5)
        let sixCategory = Category(name: "CategorySix",
                                   image: UIImage(named: "sixCategory")!, forLabel: "Технологии", numForCatagories: 6)
        let sevensCategory = Category(name: "CategorySeven",
                                      image: UIImage(named: "sevensCategory")!, forLabel: "Наука", numForCatagories: 7)
        let eightsCategory = Category(name: "CategoryEight",
                                      image: UIImage(named: "eightCategory")!, forLabel: "Страны", numForCatagories: 8)
        let ninesCategory = Category(name: "CategoryNine",
                                     image: UIImage(named: "ninesCategory")!, forLabel: "Еда", numForCatagories: 9)
        let tensCategory = Category(name: "CategoryTen",
                                    image: UIImage(named: "tensCategory")!, forLabel: "Слова", numForCatagories: 10)
        let elevensCategory = Category(name: "CategoryEleven",
                                       image: UIImage(named: "elevensCategory")!, forLabel: "Напитки", numForCatagories: 11)
        let twelvesCategory = Category(name: "CategoryTwelve",
                                       image: UIImage(named: "twelveCategory")!, forLabel: "Вещи", numForCatagories: 12)
        
        self.categories = [
            firstCategory, secondCategory, thirdCategory,
            fourthCategory, fivesCategory, sixCategory,
            sevensCategory, eightsCategory, ninesCategory,
            tensCategory, elevensCategory, twelvesCategory
        ]
    }
}

// MARK: - Change Category From Collection View

class ChangeGame: UIViewController {
    
    @IBOutlet var collectionView: UICollectionView!
    
    @IBOutlet var outletBackToStart: UIButton!
    
    var menu: Menu = Menu()
     
    override func viewDidLoad() {
        super.viewDidLoad()
        
        outletBackToStart.setTitle("", for: .normal)
        
        self.collectionView.register(UINib(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CollectionViewCell")
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    } 
    
    @IBAction func backToStartButton(_ sender: UIButton) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let goToStart = storyboard.instantiateViewController(withIdentifier: "StartID") as! StartViewController
        
        // строка для перехода на следующие экран без модального вида
        goToStart.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
        goToStart.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        
        present(goToStart, animated: true)
    }
}


// MARK: - Extensions for Change Game Class

extension ChangeGame: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
     
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return menu.categories.count
    }
     
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        let category = menu.categories[indexPath.item]
        cell.setupCell(category: category)
        
        return cell
    }
     
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: UIScreen.main.bounds.width, height: 120)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.row <= menu.categories.count {
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let goToGame = storyboard.instantiateViewController(withIdentifier: "GameID") as! Game
            
            /// строка для перехода на следующие экран без модального вида
            goToGame.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
            goToGame.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
            
            present(goToGame, animated: true)
            
        } else {
            print("sometimes we cry...")
        }
    }
}


// MARK: - Возможно свайп назад для Navigation

/*
final class SwipeNavigationController: UINavigationController {
    
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        
        delegate = self
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // This needs to be in here, not in init
        interactivePopGestureRecognizer?.delegate = self
    }
    
    deinit {
        delegate = nil
        interactivePopGestureRecognizer?.delegate = nil
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        duringPushAnimation = true
        
        super.pushViewController(viewController, animated: animated)
    }
    
    fileprivate var duringPushAnimation = false
    
}

extension SwipeNavigationController: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        guard let swipeNavigationController = navigationController as? SwipeNavigationController else { return }
        
        swipeNavigationController.duringPushAnimation = false
    }
    
}

extension SwipeNavigationController: UIGestureRecognizerDelegate {
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard gestureRecognizer == interactivePopGestureRecognizer else {
            return true // default value
        }
        
        // Disable pop gesture in two situations:
        // 1) when the pop animation is in progress
        // 2) when user swipes quickly a couple of times and animations don't have time to be performed
        return viewControllers.count > 1 && duringPushAnimation == false
    }
}
 */
