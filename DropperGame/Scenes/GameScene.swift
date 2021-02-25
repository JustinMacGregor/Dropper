//
//  GameScene.swift
//  DropperGame
//
//  Created by Justin MacGregor on 2020-11-07.
//

import SpriteKit
import GameplayKit
struct PhysicsCategory {
    static let None : UInt32 = 0
    static let All : UInt32 = UInt32.max
    static let Goomba : UInt32 = 0b1 //1
    static let Mario : UInt32 = 0b10 //2
    static let Coin : UInt32 = 0b11 //3
}

var goombaCounter: Int = 0

class GameScene: SKScene,SKPhysicsContactDelegate {
    
    private var label : SKLabelNode?
    private var marioNode : SKSpriteNode?
    private var score : Int?
    private var lblScore : SKLabelNode?
    private var lblTimer : SKLabelNode?
    private var lblHighScore : SKLabelNode?
    
    override func didMove(to view: SKView) {
        startTimer()
        let defaults = UserDefaults.standard
        let highScore = defaults.integer(forKey: "HighScore")

        self.lblHighScore = self.childNode(withName: "//highScore") as? SKLabelNode
        self.lblHighScore?.text = "High Score: \(highScore)"
        
        if let slabel = self.lblScore {
            slabel.alpha = 0.0
            slabel.run(SKAction.fadeIn(withDuration: 2.0))
        }
        
        if let slabel = self.lblHighScore {
            slabel.alpha = 0.0
            slabel.run(SKAction.fadeIn(withDuration: 2.0))
        }
        
        if let slabel = self.lblTimer {
            slabel.alpha = 0.0
            slabel.run(SKAction.fadeIn(withDuration: 2.0))
        }
        
        
        marioNode?.position = CGPoint(x: 10, y: 10)
        marioNode = SKSpriteNode(imageNamed: "mario.png")
        marioNode?.size = CGSize(width: 100, height: 150)
        marioNode?.position = CGPoint(x: self.frame.width/2, y: self.frame.height/6)
        
        addChild(marioNode!)
        
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        physicsWorld.contactDelegate = self;
        
        marioNode?.physicsBody = SKPhysicsBody(circleOfRadius: (marioNode?.size.width)!/2)
        marioNode?.physicsBody?.isDynamic = true
        marioNode?.physicsBody?.categoryBitMask = PhysicsCategory.Mario
        marioNode?.physicsBody?.contactTestBitMask = PhysicsCategory.Goomba | PhysicsCategory.Coin
        marioNode?.physicsBody?.collisionBitMask = PhysicsCategory.None
        marioNode?.physicsBody?.usesPreciseCollisionDetection = true
        
        
        run(SKAction.repeatForever(SKAction.sequence([SKAction.run(addGoomba), SKAction.wait(forDuration: 0.5)])))
        
        score = 0
        self.lblScore = self.childNode(withName: "//score") as? SKLabelNode
        self.lblScore?.text = "Score: \(score!)"
        
        if let slabel = self.lblScore {
            slabel.alpha = 0.0
            slabel.run(SKAction.fadeIn(withDuration: 2.0))
        }
    }
    
    
    
    
    func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    func random(min: CGFloat, max: CGFloat) -> CGFloat {
        return random() * (max-min) + min
    }
    
    
    
    
    func addGoomba() {
        let goomba = SKSpriteNode(imageNamed: "goomba.png")
        goomba.size = CGSize(width: 100, height: 100)
        
        let actualX = random(min: goomba.size.width/2, max: size.width-goomba.size.width/2)
        
        goomba.position = CGPoint(x: actualX, y: size.height + goomba.size.height/2)
        
        addChild(goomba)
        
        goomba.physicsBody = SKPhysicsBody(rectangleOf: goomba.size)
        goomba.physicsBody?.isDynamic = true;
        goomba.physicsBody?.categoryBitMask = PhysicsCategory.Goomba
        goomba.physicsBody?.contactTestBitMask = PhysicsCategory.Mario
        goomba.physicsBody?.collisionBitMask = PhysicsCategory.None
        goomba.physicsBody?.usesPreciseCollisionDetection = true
        
        
        let actualDuration = random(min: CGFloat(2.0), max:CGFloat(4.0))
        
        let actionMove = SKAction.move(to: CGPoint(x: actualX, y: -goomba.size.height/2), duration: TimeInterval(actualDuration))
        
        let actionMoveDone = SKAction.removeFromParent()
        
        goomba.run(SKAction.sequence([actionMove, actionMoveDone]))
        
        goombaCounter = goombaCounter + 1
        if goombaCounter == 5 {
            addCoin()
        } else if goombaCounter > 5 {
            goombaCounter = 0
        }
    }
    
    
    
    
    func addCoin() {
        let coin = SKSpriteNode(imageNamed: "coin.png")
        coin.size = CGSize(width: 100, height: 100)
        
        let actualX = random(min: coin.size.width/2, max: size.width-coin.size.width/2)
        
        coin.position = CGPoint(x: actualX, y: size.height + coin.size.height/2)
        
        addChild(coin)
        
        coin.physicsBody = SKPhysicsBody(rectangleOf: coin.size)
        coin.physicsBody?.isDynamic = true;
        coin.physicsBody?.categoryBitMask = PhysicsCategory.Coin
        coin.physicsBody?.contactTestBitMask = PhysicsCategory.Mario
        coin.physicsBody?.collisionBitMask = PhysicsCategory.None
        coin.physicsBody?.usesPreciseCollisionDetection = true
        
        let actualDuration = random(min: CGFloat(2.0), max:CGFloat(4.0))
        
        let actionMove = SKAction.move(to: CGPoint(x: actualX, y: -coin.size.height/2), duration: TimeInterval(actualDuration))
        
        let actionMoveDone = SKAction.removeFromParent()
        
        coin.run(SKAction.sequence([actionMove, actionMoveDone]))
    }
    
    
    
    
    func startTimer() {
        var runCount = 0
        var countdown = 60
        self.lblTimer = self.childNode(withName: "//timer") as? SKLabelNode
        
        if let slabel = self.lblScore {
            slabel.alpha = 0.0
            slabel.run(SKAction.fadeIn(withDuration: 2.0))
        }

        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            runCount += 1
            countdown -= 1
            self.lblTimer?.text = "\(countdown)s"
            self.incrementScore(type: 2)
            if runCount == 60 {
                timer.invalidate()
                self.endGame(endType: 0)
            }
        }
    }
    
    
    
    
    
    func marioDidCollideWithGoomba(mario : SKSpriteNode, goomba: SKSpriteNode) {
        self.endGame(endType: 1)
    }
    
    
    
    func marioDidCollideWithCoin(mario : SKSpriteNode, coin: SKSpriteNode) {
        incrementScore(type: 1)
    }
    
    
    
    
    func incrementScore(type: Int) {
        if type == 1 {
            score = score! + 10
            self.lblScore?.text = "Score: \(score!)"
            if let slabel = self.lblScore {
                slabel.alpha = 0.0
                slabel.run(SKAction.fadeIn(withDuration: 2.0))
            }
        }
        
        else if type == 2 {
            score = score! + 1
            self.lblScore?.text = "Score: \(score!)"
            if let slabel = self.lblScore {
                slabel.alpha = 0.0
                slabel.run(SKAction.fadeIn(withDuration: 2.0))
            }
        }
    }
    
    
    
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        let contactA:SKPhysicsBody = contact.bodyA
        let contactB:SKPhysicsBody = contact.bodyB
        
        let nodeA = contactA.node as! SKSpriteNode
        let nodeB = contactB.node as! SKSpriteNode
        
        if contactA.categoryBitMask == 1 && contactB.categoryBitMask == 2 {
            marioDidCollideWithGoomba(mario: nodeA, goomba: nodeB)
        }
        
        else if contactA.categoryBitMask == 3 && contactB.categoryBitMask == 2 {
            marioDidCollideWithCoin(mario: nodeA, coin: nodeB)
        }
    }
    
    
    
    
    func moveMario(toPoint pos : CGPoint) {
        let actionMove = SKAction.move(to: CGPoint(x: pos.x, y: self.frame.height/6), duration: TimeInterval(0.1))
        
        marioNode?.run(SKAction.sequence([actionMove]))
    }
    
    
    
    
    func endGame(endType : Int) {
        if endType == 0 { //if game ends without dying
            storeScore()
            
            guard let skView = self.view as SKView? else {
                print("ERROR: Could not get SKView")
                return
            }
            
            guard let scene = GameSuccess(fileNamed:"GameSuccess") else {
                print("Could not make GameScene")
                return
            }
            scene.scaleMode = .aspectFill
            skView.presentScene(scene)
            
        } else if endType == 1 { //if the player hits a goomba
            
            guard let skView = self.view as SKView? else {
                print("ERROR: Could not get SKView")
                return
            }
            
            guard let scene = GameFailure(fileNamed:"GameFailure") else {
                print("Could not make GameScene")
                return
            }
            scene.scaleMode = .aspectFill
            skView.presentScene(scene)
        }
    }
    
    
    
    
    
    func storeScore() {
        let defaults = UserDefaults.standard
        if score! > defaults.integer(forKey: "HighScore") {
            defaults.set(score, forKey: "HighScore")
        }
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
        moveMario(toPoint: pos)
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        moveMario(toPoint: pos)
    }
    
    func touchUp(atPoint pos : CGPoint) {
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let label = self.label {
            label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
        }
        
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
