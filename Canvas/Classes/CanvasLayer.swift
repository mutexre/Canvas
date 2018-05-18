//
//  CanvasLayer.swift
//  Canvas
//
//  Created by Adeola Uthman on 2/10/18.
//

import Foundation

/** A single layer that can be drawn on. The Canvas can have multiple layers which can be rearranged to have different drawings appear on top of or below others. */
public class CanvasLayer {
    
    /************************
     *                      *
     *       VARIABLES      *
     *                      *
     ************************/
    
    // -- PRIVATE VARS --
    
    /** The canvas that this layer is on. */
    internal var canvas: Canvas!
    
    /** All of the nodes on this layer. */
    var drawingArray: [CAShapeLayer]!
    
    
    // -- PUBLIC VARS --
    
    /** Whether or not this layer is visible. True by default. */
    public var isVisible: Bool
    
    /** Whether or not this layer allows drawing. True by default. */
    public var allowsDrawing: Bool
    
    /** The opacity of everything on this layer. */
    public var opacity: CGFloat
    
    /** A name for this layer (optional). */
    public var name: String?
    
    
    
    
    
    
    
    
    
    /************************
     *                      *
     *         INIT         *
     *                      *
     ************************/
    
    public init(canvas: Canvas) {
        drawingArray = []
        isVisible = true
        allowsDrawing = true
        name = nil
        self.canvas = canvas
        opacity = 1
    }
    
    
    
    
    /************************
     *                      *
     *       FUNCTIONS      *
     *                      *
     ************************/

    
    /** Clears the drawing on this layer. */
    public func clear() {
        drawingArray = []
        canvas.setNeedsDisplay()
    }
    
    
    
    
    
    
    /************************
     *                      *
     *        DRAWING       *
     *                      *
     ************************/
    
    /** Makes a new shape layer that can be rendered on screen. */
    func makeNewShapeLayer(node: Node) {
        let sl = CAShapeLayer()
        sl.path = node.mutablePath
        sl.strokeColor = canvas.currentBrush.color.cgColor
        sl.fillColor = nil
        sl.fillRule = kCAFillRuleEvenOdd
        sl.lineWidth = canvas.currentBrush.thickness
        sl.lineCap = kCALineCapRound
        sl.lineJoin = kCALineJoinRound
        sl.miterLimit = canvas.currentBrush.miter
        drawingArray.append(sl)
    
        canvas.setNeedsDisplay()
    }

    
    
    
    
    /************************
     *                      *
     *        TOUCHES       *
     *                      *
     ************************/
    
//    /** Handles a touch on this layer when it comes to selecting nodes. */
//    func onTouch(touch: UITouch) {
//        guard let selNode = selectNode else { return }
//        let loc = touch.location(in: canvas)
//        if !selNode.contains(point: loc) {
//            selectNode = nil
//            return
//        }
//    }
//    
//    /** Handles movement events on a node. */
//    func onMove(touch: UITouch) {
//        guard let selNode = selectNode else { return }
//        
//        selNode.moveNode(touch: touch, canvas: canvas)
//        
//        self.updateLayer(redraw: true)
//        canvas.setNeedsDisplay()
//        
//        canvas.delegate?.didMoveNode(on: canvas, movedNode: selNode)
//    }
//    
//    /** Handles when a touch is released. */
//    func onRelease(point: CGPoint) {
//        let loc = point
//        
//        // If you are not currently selecting a node, select one.
//        if selectNode == nil {
//            for node in nodeArray {
//                if node.allowsSelection == false { continue }
//                if node is EraserNode { continue }
//                if node.contains(point: loc) {
//                    selectNode = node
//                    canvas.delegate?.didSelectNode(on: canvas, selectedNode: node)
//                    break
//                }
//            }
//        }
//        // If you have a node selected and no node is pressed, unselect.
//        else {
//            for node in nodeArray {
//                if node.allowsSelection == false { continue }
//                if node is EraserNode { continue }
//                if node.contains(point: loc) {
//                    selectNode = node
//                    return
//                }
//            }
//            selectNode = nil
//        }
//    }
    
    
    
    

    
    
    /************************
     *                      *
     *         OTHER        *
     *                      *
     ************************/
    
}
