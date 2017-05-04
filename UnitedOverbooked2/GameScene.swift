//
//  GameScene.swift
//  UnitedOverbooked2
//
//  Created by Myank Singhal on 4/28/17.
//  Copyright © 2017 Myank Singhal. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    let playButton = SKSpriteNode(imageNamed:"Spaceship")
    let IntroText = SKLabelNode(fontNamed: "Chalkduster")
    
    override func didMove(to view: SKView) {
        playButton.position=CGPoint(x:frame.midX,y:(frame.midY))
        addChild(playButton)
         backgroundColor=UIColor(colorLiteralRed: 63.0/255.0, green: 146.0/255.0, blue: 219.0/255.0, alpha: 1.0)
        IntroText.position=CGPoint(x: frame.midX, y: frame.midY+playButton.size.height)
        IntroText.text="United Overbooked"
        self.IntroText.fontSize = 42

        addChild(IntroText)
    }
    
 
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches {
            let location = touch.location(in: self)
            if atPoint(location)==playButton{
                let scene = PlayScene(size: self.size)
                let skView=self.view as SKView!
                skView?.ignoresSiblingOrder=true
                scene.scaleMode = .resizeFill
                scene.size=(skView?.bounds.size)!
                skView?.presentScene(scene)
                
                
            }
        }
       
    }
    
  
    
    
}
