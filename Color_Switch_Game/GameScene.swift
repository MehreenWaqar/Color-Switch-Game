//
//  GameScene.swift
//  Color_Switch_Game
//
//  Created by SAM on 27/04/2019.
//  Copyright © 2019 SAM. All rights reserved.
//

import SpriteKit
import GameplayKit

protocol SenderViewControllerDelegate {
    func highscore(data: Int)
    func score(data: Int)

}
struct PhysicsCategory{
    static let Player: UInt32 = 1
    static let Obs: UInt32 = 2
    static let Edge: UInt32 = 4

}
class GameScene: SKScene {
    
    let colors = [SKColor.yellow, SKColor.red, SKColor.blue, SKColor.green]
    let player = SKShapeNode(circleOfRadius: 30)
    
    var delegate_vc: SenderViewControllerDelegate?


    var obstacles: [SKNode] = []
    let obstacleSpacing: CGFloat = 1000
    let cameraNode = SKCameraNode()
    let scorelbl = SKLabelNode()
    var score = 0
    var highscore = UserDefaults().integer(forKey: "HIGHSCORE")

   
    override func didMove(to view: SKView) {
     
        print("highscore\(UserDefaults().integer(forKey: "HIGHSCORE"))")


        setPlayer()
        let playerBody = SKPhysicsBody(circleOfRadius: 20)
        playerBody.mass = 0.5
        playerBody.categoryBitMask = PhysicsCategory.Player
        playerBody.collisionBitMask = PhysicsCategory.Edge
        player.physicsBody = playerBody
        
        let edge = SKNode()
        edge.position = CGPoint(x: size.width / 2, y:160)
        let edgebody = SKPhysicsBody(rectangleOf: CGSize(width: 200, height: 10))
        edgebody.isDynamic = false
        edgebody.categoryBitMask = PhysicsCategory.Edge
        edge.physicsBody = edgebody
        addChild(edge)
        physicsWorld.gravity.dy = -22
        physicsWorld.contactDelegate = self
        addChild(cameraNode)
        camera = cameraNode
        cameraNode.position = CGPoint(x: size.width / 2, y:size.height / 2)
        scorelbl.position = CGPoint(x: -350, y: -900)
        scorelbl.fontColor = .white
        scorelbl.fontSize = 150
        scorelbl.text = String(score)
        cameraNode.addChild(scorelbl)
        
        
    }
    func setPlayer(){
      add_Player()
      add_Obs()
      add_Obs()
      add_Obs()
      


    }
    func add_Player(){
        let choice = Int(arc4random_uniform(4))
        switch choice{
        case 0:
             player.fillColor = .blue
        case 1:
             player.fillColor = .red
        case 2:
            player.fillColor = .yellow
        case 3:
            player.fillColor = .green
        default:
            print("Something went wrong")
        }
        player.strokeColor = player.fillColor
        player.position = CGPoint(x:size.width / 2,y:200)
        
        addChild(player)
    }
    func add_Obs(){
        let choice = Int(arc4random_uniform(2))
        switch choice{
        case 0:
            add_Circle()
        case 1:
            addSquare()
        default:
            print("Something went wrong")
        }    }
    func add_Circle(){
        let path = UIBezierPath()
        path.move(to:CGPoint(x: 0, y: -200))
        path.addLine(to: CGPoint(x: 0, y: -160))
        path.addArc(withCenter: CGPoint.zero, radius: 160, startAngle: CGFloat(3.0 * Double.pi / 2), endAngle: CGFloat(0), clockwise: true)
        
        path.addLine(to: CGPoint(x: 200, y: 0))
        path.addArc(withCenter: CGPoint.zero, radius: 200, startAngle: CGFloat(0) , endAngle: CGFloat(3.0 * Double.pi / 2), clockwise: false)
        
        //        let section1 = SKShapeNode(path: path.cgPath)
        //        section1.position = CGPoint(x: size.width / 2,y: size.width / 2)
        //        section1.fillColor = .yellow
        //        section1.strokeColor = .yellow
        //        addChild(section1)
        //
        //        let section2 = SKShapeNode(path: path.cgPath)
        //        section2.position = CGPoint(x: size.width / 2,y: size.width / 2)
        //        section2.fillColor = .red
        //        section2.strokeColor = .red
        //        section2.zRotation = CGFloat(Double.pi / 2)
        //        addChild(section2)
        let obs = Duplicate_Obs(path: path, clockwise: true)
        obstacles.append(obs)
        obs.position = CGPoint(x: size.width / 2,y:obstacleSpacing * CGFloat(obstacles.count))
        addChild(obs)
        let rotation = SKAction.rotate(byAngle: 2.0 * CGFloat(Double.pi), duration: 8.0)
        obs.run(SKAction.repeatForever(rotation))
        
    }
    func addSquare(){
        let path = UIBezierPath(roundedRect: CGRect(x: -200,y: -200, width:400, height:20), cornerRadius: 40)
        let obstacle = Duplicate_Obs(path: path, clockwise: false)
        obstacles.append(obstacle)
        obstacle.position = CGPoint(x: size.width / 2,y:obstacleSpacing * CGFloat(obstacles.count))
        addChild(obstacle)
        
        let rotation = SKAction.rotate(byAngle: -2.0 * CGFloat(Double.pi), duration: 7.0)
        obstacle.run(SKAction.repeatForever(rotation))

    }
    
    func Duplicate_Obs(path: UIBezierPath, clockwise: Bool) -> SKNode{
        let container = SKNode()
        var rotationFactor = CGFloat(Double.pi / 2)
        if !clockwise {
            rotationFactor *= -1
        }
        for i in 0 ... 3{
            let section = SKShapeNode(path: path.cgPath)
            section.fillColor = colors[i]
            section.strokeColor = colors[i]
            section.zRotation = rotationFactor * CGFloat(i)
            //collision detection
            
            let sec_body = SKPhysicsBody(polygonFrom: path.cgPath)
            sec_body.categoryBitMask = PhysicsCategory.Obs
            sec_body.collisionBitMask = 0
            sec_body.contactTestBitMask = PhysicsCategory.Player
            sec_body.affectedByGravity = false
            section.physicsBody = sec_body
            
            container.addChild(section)
        }
        return container
    }
    func pass_data(){
    let v = ScoreViewController()
        v.high_score = highscore
        v.score_pass = score
    }
   
    func die_restart(){
        
        print("boom")
//        let v = ScoreViewController(nibName: "VC", bundle: nil)
//        v.high_score = (UserDefaults().integer(forKey: "HIGHSCORE"))
//        v.score_pass = score
////        var currentViewController:UIViewController=UIApplication.shared.keyWindow!.rootViewController!
////
////        currentViewController.present(vc, animated: true, completion: nil)
//   self.view?.window?.rootViewController?.present(vc, animated: true, completion: nil)
//        let v = ScoreViewController(nibName: "VC", bundle: nil)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "VC") as! ScoreViewController
     

//
                 vc.high_score = (UserDefaults().integer(forKey: "HIGHSCORE"))
                 vc.score_pass = score
        
//        delegate_vc?.highscore(data: (UserDefaults().integer(forKey: "HIGHSCORE")))
//        delegate_vc?.score(data: score)
        
        UIView.transition(with: self.view!, duration: 0.3, options: .transitionFlipFromRight, animations:
            {
                self.view?.window?.rootViewController = vc
        }, completion: { completed in
            
        })
        
        player.physicsBody?.velocity.dy = 0
        player.removeFromParent()
        for node in obstacles{
            node.removeFromParent()
        }
        obstacles.removeAll()
        setPlayer()
        cameraNode.position = CGPoint(x:size.width / 2, y: size.height / 2)
        
        score = 0
        scorelbl.text = String(score)
        
    }
    
    func touchDown(atPoint pos : CGPoint) {
        
    }
    
    func touchMoved(toPoint pos : CGPoint) {
       
    }
    
    func touchUp(atPoint pos : CGPoint) {
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    player.physicsBody?.velocity.dy = 600.0
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    func saveHighScore() {
        UserDefaults.standard.set(score, forKey: "HIGHSCORE")
         print("score\(score)")
    }
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        if player.position.y > obstacleSpacing * CGFloat(obstacles.count - 2){
            score += 1
            scorelbl.text = String(score)
            add_Obs()
        }
        let playerposcam = cameraNode.convert(player.position, to: self)
        if playerposcam.y > 0 && !cameraNode.hasActions(){
            cameraNode.position.y = player.position.y
        }
        if playerposcam.y < -size.height / 2{
            die_restart()
        }
    }
}
extension GameScene: SKPhysicsContactDelegate{
    func didBegin(_ contact: SKPhysicsContact) {
        if let node_A = contact.bodyA.node as? SKShapeNode, let node_B = contact.bodyB.node as? SKShapeNode{
            if node_A.fillColor != node_B.fillColor{
                print("highscore\(UserDefaults().integer(forKey: "HIGHSCORE"))")
                if score > UserDefaults().integer(forKey: "HIGHSCORE") {
                    saveHighScore()
                   
                }
               
                
                die_restart()
            }
        }
    }
}
