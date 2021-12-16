//
//  GameViewController.swift
//  690fp
//
//  Created by JPL-ST-SPRING2021 on 12/2/21.
//  Copyright © 2021 JPL-LT-013. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit
import Firebase

struct Player {
    var name: String = "default"
    var health: Int = 1
    var damage: Int = 1
    var action: String = "default"
}

struct Enemy {
    var name: String = "default"
    var health: Int = 1
    var damage: Int = 1
    var action: String = "default"
}

class GameViewController: UIViewController {

    
    
    var db: Firestore!
    var counter = 0;
    
    var newPlayer = Player()
    var newEnemy = Enemy()
    var pickedClass: String = "default"
    
    var storedData: [[String:Any]] = []
    var enemyData: [String:Any] = [:]
    
    // note: this loads every single time a view loads. Gross!
    
    @IBAction func start(_ sender: Any) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        db = Firestore.firestore()
        retrieveData()
        
        /*
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                
                // Present the scene
                view.presentScene(scene)
            }
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
        }
         */
    }
    
    // retrieving data from db
    func retrieveData(){
        var temp: [[String: Any]] = []
        var temp2: [String: Any] = [:]
        db.collection("players").getDocuments() { (queryDoc, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in queryDoc!.documents {
                    temp.append(document.data())
                }
            }
            print(temp[0], separator: ", ")
            print(temp[1], separator: ", ")
            print(temp[2], separator: ", ")
            self.storedData.append(contentsOf: temp)
            print("Got players: \(self.storedData)")
        }
        db.collection("enemies").getDocuments() { (queryDoc, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in queryDoc!.documents {
                    temp2.merge(document.data()) { (current, _) in current}
                }
            }
            self.enemyData.merge(temp2) { (current, _) in current}
            print("Got enemies: \(self.enemyData)")
        }
    }
    
    func setPlayerData(input: [String:Any]) {
        for (key, value) in input{
            switch key {
            case "name":
                newPlayer.name = (value as? String ?? "default")
                break
            case "health":
                newPlayer.health = (value as? Int ?? 1)
                break
            case "damage":
                newPlayer.damage = (value as? Int ?? 1)
                break
            case "action":
                newPlayer.action = (value as? String ?? "default")
                break
            default:
                print("error with setting data")
                break
            }
        }
        print("Set player data: \(newPlayer)")
    }
    
    // have to limit this to 1 enemy per set because we're gonna be pulling from a pool of random enemies
    func setEnemyData(input: [String:Any]) {
        for (key, value) in input{
            switch key {
            case "name":
                newEnemy.name = (value as? String ?? "default")
                break
            case "health":
                newEnemy.health = (value as? Int ?? 1)
                newEnemy.health += (Int(arc4random_uniform(3)))
                break
            case "damage":
                newEnemy.damage = (value as? Int ?? 1)
                newEnemy.damage += (Int(arc4random_uniform(2)))
                break
            case "action":
                newEnemy.action = (value as? String ?? "default")
                break
            default:
                print("error with setting data")
                break
            }
        }
        print("Set enemy data: \(newEnemy)")
    }
    
    @IBSegueAction func startSegue(_ coder: NSCoder) -> GameViewController? {
        print ("start test: \(storedData)")
        
        return GameViewController(coder: coder)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destVC = segue.destination as? BattleViewController else {
            return
        }
        
        destVC.activePlayer = newPlayer
        destVC.activeEnemy = newEnemy
    }
    
    // lets the vc know which class was picked
    @IBAction func pickWarrior(_ sender: Any) {
        setPlayerData(input: storedData[2])
        setEnemyData(input: enemyData)
    }
    
    @IBAction func pickMage(_ sender: Any) {
        setPlayerData(input: storedData[0])
        setEnemyData(input: enemyData)
    }
    
    @IBAction func pickRogue(_ sender: Any) {
        setPlayerData(input: storedData[1])
        setEnemyData(input: enemyData)
    }
    
    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
