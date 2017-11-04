//: Playground - noun: a place where people can play

import UIKit

public enum LineStyle:String {
    case round = "round"
    case flat = "butt"
}

struct ColorPair {
    var color1:UIColor
    var color2:UIColor
    var color3:UIColor
}

public enum ColorStyle {
    case gray
    case blue
    case red
}

public class ProgressRing : UIButton {
    
    //public
    public var buttonEnabled:Bool = false //have a simple ring or a button
    public var endPercent:CGFloat = 60 //ending point 0 - 100
    public var gradient:Bool = false // add a color gradient from three style gray, blue, red
    public var animationTime:CFTimeInterval = 2 //animation time which the users sets
    public var lineStyle:LineStyle = .round // round or butt
    public var buttonSelector:Selector = #selector(defaultSelector) // selector for button
    
    //private
    private var rad:CGFloat = 0 //radius of ring
    private var wid:CGFloat = 0 // width of line
    private var startPercent:CGFloat = 0 //startPoint 0 recommended
    private var lastHook:CGFloat = 30 //TODO when starting over the ring doesnt animate from the beginning
    private var atime:CFTimeInterval // time resulting
    private var colors = ColorPair(color1: #colorLiteral(red: 0.09803921569, green: 0.7215686275, blue: 0.7803921569, alpha: 1), color2: #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1), color3: #colorLiteral(red: 0.945176661, green: 0.6216586828, blue: 0.5113840699, alpha: 1)) // color options
    private var colorStyle:ColorStyle = .blue // default style
    
    // ******** draw and init *********
    override public func draw(_: CGRect) {
        setColor(style: colorStyle)
        drawSlice(rect: self.frame, width: wid, startPercent: startPercent, endPercent: endPercent, colorStyle: colorStyle)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        self.atime = 1
        super.init(coder: aDecoder)
        self.backgroundColor = UIColor.clear
        self.addTarget(self, action: buttonSelector, for: .touchUpInside)
    }
    
    override public init(frame: CGRect) {
        self.atime = 1
        super.init(frame: CGRect(x:frame.origin.x,y:frame.origin.y,width:frame.width,height:frame.height))
        self.backgroundColor = UIColor.clear
        setColor(style: colorStyle)
        drawSlice(rect: self.frame, width: min(self.frame.width,self.frame.height)*0.125, startPercent: 0, endPercent: endPercent, colorStyle: colorStyle)
        self.addTarget(self, action: buttonSelector, for: .touchUpInside)
    }
    
    public init(frame: CGRect, width:CGFloat, startPercent:CGFloat,endPercent:CGFloat,colorStyle:ColorStyle){
        self.atime = 1
        super.init(frame: frame)
        self.gradient = true
        self.backgroundColor = UIColor.clear
        setColor(style: colorStyle)
        drawSlice(rect: frame, width: width, startPercent: startPercent, endPercent: endPercent, colorStyle: colorStyle)
        self.addTarget(self, action: buttonSelector, for: .touchUpInside)
    }
    
    private func drawSlice(rect: CGRect,width: CGFloat, startPercent: CGFloat, endPercent: CGFloat, colorStyle: ColorStyle) {
        
        //********** important variables ************
        let center = CGPoint(x:self.frame.width/2, y:self.frame.height/2)
        let radius = min(rect.width, rect.height) / 2
        self.rad = radius
        self.wid = validateWidth(frame: self.frame, width: width)
        let startAngle = startPercent / 100 * CGFloat.pi * 2 - CGFloat.pi/2
        let endAngle = endPercent / 100 * CGFloat.pi * 2 - CGFloat.pi/2
        self.endPercent = endPercent
        self.startPercent = startPercent
        atime = CFTimeInterval(CGFloat(animationTime) * endPercent/100)
        
        // ***** cleaning and colors
        self.layer.sublayers?.removeAll()
        setColor(style: colorStyle)
        
        //********** path and animations ************
        let path = UIBezierPath()
        path.addArc(withCenter: center, radius: radius-width, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        path.lineWidth = width
        
        addAnimation(layer: makeShapeLayer(path: path, width: width))
        if gradient {
            selfmadeGrad(endAngle: endAngle, center: center)}
        
        if endPercent >= 85 && gradient {
            let path3 = UIBezierPath()
            path3.addArc(withCenter: center, radius: radius-width, startAngle: endAngle*0.9, endAngle: endAngle, clockwise: true)
            path3.lineWidth = width
            addAnimation(layer: makeShapeLayer(path: path3, width: width),begin: atime) }
        
        // ********** button *********
        if buttonEnabled {
            makeButton(radius: radius-1.5*width-2) }
        
    }
    
    // ******* layer and gradient ********
    func makeShapeLayer(path: UIBezierPath, width: CGFloat)->CAShapeLayer{
        let shapeLayer = CAShapeLayer()
        shapeLayer.fillColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0).cgColor
        shapeLayer.strokeColor = colors.color1.cgColor
        shapeLayer.lineWidth = width
        shapeLayer.path = path.cgPath
        shapeLayer.lineCap = lineStyle.rawValue
        
        return shapeLayer
    }
    
    func selfmadeGrad(endAngle: CGFloat, center: CGPoint){
        let inc:Int = 100
        for i in (0..<inc+1){
            var factor:CGFloat = CGFloat(i)/CGFloat(inc)
            if(factor*endAngle >=  endPercent / 100 * CGFloat.pi * 2 - CGFloat.pi/2){
                factor = 1
            }
            let pathz = UIBezierPath()
            
            pathz.addArc(withCenter: center, radius: rad-wid, startAngle: -CGFloat.pi/2, endAngle: factor*endAngle, clockwise: true)
            
            let shapeLayer2 = CAShapeLayer()
            shapeLayer2.fillColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0).cgColor
            shapeLayer2.strokeColor = colors.color2.withAlphaComponent((1-factor)/(CGFloat(inc)*0.2)).cgColor
            shapeLayer2.lineWidth = wid
            shapeLayer2.path = pathz.cgPath
            shapeLayer2.lineCap = lineStyle.rawValue
            let key = "Animation\(i)"
            addAnimation2(layer: shapeLayer2, key: key)
            
        }
    }
    
    func addAnimation(layer:CAShapeLayer){
        
        self.layer.addSublayer(layer)
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0
        animation.toValue = 1
        animation.duration = atime
        layer.add(animation, forKey: "MyAnimation")
    }
    
    func addAnimation(layer:CAShapeLayer, begin:Double){
        
        // animate it
        self.layer.addSublayer(layer)
        let animation = CABasicAnimation(keyPath: "opacity")
        animation.fromValue = 0
        animation.toValue = 0.1
        animation.duration = atime * 0.999
        animation.timeOffset =  0
        animation.timingFunction = CAMediaTimingFunction(controlPoints: 0.999, 0, 1, 0)
        layer.add(animation, forKey: "MyAnimationBegin")
    }
    
    func addAnimation2(layer:CAShapeLayer, key:String){
        
        self.layer.addSublayer(layer)
        let animation2 = CABasicAnimation(keyPath: "strokeEnd")
        animation2.fromValue = 0
        animation2.toValue = 1
        animation2.duration = atime
        layer.add(animation2,forKey: key)
    }
    
    func addAnimation2(layer:CAShapeLayer, key:String, keyPath: String){
        
        self.layer.addSublayer(layer)
        let animation2 = CABasicAnimation(keyPath: keyPath)
        animation2.fromValue = 0
        animation2.toValue = 0.5
        animation2.duration = atime
        layer.add(animation2,forKey: key)
    }
    
    
    func addRoundedEnd(path: UIBezierPath?, Radius: CGFloat, radius: CGFloat, center: CGPoint,start:CGFloat, angle: CGFloat)->UIBezierPath {
        
        let roundUp = UIBezierPath()
        let x = self.center.x + cos(angle)*(Radius-2*radius)
        let y = self.center.y + sin(angle)*(Radius-2*radius)
        let point = CGPoint(x:x,y:y)
        
        if path != nil {
            path!.move(to: point)
            path!.addArc(withCenter: center, radius: radius, startAngle: angle + CGFloat.pi, endAngle: angle, clockwise: false)
            UIColor.black.setStroke()
            path!.move(to: point)
        }
        else{
            roundUp.move(to: center)
            roundUp.addArc(withCenter: center, radius: radius, startAngle: angle + CGFloat.pi, endAngle: angle, clockwise: false)
            UIColor.black.setStroke()
            
            return roundUp
        }
        
        return UIBezierPath()
        
    }
    
    func drawStartLine(path:UIBezierPath,startAngle: CGFloat, radius: CGFloat, width: CGFloat, toPoint: CGPoint)
    {
        let x = self.center.x + cos(startAngle)*(radius-width)
        let y = self.center.y + sin(startAngle)*(radius-width)
        let endpoint = CGPoint(x:x,y:y)
        
        path.move(to: toPoint)
        path.addLine(to: endpoint)
    }
    
    func addGradient(path: UIBezierPath){
        
        let gradient = CAGradientLayer()
        gradient.frame = self.frame
        gradient.colors = [colors.color1.cgColor, #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).cgColor]
        gradient.borderColor = UIColor.clear.cgColor
        gradient.borderWidth = 0
        
        let shapeMask = CAShapeLayer()
        shapeMask.path = path.cgPath
        gradient.mask = shapeMask
        self.layer.addSublayer(gradient)
    }
    
    public func enableButton(enable:Bool, lineColor: UIColor?, selector: Selector?){
        self.buttonEnabled = enable
        if lineColor != nil {
            self.colors.color3 = lineColor!
        }
        if selector != nil {
            self.buttonSelector = selector!
            self.addTarget(Any?.self, action: buttonSelector, for: .touchUpInside)
        }
    }
    
    @objc func defaultSelector(){
        print("set a selector for your button")
        drawSlice(rect: self.frame, width: wid, startPercent: startPercent, endPercent: endPercent, colorStyle: colorStyle)
    }
    
    private func makeButton(radius:CGFloat){
        
        let center = CGPoint(x:self.frame.width/2, y:self.frame.height/2)
        let button = UIBezierPath()
        button.addArc(withCenter: center, radius: radius, startAngle: 0, endAngle: 2*CGFloat.pi, clockwise: true)
       
        colors.color3.setStroke()
        button.lineWidth = 5
        button.stroke()
         #colorLiteral(red: 0.9127413773, green: 0.9127413773, blue: 0.9127413773, alpha: 1).setFill()
        button.fill()
        
        let crossSize:CGFloat = self.frame.width*0.3
        let cross = UIBezierPath()
        let startPointHorizontal = center.x - crossSize/2
        let startPointVertical = center.y - crossSize/2
        
        cross.move(to: CGPoint(x:startPointHorizontal,y:center.y))
        cross.addLine(to: CGPoint(x:startPointHorizontal+crossSize,y:center.y))
        cross.move(to: CGPoint(x:center.x,y:startPointVertical))
        cross.addLine(to: CGPoint(x:center.x,y:startPointVertical+crossSize))
        cross.lineWidth = 4
        colors.color3.setStroke()
        cross.stroke()
        
    }
    
    public func setColor(style: ColorStyle){
        self.colorStyle = style
        switch style {
        case .gray:
            colors = ColorPair(color1: #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1), color2: #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1), color3: #colorLiteral(red: 0, green: 1, blue: 0.546833396, alpha: 1))
            break
        case .blue:
            colors = ColorPair(color1: #colorLiteral(red: 0.09803921569, green: 0.7215686275, blue: 0.7803921569, alpha: 1), color2: #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1), color3: #colorLiteral(red: 0.945176661, green: 0.6216586828, blue: 0.5113840699, alpha: 1))
            break
        case .red:
            colors = ColorPair(color1: #colorLiteral(red: 0.5725490451, green: 0, blue: 0.2313725501, alpha: 1), color2: #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1), color3: #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1))
            break
        }
    }
    
    public func setToValue(endPercent: CGFloat){
        self.endPercent = endPercent
        drawSlice(rect: self.frame, width: wid, startPercent: startPercent, endPercent: endPercent, colorStyle: colorStyle)
        self.lastHook = endPercent
    }
    
    private func validateWidth(frame: CGRect, width: CGFloat)->CGFloat{
        if min(frame.size.width,frame.size.height)*0.2 < width {
            print("width is too big - change size")
            return min(frame.size.width,frame.size.height)*0.2
        }
        
        return width
    }
}



