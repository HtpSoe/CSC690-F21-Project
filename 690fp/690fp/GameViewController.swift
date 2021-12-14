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

class GameViewController: UIViewController {

    var counter = 0
    @IBOutlet weak var testLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
    @IBAction func attack(sender: UIButton) {
        let test = "testing button";
        print(test)
        updateLabel()
    }
    
    func updateLabel() {
        counter += 1
        print("counter: ", counter)
        testLabel.text = String(counter)
    }
    
    @IBAction func defend() {
        let test = "block that shit";
        print(test)
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
