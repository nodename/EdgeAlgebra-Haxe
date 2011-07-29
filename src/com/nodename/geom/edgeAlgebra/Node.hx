package com.nodename.geom.edgeAlgebra;

/**
 * ...
 * @author Alan Shaw
 */


 // This class represents either a vertex or a face of the graph
 class Node
 {
	 // node roles:
	 public static inline var RIGHT_FACE:Int = 0;
	 public static inline var DEST_VERTEX:Int = 1;
	 public static inline var LEFT_FACE:Int = 2;
	 public static inline var ORIGIN_VERTEX:Int = 3;
	 
	 private var _uniqueNode:{};
	 
	 private var _r:Int;
	 private var _f:Int;
	 
	 public inline function dispose():Void
	 {
		 _uniqueNode = null;
	 }
	 
	 private static var NEXT_INDEX:Int = 0;
	 public var index:Int;
	 public function new(r:Int, f:Int, cloneOf:Node=null)
	 {
		 index = NEXT_INDEX++;
		 _uniqueNode = cloneOf != null ? cloneOf._uniqueNode : {};
		 
		 _r = r;
		 _f = f;
	 }
	 
	 public inline function equals(other:Node):Bool
	 {
		 return other._uniqueNode == this._uniqueNode;
	 }
	 
	 public inline function toString():String
	 {
		 return "[Node " + index + ": r " + _r + " f " + _f + "]";
	 }
	 
	 // TODO revisit this. It passes all current tests but it's not done
	 public inline function dual(edge:QuadEdge):Node
	 {
		 var result:Node = null;
		 var dual:QuadEdge = edge.getDual();
		 var myRelationshipToEdge:Int = (_r - edge.r + 4) % 4;
		 switch (myRelationshipToEdge)
		 {
			 case RIGHT_FACE:
				 result = _f == 0 ? dual.getDestVertex() : dual.getOriginVertex();
				 //result = dual.destVertex;
			 case DEST_VERTEX:
				 result = dual.getRightFace();
			 case LEFT_FACE:
				 result = _f == 0 ? dual.getOriginVertex() : dual.getDestVertex();
				 //result = dual.originVertex;
			 case ORIGIN_VERTEX:
				 result = dual.getLeftFace();
		 }
		 
		 return result;
	 }
 }
