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

    @IBOutlet weak var classImage: UIImageView!
    @IBOutlet weak var testLabel: UILabel!
    @IBOutlet weak var defendButton: UIButton!
    @IBOutlet weak var pickWarrior: UIButton!
    @IBOutlet weak var pickRogue: UIButton!
    @IBOutlet weak var pickMage: UIButton!
    
    var db: Firestore!
    var counter = 0;
    
    var newPlayer = Player()
    var newEnemy = Enemy()
    
    var storedData: [String:Any] = [:]
    var enemyData: [String:Any] = [:]
    var hasObtainedData = false
    
    // note: this loads every single time a view loads. Gross!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // in case theres constant screen switching it doesnt spam the db for requests.
        // it doesnt actually work at all though so this needs a fix asap.
        if (self.hasObtainedData == false) {
            self.hasObtainedData = true
            let settings = FirestoreSettings()
            Firestore.firestore().settings = settings
            db = Firestore.firestore()
            retrieveData()
        }
        
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
        var temp: [String: Any] = [:]
        var temp2: [String: Any] = [:]
        db.collection("players").getDocuments() { (queryDoc, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in queryDoc!.documents {
                    temp.merge(document.data()) { (current, _) in current }
                }
            }
            self.storedData.merge(temp) { (current, _) in current}
            print("Got players: \(self.storedData)")
            self.setPlayerData(input: self.storedData)
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
            self.setEnemyData(input: self.enemyData)
        }
    }
    
    // setting data from db into struct
    // note: if there's multiple character entries in the db (which there are rn), it'll loop through those characters.
    // need to fix this so it only draws one specific thing (should be doable if we can get info from the view about which button was clicked which can be done with multiple functions)
    func setPlayerData(input: [String:Any]) {
        for (key, value) in input{
            switch key {
            case "name":
                self.newPlayer.name = (value as? String)!
                break
            case "health":
                self.newPlayer.health = (value as? Int)!
                break
            case "damage":
                self.newPlayer.damage = (value as? Int)!
                break
            case "action":
                self.newPlayer.action = (value as? String)!
                break
            default:
                print("error with setting data")
                break
            }
        }
        print("Set player data: \(self.newPlayer)")
    }
    
    // have to limit this to 1 enemy per set because we're gonna be pulling from a pool of random enemies
    func setEnemyData(input: [String:Any]) {
        for (key, value) in input{
            switch key {
            case "name":
                self.newEnemy.name = (value as? String)!
                break
            case "health":
                self.newEnemy.health = (value as? Int)!
                break
            case "damage":
                self.newEnemy.damage = (value as? Int)!
                break
            case "action":
                self.newEnemy.action = (value as? String)!
                break
            default:
                print("error with setting data")
                break
            }
        }
        print("Set enemy data: \(self.newEnemy)")
    }
    // for now it just acts as a print but later it'll be used to get specific classes from db.
    @IBAction func pickClass(sender: UIButton) {
        print("storedData: \(storedData)")
    }
    
    @IBAction func attack(sender: UIButton) {
        print("testing button")
        // tried to get sender info but seems rly weird
        // print(sender)
        updateLabel()
    }
    
    // updates the chat thing on the bottom right
    func updateLabel() {
        counter += 1
        print("counter: ", counter)
        testLabel.text = String(counter)
    }
    
    // action isn't dynamic yet so just universal defend for now
    @IBAction func defend() {
        flipDefend()
        
        // timer to flip defend back after 5 seconds
        // can use this as a baseline to "wait" for an action
        _ = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: false) { timer in
            self.flipDefend()
        }
        
        // note: delete this specific print on final build LOL
        print("block that shit")
    }

    // could be useful for limiting an action
    // for testing purposes, this also changes the class image and disables the defend button
    func flipDefend() {
        if (defendButton.isEnabled == true) {
            defendButton.isEnabled = false
            // could very easily have it swap to like \(newPlayer.name).png in order to switch the class image
            classImage.image = UIImage(named: "mage.png")
            print("defend button now false")
        }
        else if (defendButton.isEnabled == false) {
            defendButton.isEnabled = true
            classImage.image = UIImage(named: "knight.png")
            print("defend button now true")
        }
        else {
            // note: replace this with an error or something
            print("how tf did this happen lmao")
        }
    }
    
    // both need to dynamically update (see example in attack())
    func displayPlayerHealth() {
        
    }
    
    func displayEnemyHealth() {
        
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
