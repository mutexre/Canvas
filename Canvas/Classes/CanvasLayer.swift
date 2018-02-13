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
    
    /** The next node to be drawn on the screen, whether that be a curve, a line, or a shape. */
    internal var nextNode: Node?
    
    /** The image that the user is drawing on. */
    internal var drawImage: UIImage!
    
    /** All of the nodes on this layer. */
    internal var nodeArray: NSMutableArray!
    
    
    // -- PUBLIC VARS --
    
    /** Whether or not this layer is visible. True by default. */
    public var isVisible: Bool
    
    /** Whether or not this layer allows drawing. True by default. */
    public var allowsDrawing: Bool
    
    
    
    // -- PUBLIC COMPUTED VARS --
    
    /** Returns the number of nodes on this layer. */
    public var nodeCount: Int { return self.nodeArray.count }
    
    
    
    
    
    
    
    /************************
     *                      *
     *         INIT         *
     *                      *
     ************************/
    
    public init() {
        nextNode = nil
        drawImage = UIImage()
        nodeArray = NSMutableArray()
        isVisible = true
        allowsDrawing = true
    }
    
    
    
    
    
    /************************
     *                      *
     *       FUNCTIONS      *
     *                      *
     ************************/
    
    
    
    
    
    /************************
     *                      *
     *        DRAWING       *
     *                      *
     ************************/
    
    public func draw() {
        if self.isVisible == true {
            self.drawImage.draw(at: CGPoint.zero)
            self.nextNode?.draw()
        }
    }
    
    
}