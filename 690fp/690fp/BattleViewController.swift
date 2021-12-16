//
//  BattleViewController.swift
//  690fp
//
//  Created by JPL-ST-SPRING2021 on 12/16/21.
//  Copyright © 2021 JPL-LT-013. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class BattleViewController: UIViewController {
    
    @IBOutlet weak var classImage: UIImageView!
    @IBOutlet weak var testLabel: UILabel!
    @IBOutlet weak var classLabel: UILabel!
    @IBOutlet weak var attackButton: UIButton!
    @IBOutlet weak var defendButton: UIButton!
    @IBOutlet weak var enemyImage: UIImageView!
    @IBOutlet weak var playerHealth: UILabel!
    @IBOutlet weak var enemyHealth: UILabel!
    
    var activePlayer: Player?
    var activeEnemy: Enemy?
    var playerAction = false
    var actionTimer = 0
    var enemyAction = false
    
//    var storedPData: [[String:Any]] = []
//    var storedEData: [String:Any] = [:]
    
    override func viewDidLoad() {
        print("Player data: \(activePlayer!.name)")
        print("Enemy data: \(activeEnemy!.name)")
        loadData()
        //playerAction = activePlayer!.action
    }
    
    func loadData() {
        let playerPng = "\(activePlayer!.name).png"
        print(playerPng)
        if let image = UIImage(named: playerPng) {
            classImage.image = image
        }
        playerHealth.text = String(activePlayer!.health)
        classLabel.text = String(activePlayer!.name)
        
        let enemyPng = "\(activeEnemy!.name).png"
        print(enemyPng)
        if let image2 = UIImage(named: enemyPng) {
            enemyImage.image = image2
        }
        enemyHealth.text = String(activeEnemy!.health)
    }
    
    @IBAction func attack(sender: UIButton) {
        print("testing button")
        if (enemyAction){
            testLabel.text = String("enemy blocked your attack!")
            enemyAction = false
        } else {
            testLabel.text = String("\(activePlayer!.name) attacks!")
            activeEnemy!.health = activeEnemy!.health - activePlayer!.damage
        }
        
        updateHealth()
        if (activeEnemy!.health <= 0) {
            endScreen(entity: activePlayer!.name)
        }
        else {
            passTurn(entity: activePlayer!.name)
        }
        
    }
    
    // action isn't dynamic yet so just universal defend for now
    @IBAction func defend() {
        testLabel.text = String("\(activePlayer!.name) defends")
        playerAction = true
        passTurn(entity: activePlayer!.name)
    }
    
    func passTurn(entity: String) {
        if entity == activeEnemy?.name {
            //testLabel.text = String("passing enemy's turn")
            attackButton.isEnabled = true
            if (actionTimer == 1){
                actionTimer = 0
                defendButton.isEnabled = true
            }
            else {
                actionTimer += 1
            }
            // re-enable buttons
        }
        else {
            //testLabel.text = String("passing player's turn")
            attackButton.isEnabled = false
            defendButton.isEnabled = false
            _ = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false) { timer in
                if (!self.playerAction) {
                    self.defendButton.isEnabled = true
                }
                self.enemyTurn()
            }
            // disable buttons and then do monster turns
        }
    }
    
    func enemyTurn() {
        let random = arc4random_uniform(5)
        switch random {
        case 0, 1, 2, 3:
            print("rolled 3/4")
            enemyAtk()
            break
        default:
            print("rolled 1/4")
            doEnemyAction()
            break
        }
    }
    
    func enemyAtk() {
        testLabel.text = String("enemy attacks")
        if (playerAction){
            testLabel.text = String("\(activePlayer!.name) blocked the attack!")
            playerAction = false
        } else {
            activePlayer!.health = activePlayer!.health - activeEnemy!.damage
        }
        
        updateHealth()
        if (activePlayer!.health <= 0) {
            endScreen(entity: activeEnemy!.name)
        }
        else {
            passTurn(entity: activeEnemy!.name)
        }
    }
    
    func doEnemyAction() {
        if (activeEnemy?.action == "defend"){
            testLabel.text = String("enemy is defending")
            enemyAction = true
        } else {
            testLabel.text = String("enemy is defending")
            enemyAction = true
            // going to defend anyway because we don't have time for other functions
        }
        passTurn(entity: activeEnemy!.name)
        
    }
    
    func updateHealth() {
        let playerHP = activePlayer!.health
        if playerHP <= 0 {
            playerHealth.text = String("0")
        }
        else {
            playerHealth.text = String(playerHP)
        }
        
        let enemyHP = activeEnemy!.health
        if enemyHP <= 0 {
            enemyHealth.text = String("0")
        }
        else {
            enemyHealth.text = String(enemyHP)
        }
    }
    
    func endScreen(entity: String) {
        attackButton.isEnabled = false
        defendButton.isEnabled = false
        testLabel.text = String("\(entity) wins")
    }
    
}
