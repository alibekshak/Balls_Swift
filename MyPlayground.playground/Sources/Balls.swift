import Foundation
import UIKit
import PlaygroundSupport

public class Balls: UIView{
    private var color: [UIColor]
    private var balls: [UIView] = []
    private var ballSize: CGSize = CGSize(width: 40, height: 40)
    private var animator: UIDynamicAnimator? // используем для анимации
    private var snapBehavior: UISnapBehavior? // используем для взаимодействия пользователя с графическими элементами
    private var collisionBehavior: UICollisionBehavior // нужна для коллизии между обьектами
    
   public init(color: [UIColor] ){
        self.color = color
       collisionBehavior = UICollisionBehavior(items: [])
       /* указание на то, что границы отображения
       также являются объектами взаимодействия */
       collisionBehavior.setTranslatesReferenceBoundsIntoBoundary(with: UIEdgeInsets(top: 10, left: 5, bottom: 6, right: 4))
        super.init(frame: CGRect(x: 1, y: 1, width: 350, height: 350)) // встроенный инициализатор для определения границ обьекта
        backgroundColor = UIColor.gray
        ballsView()
        animator = UIDynamicAnimator(referenceView: self) // отображает анимацию в зависимости от расположения обьекта
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
            let origin = 50*index + 100 // указывается расположения шариков
            ball.frame = CGRect(x: origin, y: origin, width: Int(ballSize.width), height: Int(ballSize.height))
            ball.layer.cornerRadius = ball.bounds.width / 2.5
            collisionBehavior.addItem(ball)
        }
    }
    // так как метод touchesBegan уже определен в UISnapBehavior, для реализации собственного метода мы вызываем override для пререопределения метода
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first{
            let touchLocation = touch.location(in: self)
            for ball in balls {
                if (ball.frame.contains(touchLocation)){
                    snapBehavior = UISnapBehavior(item: ball, snapTo: touchLocation)
                    snapBehavior?.damping = 1 // damping - нужен для определения плавности движения шариков
                    animator?.addBehavior(snapBehavior!) // анимируем поведение обьекта
                }
            }
        }
    }
    
    override public func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first{
            let touchLocation = touch.location(in: self)
            if let snapBehavior = snapBehavior{
                snapBehavior.snapPoint = touchLocation // определяет текущее местоположение обьекта
            }
        }
    }
    
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let snapBehavior = snapBehavior{
            animator?.removeBehavior(snapBehavior)
        }
        snapBehavior = nil // перестоет обрабатывать расположение обьекта и snapBehavior становится nil
    }
}


