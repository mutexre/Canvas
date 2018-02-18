//
//  DrawingTool.swift
//  Canvas
//
//  Created by Adeola Uthman on 2/9/18.
//

import Foundation

/** A Node on the canvas. A node is basically just any curve, line, or shape that appears on the canvas
 and is selectable. */
public class Node: UIBezierPath {
    
    /************************
     *                      *
     *       VARIABLES      *
     *                      *
     ************************/
    
    /** The drawing path of the tool. */
    var path: CGMutablePath
    
    /** The brush that the tool should use to draw. */
    var brush: Brush
    
    /** The first point of the node. */
    var firstPoint: CGPoint
    
    /** The last point of the node. */
    var lastPoint: CGPoint
    
    /** The id used to identify different nodes on the canvas. */
    var id: Int
    
    
    
    
    
    /************************
     *                      *
     *         INIT         *
     *                      *
     ************************/
    
    public required init?(coder aDecoder: NSCoder) {
        path = CGMutablePath()
        brush = Brush.Default
        firstPoint = CGPoint()
        lastPoint = CGPoint()
        id = 0
        super.init(coder: aDecoder)
        lineCapStyle = .round
    }
    
    override init() {
        path = CGMutablePath()
        brush = Brush.Default
        firstPoint = CGPoint()
        lastPoint = CGPoint()
        id = 0
        super.init()
        lineCapStyle = .round
    }
    
    
    
    
    
    
    /************************
     *                      *
     *       FUNCTIONS      *
     *                      *
     ************************/
    
    func setInitialPoint(point: CGPoint) {}
    
    func move(from: CGPoint, to: CGPoint) {}
    
    func addPathLastLastPoint(p1: CGPoint, p2: CGPoint, currentPoint: CGPoint) -> CGRect { return CGRect() }
    
    func draw() {}
    
}


/** The type of tool that is being used to draw. */
public enum CanvasTool {
    case pen
    case eraser
    case line
    case rectangle
    case rectangleFill
    case ellipse
    case ellipseFill
}



