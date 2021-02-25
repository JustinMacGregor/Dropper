//
//  MenuScene.swift
//  DropperGame
//
//  Created by Justin MacGregor on 2020-11-08.
//

import Foundation
import SpriteKit


class MainMenu: SKScene {
    var buttonPlay : SKSpriteNode!
    
    override func didMove(to view: SKView) {
        buttonPlay = (self.childNode(withName: "buttonPlay") as! SKSpriteNode)
        buttonPlay.name = "play"
        buttonPlay.isUserInteractionEnabled = false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch:UITouch = touches.first! as UITouch
        let positionInScene = touch.location(in: self)
        let touchedNode = self.atPoint(positionInScene)
        
        if let name = touchedNode.name {
            if name == "play" {
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
        guard let scene = GameScene(fileNamed:"GameScene") else {
            print("Could not make GameScene")
            return
        }

        /* 3) Ensure correct aspect mode */
        scene.scaleMode = .aspectFill

        /* 4) Start game scene */
        skView.presentScene(scene)
    }
}
