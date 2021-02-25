//
//  GameFailure.swift
//  DropperGame
//
//  Created by Justin MacGregor on 2020-11-08.
//

import Foundation
import SpriteKit


class GameFailure: SKScene {
    var buttonMenu : SKSpriteNode!
    
    override func didMove(to view: SKView) {
        buttonMenu = (self.childNode(withName: "buttonMenu") as! SKSpriteNode)
        buttonMenu.name = "menu"
        buttonMenu.isUserInteractionEnabled = false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch:UITouch = touches.first! as UITouch
        let positionInScene = touch.location(in: self)
        let touchedNode = self.atPoint(positionInScene)
        
        if let name = touchedNode.name {
            if name == "menu" {
                loadGame()
            }
        }
    }
    
    func loadGame() {
        guard let skView = self.view as SKView? else {
            print("ERROR: Could not get SKView")
            return
        }

        /* 2) Load Game scene */
        guard let scene = MainMenu(fileNamed:"MainMenu") else {
            print("Could not make GameScene")
            return
        }

        /* 3) Ensure correct aspect mode */
        scene.scaleMode = .aspectFill

        /* 4) Start game scene */
        skView.presentScene(scene)
    }

}
