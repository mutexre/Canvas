//
//  Canvas+Touch.swift
//  Canvas
//
//  Created by Adeola Uthman on 1/10/18.
//

import Foundation

public extension Canvas {
    
    /************************
     *                      *
     *       FUNCTIONS      *
     *                      *
     ************************/
    
    /** Cleans up the line when you finish drawing a line. */
    private func finishDrawingNode() {
        guard let currLayer = currentLayer else { return }
        guard var node = nextNode else { return }
        node.lastPoint = currentPoint
        
        // Finish with a certain tool.
        switch currentDrawingTool {
        case .pen:
            break
        case .line:
            node.mutablePath.move(to: node.firstPoint)
            node.mutablePath.addLine(to: node.lastPoint)
            break
        case .rectangle:
            let w = node.lastPoint.x - node.firstPoint.x
            let h = node.lastPoint.y - node.firstPoint.y
            let rect = CGRect(x: node.firstPoint.x, y: node.firstPoint.y, width: w, height: h)
            node.mutablePath.move(to: node.firstPoint)
            node.mutablePath.addRect(rect)
            break
        case .ellipse:
            let w = node.lastPoint.x - node.firstPoint.x
            let h = node.lastPoint.y - node.firstPoint.y
            let rect = CGRect(x: node.firstPoint.x, y: node.firstPoint.y, width: w, height: h)
            node.mutablePath.move(to: node.firstPoint)
            node.mutablePath.addEllipse(in: rect)
            break
        default:
            break
        }
        
        // Update the drawing.
        currLayer.makeNewShapeLayer(node: node)
        
        // Undo/redo
//        let cL = self.currentCanvasLayer
//
//        undoRedoManager.add(undo: {
//            var la = self.layers[cL].nodeArray ?? []
//            if la.count > 0 { la.removeLast() }
//            return (la, cL)
//        }) {
//            var la = self.layers[cL].nodeArray
//            la?.append(node)
//            return (la, cL)
//        }
//        undoRedoManager.clearRedos()

        self.delegate?.didEndDrawing(on: self, withTool: currentDrawingTool)
        nextNode = nil
    }
    
    
    
    
    
    
    
    /************************
     *                      *
     *        TOUCHES       *
     *                      *
     ************************/
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        guard let currLayer = currentLayer else { return }
        
        // Don't continue if the layer does not allow drawing or should be preempted.
        if currLayer.allowsDrawing == false || preemptTouch == true { return }
        
        // Don't continue if there is more than one touch.
        if let evT = event?.touches(for: self) {
            if evT.count > 1 { return }
        }
        
        // Get the first touch point.
        lastPoint = touch.previousLocation(in: self)
        currentPoint = touch.location(in: self)
        
        // Init (or reinit) the bezier curve. Makes sure the current tool always draws something.
        nextNode = Node()
        
        // Work with each tool.
        switch currentDrawingTool {
        case .pen, .eraser, .line, .rectangle, .ellipse:
            currLayer.makeNewShapeLayer(node: nextNode!)
            nextNode?.setInitialPoint(point: currentPoint)
            delegate?.didBeginDrawing(on: self, withTool: currentDrawingTool)
        case .selection:
            break
        case .eyedropper, .paint:
            break
        default:
            break
        }
    }
    
    
    
    
    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        guard let currLayer = currentLayer else { return }
        guard var next = nextNode else { return }
        
        // Don't continue if the layer does not allow drawing or should be preempted.
        if currLayer.allowsDrawing == false || preemptTouch == true  { return }
        
        // Don't continue if there is more than one touch.
        if let evT = event?.touches(for: self) {
            if evT.count > 1 { return }
        }
        
        // Collect touches.
        lastLastPoint = lastPoint
        lastPoint = touch.previousLocation(in: self)
        currentPoint = touch.location(in: self)
        
        // Calculate the translation of the touch.
        touch.deltaX = currentPoint.x - lastPoint.x
        touch.deltaY = currentPoint.y - lastPoint.y
        
        // Draw based on the current tool.
        switch currentDrawingTool {
        case .selection:
            break
        case .eyedropper, .paint:
            return
        case .pen, .eraser:
            var boundingBox = next.addPath(p1: lastLastPoint, p2: lastPoint, currentPoint: currentPoint, tool: currentDrawingTool)
            boundingBox.origin.x -= currentBrush.thickness * 2.0;
            boundingBox.origin.y -= currentBrush.thickness * 2.0;
            boundingBox.size.width += currentBrush.thickness * 4.0;
            boundingBox.size.height += currentBrush.thickness * 4.0;
            
            next.move(from: lastPoint, to: currentPoint, tool: currentDrawingTool)
            setNeedsDisplay(boundingBox)
            break
        case .line:
            next.move(from: lastPoint, to: currentPoint, tool: currentDrawingTool)
            setNeedsDisplay()
            break
        case .rectangle:
            next.move(from: lastPoint, to: currentPoint, tool: currentDrawingTool)
            next.setBoundingBox()
            setNeedsDisplay()
            break
        case .ellipse:
            next.move(from: lastPoint, to: currentPoint, tool: currentDrawingTool)
            next.setBoundingBox()
            setNeedsDisplay()
            break
        default:
            break
        }
        
        self.delegate?.isDrawing(on: self, withTool: currentDrawingTool)
    }
    
    
    
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let currLayer = currentLayer else { return }
        
        // Don't continue if the layer does not allow drawing or should be preempted.
        if currLayer.allowsDrawing == false || preemptTouch == true  { return }
        
        // Don't continue if there is more than one touch.
        if let evT = event?.touches(for: self) {
            if evT.count > 1 { return }
        }
        
        // Selection tool vs other tools
        switch currentDrawingTool {
        case .selection:
            break
        case .eyedropper:
            handleEyedrop(point: currentPoint)
            break
        case .paint:
            break
        default:
            touchesMoved(touches, with: event)
            self.finishDrawingNode()
            break
        }
    }
    
    
    
    public override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let currLayer = currentLayer else { return }
        
        // Don't continue if the layer does not allow drawing or should be preempted.
        if currLayer.allowsDrawing == false || preemptTouch == true  { return }
        
        // Don't continue if there is more than one touch.
        if let evT = event?.touches(for: self) {
            if evT.count > 1 { return }
        }
        
        // Make sure the point is recorded.
        touchesEnded(touches, with: event)
    }
    
}



