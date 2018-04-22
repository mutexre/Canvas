//
//  RectangleNode.swift
//  Canvas
//
//  Created by Adeola Uthman on 2/13/18.
//

import Foundation

/** A node that is used to draw rectangles on the screen. */
public class RectangleNode: Node {
    
    /************************
     *                      *
     *       VARIABLES      *
     *                      *
     ************************/
    
    var fillColor: UIColor?
    
    var innerRect: CGRect?
    
    override var boundingBox: CGRect {
        didSet {
            innerRect = boundingBox.insetBy(dx: brush.thickness, dy: brush.thickness)
        }
    }
    
    
    
    /************************
     *                      *
     *         INIT         *
     *                      *
     ************************/
    
    public required init?(coder aDecoder: NSCoder) {
        fillColor = aDecoder.decodeObject(forKey: "rectangle_node_fillColor") as? UIColor
        super.init(coder: aDecoder)
    }
    
    public override init() {
        super.init()
    }
    
    
    
    
    
    /************************
     *                      *
     *       FUNCTIONS      *
     *                      *
     ************************/
    
    override func setInitialPoint(point: CGPoint) {
        self.firstPoint = point
    }
    
    override func move(from: CGPoint, to: CGPoint) {
        self.lastPoint = to
    }
    
    override func contains(point: CGPoint) -> Bool {
        return boundingBox.contains(point)
    }
    
    func containsInner(point: CGPoint) -> Bool {
        guard let inner = innerRect else { return false }
        return inner.contains(point)
    }
    
    override func moveNode(touch: UITouch, canvas: Canvas) {
        boundingBox = boundingBox.offsetBy(dx: touch.deltaX, dy: touch.deltaY)
        innerRect = boundingBox.insetBy(dx: brush.thickness, dy: brush.thickness)
    }
    
    override func draw() {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        context.setLineCap(brush.shape)
        context.setLineJoin(brush.joinStyle)
        context.setLineWidth(brush.thickness)
        context.setMiterLimit(brush.miter)
        context.setFlatness(brush.flatness)
        context.setAlpha(brush.opacity)
        
        // Stoke the outline of the shape.
        context.setStrokeColor(brush.color.cgColor)
        context.stroke(boundingBox)
        
        // If the shape has a fill color, color in the fill inside of the border.
        if let fill = fillColor {
            context.setFillColor(fill.cgColor)
            context.fill(innerRect ?? boundingBox.insetBy(dx: brush.thickness, dy: brush.thickness))
        }
    }
    
    
    
    
    
    
    
    /************************
     *                      *
     *         OTHER        *
     *                      *
     ************************/
    
    public override func copy() -> Any {
        let n = RectangleNode()
        n.path = path
        n.fillColor = fillColor
        n.brush = brush.copy() as! Brush
        n.firstPoint = firstPoint
        n.lastPoint = lastPoint
        n.id = id
        n.points = points
        n.boundingBox = boundingBox
        return n
    }
    
    public override func mutableCopy() -> Any {
        let n = RectangleNode()
        n.path = path
        n.fillColor = fillColor
        n.brush = brush.copy() as! Brush
        n.firstPoint = firstPoint
        n.lastPoint = lastPoint
        n.id = id
        n.points = points
        n.boundingBox = boundingBox
        return n
    }
    
    public override func copy(with zone: NSZone? = nil) -> Any {
        let n = RectangleNode()
        n.path = path
        n.fillColor = fillColor
        n.brush = brush.copy() as! Brush
        n.firstPoint = firstPoint
        n.lastPoint = lastPoint
        n.id = id
        n.points = points
        n.boundingBox = boundingBox
        return n
    }
    
    public override func encode(with aCoder: NSCoder) {
        super.encode(with: aCoder)
        aCoder.encode(fillColor, forKey: "rectangle_node_fillColor")
    }
    
}
