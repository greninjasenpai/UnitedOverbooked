//
//  EndGame.swift
//  UnitedOverbooked2
//
//  Created by Myank Singhal on 4/29/17.
//  Copyright © 2017 Myank Singhal. All rights reserved.
//

import AVFoundation
import SpriteKit

class EndGame: SKScene {
    let playButton = SKSpriteNode(imageNamed:"Spaceship")
    let IntroText = SKLabelNode(fontNamed: "Chalkduster")
    
    override func didMove(to view: SKView) {
        playButton.position=CGPoint(x:frame.midX,y:(frame.midY))
        addChild(playButton)
        backgroundColor=UIColor(colorLiteralRed: 63.0/255.0, green: 146.0/255.0, blue: 219.0/255.0, alpha: 1.0)
        IntroText.position=CGPoint(x: frame.midX, y: frame.midY+playButton.size.height)
        IntroText.text="You were dragged out"
        self.IntroText.fontSize = 22
        
        addChild(IntroText)
        playSound()
     
        
    }
    
    var player: AVAudioPlayer?
    
    func playSound() {
        let url = Bundle.main.url(forResource: "Meme_Audio", withExtension: "mp3")!
        
        do {
            player = try AVAudioPlayer(contentsOf: url)
            guard let player = player else { return }
            
            player.prepareToPlay()
            player.play()
        } catch let error {
            print(error.localizedDescription)
        }
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

