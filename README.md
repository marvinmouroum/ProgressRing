# ProgressRing
An IOS swift framework which lets you combine a UIButton with an animatable progress ring

![ezgif com-video-to-gif](https://user-images.githubusercontent.com/28195629/32409789-ecd47412-c1b2-11e7-84a8-81e9acdc9e19.gif)

Example Implementation:

        //defining a frame for the ring
        let rect = CGRect(x:75,y:75,width:200,height:200)
        
        // initialize the ring
        let ring = ProgressRing(frame: rect, width: 25, startPercent: 0, endPercent: 100, colorStyle: .blue)
        
        //moving the ring
        ring.frame.origin = CGPoint(x:UIScreen.main.bounds.width/2 - 100, y: UIScreen.main.bounds.height/2-100)
        
        //adding the push button
        ring.enableButton(enable: true, lineColor: nil, selector: #selector(ViewController.hello))
        
        //changing value of the progress
        ring.setToValue(endPercent: 80)
        
        //changing color
        ring.setColor(style: .blue)
        //ring.setColor(style: .gray)
        //ring.setColor(style: .red)
        
        //changing line ending
        ring.lineStyle = .round
        
        
        //changing gradient
        ring.gradient = true
        
        //changing animation time interval
        ring.animationTime = 2
        
        view.addSubview(ring)
