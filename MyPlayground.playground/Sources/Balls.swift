import Foundation
import UIKit
import PlaygroundSupport

public class Balls: UIView{
    private var color: [UIColor]
    private var balls: [UIView] = []
    private var ballSize: CGSize = CGSize(width: 40, height: 40)
    private var animator: UIDynamicAnimator?
    private var snapBehavior: UISnapBehavior?
    private var collisionBehavior: UICollisionBehavior
    
   public init(color: [UIColor] ){
        self.color = color
       collisionBehavior = UICollisionBehavior(items: [])
       /* указание на то, что границы отображения
       также являются объектами взаимодействия */
//       collisionBehavior.setTranslatesReferenceBoundsIntoBoundary(with: UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1))
        super.init(frame: CGRect(x: 0, y: 0, width: 400, height: 400))
        backgroundColor = UIColor.gray
        ballsView()
        animator = UIDynamicAnimator(referenceView: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func ballsView(){
        for (index, color) in color.enumerated(){
            let ball = UIView(frame: CGRect.zero)
            /* указываем цвет шарика
            он соответствует переданному цвету */
            ball.backgroundColor = color
            addSubview(ball)
            balls.append(ball)
            let origin = 40*index + 1
            ball.frame = CGRect(x: origin, y: origin, width: Int(ballSize.width), height: Int(ballSize.height))
            ball.layer.cornerRadius = ball.bounds.width / 2.0
            collisionBehavior.addItem(ball)
        }
    }
    
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first{
            let touchLocation = touch.location(in: self)
            for ball in balls {
                if (ball.frame.contains(touchLocation)){
                    snapBehavior = UISnapBehavior(item: ball, snapTo: touchLocation)
                    snapBehavior?.damping = 0.5
                    animator?.addBehavior(snapBehavior!)
                }
            }
        }
    }
    
    override public func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first{
            let touchLocation = touch.location(in: self)
            if let snapBehavior = snapBehavior{
                snapBehavior.snapPoint = touchLocation
            }
        }
    }
    
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let snapBehavior = snapBehavior{
            animator?.removeBehavior(snapBehavior)
        }
        snapBehavior = nil
    }
}


