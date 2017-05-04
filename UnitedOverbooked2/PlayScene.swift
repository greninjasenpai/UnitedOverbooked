//
//  PlayScene.swift
//  UnitedOverbooked2
//
//  Created by Myank Singhal on 4/28/17.
//  Copyright © 2017 Myank Singhal. All rights reserved.
//

import SpriteKit

class PlayScene: SKScene, SKPhysicsContactDelegate{
    //let running_platform=SKSpriteNode(imageNamed: "Airplane_background")
    let block1=SKSpriteNode(imageNamed: "block12")
    let runningBar = SKSpriteNode(imageNamed:"Airplane_background")
    let runningBar2 = SKSpriteNode(imageNamed:"Airplane_background")
    let hero = SKSpriteNode(imageNamed:"hero")
        let block2 = SKSpriteNode(imageNamed:"block2")
    let scoreText = SKLabelNode(fontNamed: "Chalkduster")
    let pepsican=SKSpriteNode(imageNamed: "Pepsi_can")
    let livesText=SKLabelNode(fontNamed: "Chalkduster")
    
    var origRunningBarPositionX = CGFloat(0)
    var maxBarY = CGFloat(0)
    var groundSpeed = 5
    var heroBaseline = CGFloat(0)
    var onGround = true
    var velocityY = CGFloat(0)
    let gravity = CGFloat(0.6)
    var lives_left = 3
    
    var blockMaxX = CGFloat(0)
    var origBlockPositionX = CGFloat(0)
    var score = 0
    
    enum ColliderType:UInt32 {
        case hero = 1
        case block = 2
    }
    
    override func didMove(to view: SKView) {
    self.backgroundColor = UIColor(colorLiteralRed: 63.0/255, green: 146.0/255, blue: 219.0/255, alpha: 1.0)
        
        self.physicsWorld.contactDelegate = self
        
        self.runningBar.anchorPoint = CGPoint(x: 0, y: 0.5)
        self.runningBar.position = CGPoint(
            x: self.frame.minX,
            y: self.frame.minY + (self.runningBar.size.height / 2))
        runningBar2.anchorPoint = CGPoint(x: 0, y: 0.5)
        self.runningBar2.position = CGPoint(
            x: self.frame.minX + runningBar.size.width,
            y: self.frame.minY + (self.runningBar2.size.height / 2))
        self.origRunningBarPositionX = self.runningBar.position.x
     
        
        self.heroBaseline = runningBar.size.height/4
        self.hero.position = CGPoint(x: self.frame.minX + self.hero.size.width + (self.hero.size.width / 4), y: self.heroBaseline)
        self.hero.physicsBody = SKPhysicsBody(circleOfRadius: CGFloat(self.hero.size.width / 2))
        self.hero.physicsBody?.affectedByGravity = false
        self.hero.physicsBody?.categoryBitMask = ColliderType.hero.rawValue
        self.hero.physicsBody?.contactTestBitMask = ColliderType.block.rawValue
        self.hero.physicsBody?.collisionBitMask = ColliderType.block.rawValue
        
        self.pepsican.position = CGPoint(x: self.frame.midX+self.pepsican.size.width, y: self.frame.maxY-self.pepsican.size.height)
        self.livesText.position = CGPoint(x: self.frame.midX-pepsican.size.width , y: self.frame.maxY-self.pepsican.size.height)
        
        self.block1.position = CGPoint(x: self.frame.maxX + self.block1.size.width, y: self.heroBaseline)
        self.block2.position = CGPoint(x: self.frame.maxX + self.block2.size.width*1.5, y: self.heroBaseline+block1.size.height/2.2)
        self.block1.physicsBody = SKPhysicsBody(rectangleOf: self.block1.size)
        self.block1.physicsBody?.isDynamic = false
        self.block1.physicsBody?.categoryBitMask = ColliderType.block.rawValue
        self.block1.physicsBody?.contactTestBitMask = ColliderType.hero.rawValue
        self.block1.physicsBody?.collisionBitMask = ColliderType.hero.rawValue
        
        self.block2.physicsBody = SKPhysicsBody(rectangleOf: self.block1.size)
        self.block2.physicsBody?.isDynamic = false
        self.block2.physicsBody?.categoryBitMask = ColliderType.block.rawValue
        self.block2.physicsBody?.contactTestBitMask = ColliderType.hero.rawValue
        self.block2.physicsBody?.collisionBitMask = ColliderType.hero.rawValue
        
        self.origBlockPositionX = self.block1.position.x + self.block1.size.width
        
        self.block1.name = "block1"
        self.block2.name = "block2"
        
        blockStatuses["block1"] = BlockStatus(isRunning: false, timeGapForNextRun: random(), currentInterval: UInt32(0))
        blockStatuses["block2"] = BlockStatus(isRunning: false, timeGapForNextRun: random(), currentInterval: UInt32(0))
        
        self.scoreText.text = "0"
        self.scoreText.fontSize = 42
        self.scoreText.position = CGPoint(x: self.frame.midX, y: self.frame.midY*1.5)
        
        self.blockMaxX = 0 - self.block1.size.width / 2
        hero.zPosition=2
        block2.zPosition=2
        block1.zPosition=2
        runningBar.zPosition=1
        runningBar2.zPosition=1
        
        self.addChild(self.runningBar)
        self.addChild(self.pepsican)
        self.addChild(self.livesText)
        self.addChild(self.runningBar2)
        self.addChild(self.hero)
        self.addChild(self.block1)
        self.addChild(self.block2)
        self.addChild(self.scoreText)
        self.livesText.text = String(self.lives_left)
        
        
    }
    
    func didBegin(_ contact:SKPhysicsContact) {
                if(lives_left==0){
        died()
        }
        lives_left-=1
        self.hero.position = CGPoint(x: self.frame.minX + self.hero.size.width + (self.hero.size.width / 4), y: self.frame.midY)
    }
    
    func died() {
        
        let scene = EndGame(size: self.size)
        let skView = self.view as SKView!
        skView?.ignoresSiblingOrder = true
        scene.size = (skView?.bounds.size)!
        scene.scaleMode = .resizeFill
        skView?.presentScene(scene)
        
    }
    
    func random() -> UInt32 {
        let range = UInt32(50)..<UInt32(200)
        return range.lowerBound + arc4random_uniform(range.upperBound - range.lowerBound + 1)
    }
    
    var blockStatuses:Dictionary<String,BlockStatus> = [:]
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if self.onGround {
            self.velocityY = -18.0
            self.onGround = false
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if self.velocityY < -9.0 {
            self.velocityY = -9.0
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        if (self.runningBar.position.x) == 0 {
            self.runningBar2.position.x = 0+runningBar.size.width
            runningBar.position.x=0
            print("1 over")
        }
        if (self.runningBar2.position.x) == 0 {
            self.runningBar.position.x = 0+runningBar2.size.width
            runningBar2.position.x=0
            print("2 over")
        }
        
        //jump
        self.velocityY += self.gravity
        self.hero.position.y -= velocityY
        
        if self.hero.position.y < self.heroBaseline {
            self.hero.position.y = self.heroBaseline
            velocityY = 0.0
            self.onGround = true
        }
        
        //rotate the hero
        let degreeRotation = CDouble(self.groundSpeed) * Double.pi / 180
        //rotate the hero
        self.hero.zRotation -= CGFloat(degreeRotation)
        self.livesText.text = String(self.lives_left)

        
        blockRunner()
        //move the ground
            runningBar.position.x -= CGFloat(self.groundSpeed)
            runningBar2.position.x -= CGFloat(self.groundSpeed)
        
     
       
    }
    var scorer=0.0
    
    func blockRunner() {
        for(block, blockStatus) in self.blockStatuses {
            let thisBlock = self.childNode(withName: block)!
            if blockStatus.shouldRunBlock() {
                blockStatus.timeGapForNextRun = random()
                blockStatus.currentInterval = 0
                blockStatus.isRunning = true
            }
            
            if blockStatus.isRunning {
                if thisBlock.position.x > blockMaxX {
                    thisBlock.position.x -= CGFloat(self.groundSpeed)
                }else {
                    thisBlock.position.x = self.origBlockPositionX
                    blockStatus.isRunning = false
                    self.score += 1
//                            if ((self.score % 5) == 0) {
//                                                        self.groundSpeed += 1
//                                                    }
//                            
//                    
                    self.scoreText.text = String(self.score)
                }
            }else {
                blockStatus.currentInterval += 1
            }
        }
    }
}
