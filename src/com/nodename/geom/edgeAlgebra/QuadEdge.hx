package com.nodename.geom.edgeAlgebra;

/**
 * ...
 * @author Alan Shaw
 */

	class QuadEdge
	{
		public static inline function makeEdge():QuadEdge
		{
			var edgeRecord:EdgeRecord = new EdgeRecord();
			var subdivision:Subdivision = new Subdivision()
									.addEdgeRecord(edgeRecord);
			
			return edgeRecord.getE0();
		}
		
		public static inline function splice(a:QuadEdge, b:QuadEdge):Void
		{
			var aNext:QuadEdge = a.oNext();
			var bNext:QuadEdge = b.oNext();
			var alpha:QuadEdge = aNext.rot();
			var beta:QuadEdge = bNext.rot();
			var alphaNext:QuadEdge = alpha.oNext();
			var betaNext:QuadEdge = beta.oNext();
			
			a.oNextRef = bNext;
			b.oNextRef = aNext;
			alpha.oNextRef = betaNext;
			beta.oNextRef = alphaNext;
		}
		
		private var _edgeRecord:EdgeRecord;
		public inline function quadEdge(rotation:Int, orientation:Int):QuadEdge 
		{
			return _edgeRecord.quadEdge(rotation, orientation);
		}
		
		// A var that is read-only outside of this class:
		// haXe:
		public var r(default, null):Int;
		// AS3:
		/*private var _r:Int;
		public function get r():Int 
		{
			return _r;
		}*/
		
		public var orientation(default, null):Int;
		
		public inline function dispose():Void
		{
			_edgeRecord = null;
		}

		// direction: originVertex and destVertex
		//public var originVertex(getOriginVertex, never):Node;
		@:getter(originVertex)
		public function get_OriginVertex():Node
		{
			return getOriginVertex();
		}
		
		public function getOriginVertex():Node
		{
			return _edgeRecord.ring(r + 3, orientation);
		}
		
		//public var destVertex(getDestVertex, never):Node;
		@:getter(destVertex)
		public function get_DestVertex():Node
		{
			return getDestVertex();
		}
		
		public inline function getDestVertex():Node
		{
			return _edgeRecord.ring(r + 1, orientation);
		}
		
		// orientation: leftFace and rightFace
		//public var leftFace(getLeftFace, never):Node;
		@:getter(leftFace)
		public function get_LeftFace():Node
		{
			return getLeftFace();
		}
		
		public inline function getLeftFace():Node
		{
			return _edgeRecord.ring(r + 2 + 2 * orientation, orientation);
		}
		
		//public var rightFace(getRightFace, never):Node;
		@:getter(rightFace)
		public function get_RightFace():Node
		{
			return getRightFace();
		}
		
		public inline function getRightFace():Node
		{
			return _edgeRecord.ring(r + 2 * orientation, orientation);
		}
		
		//protected static inline var LOCK:Object = {};
		
		private static var NEXT_INDEX:Int = 0;
		public var index:Int;
		public function new(edgeRecord:EdgeRecord, r:Int, f:Int/*, lock:Object*/)
		{
			/*if (lock != LOCK)
			{
				throw new Error("invalid constructor access");
			}*/
			
			index = NEXT_INDEX++;
			_edgeRecord = edgeRecord;
			this.r = r;
			orientation = f;
			
			oNextRef = null;
		}

		
		public inline function rot(exponent:Int=1):QuadEdge
		{
			return _edgeRecord.quadEdge(r + (1 + 2 * orientation) * exponent, orientation);
		}
		
		public inline function sym(exponent:Int=1):QuadEdge
		{
			// return the symmetric QuadEdge: the one with same orientation and opposite direction
			return _edgeRecord.quadEdge(r + 2 * exponent, orientation);
		}
		
		public inline function flip(exponent:Int=1):QuadEdge
		{
			// return the QuadEdge with same direction and opposite orientation
			return _edgeRecord.quadEdge(r, orientation + exponent);
		}
		
		public var oNextRef:QuadEdge;
		
		public function oNext(exponent:Int=1):QuadEdge
		{
			if (exponent < 0)
			{
				return oPrev(-exponent);
			}
			
			var edge:QuadEdge = this;
			while (exponent-- > 0)
			{
				// find the QuadEdge immediately following this one counterclockwise in the ring of edges out of originVertex
				edge = edge.oNextRef;
			}
			return edge;
		}
		
		public function dNext(exponent:Int=1):QuadEdge
		{
			if (exponent < 0)
			{
				return dPrev(-exponent);
			}
			
			var edge:QuadEdge = this;
			while (exponent-- > 0)
			{
				// find the QuadEdge immediately following this one counterclockwise in the ring of edges into destVertex
				edge = edge.sym().oNext().sym();
			}
			return edge;
		}
		
		public function lNext(exponent:Int=1):QuadEdge
		{
			if (exponent < 0)
			{
				return lPrev(-exponent);
			}
			
			var edge:QuadEdge = this;
			while (exponent-- > 0)
			{
				// find the next counterclockwise QuadEdge with the same left face
				edge = edge.rot(-1).oNext().rot();
			}
			return edge;
		}
		
		public function rNext(exponent:Int=1):QuadEdge
		{
			if (exponent < 0)
			{
				return rPrev(-exponent);
			}
			
			var edge:QuadEdge = this;
			while (exponent-- > 0)
			{
				// find the next clockwise QuadEdge with the same right face
				edge = edge.rot().oNext().rot(-1);
			}
			return edge;
		}
		
		
		public function oPrev(exponent:Int=1):QuadEdge
		{
			if (exponent < 0)
			{
				return oNext(-exponent);
			}
			
			var edge:QuadEdge = this;
			while (exponent-- > 0)
			{
				// find the QuadEdge immediately following this one clockwise in the ring of edges out of originVertex
				edge = edge.rot().oNext().rot();
			}
			return edge;
		}
		
		public function dPrev(exponent:Int=1):QuadEdge
		{
			if (exponent < 0)
			{
				return dNext(-exponent);
			}
			
			var edge:QuadEdge = this;
			while (exponent-- > 0)
			{
				// find the QuadEdge immediately following this one clockwise in the ring of edges into destVertex
				edge = edge.rot(-1).oNext().rot(-1);
			}
			return edge;
		}
		
		public function lPrev(exponent:Int=1):QuadEdge
		{
			if (exponent < 0)
			{
				return lNext(-exponent);
			}
			
			var edge:QuadEdge = this;
			while (exponent-- > 0)
			{
				// find the next clockwise QuadEdge with the same left face
				edge = edge.oNext().sym();
			}
			return edge;
		}
		
		public function rPrev(exponent:Int=1):QuadEdge
		{
			if (exponent < 0)
			{
				return rNext(-exponent);
			}
			
			var edge:QuadEdge = this;
			while (exponent-- > 0)
			{
				// find the next clockwise QuadEdge with the same right face
				edge = edge.sym().oNext();
			}
			return edge;
		}
		
		//public var dual(getDual, never):QuadEdge;
		@:getter(dual)
		public function get_Dual():QuadEdge
		{
			return getDual();
		}
		
		public inline function getDual():QuadEdge
		{
			return flip().rot();
		}
		
		public inline function toString():String
		{
			return "[QuadEdge " + index + "(r " + r + " f " + orientation + "): origin: " + getOriginVertex() + ", dest: " + getDestVertex() + ", left: " + getLeftFace() + ", right: " + getRightFace() + "]";
		}
		
	}
	
	
	// A subdivision of a manifold M is a partition S of M into three finite collections of disjoint parts:
	// the vertices, the edges, and the faces
	class Subdivision
	{
		private var _edgeRecords:Array<EdgeRecord>;
		
		public inline function dispose():Void
		{
			_edgeRecords = null;
		}
		
		public function new()
		{
			_edgeRecords = new Array<EdgeRecord>();
		}
		
		public inline function addEdgeRecord(edgeRecord:EdgeRecord):Subdivision
		{
			_edgeRecords.push(edgeRecord);
			return this;
		}
		
		public inline function isDualOf(other:Subdivision):Bool
		{
			// return (for every edge e in this, e.dual is in other, and vice versa);
			return true;
		}
	}
	
	
	// The EdgeRecord represents eight QuadEdges: the four oriented and directed versions of an undirected edge and of its dual
	private class EdgeRecord
	{
		private var _edges:Array<Array<QuadEdge>>;
		private var _nodes:Array<Array<Node>>;

		
		public inline function ring(rotation:Int, f:Int):Node
		{
			return _nodes[(rotation + 4) % 4][(f + 2) % 2];
		}
		
		
		/*public function edgeONext(edge:QuadEdge, exponent:Int):QuadEdge
		{
			for (var i:Int = 0; i < exponent; i++)
			{
				var rotation:Int = edge.r;
				var f:Int = edge.orientation;
				edge = _nextEdges[(rotation + f) % 4].rot(f).flip(f);
			}
			return edge;
		}*/
		
		public inline function quadEdge(rotation:Int, f:Int):QuadEdge
		{
			return _edges[(rotation + 4) % 4][(f + 2) % 2];
		}
			
		//public var e0(getE0, never):QuadEdge;
		@:getter(e0)
		public function get_E0():QuadEdge
		{
			return getE0();
		}
		
		public inline function getE0():QuadEdge
		{
			return quadEdge(0, 0);
		}
		
		public inline function dispose():Void
		{
			_edges = null;
			_nodes = null;
		}
		
		public function new()
		{
			construct();
		}
		
		private inline function construct():Void
		{		
			_nodes = new Array<Array<Node>>();

			for (i in 0...4)
			{
				_nodes[i] = [
					new Node(i, 0, i == 2 ? ring(0, 0) : null),
					new Node(i, 1, i == 2 ? ring(0, 1) : null)
				];
			}
			
			_edges = new Array<Array<QuadEdge>>();
			
			for (index in 0...4)
			{
				_edges[index] = [
					new QuadEdge(this, index, 0),
					new QuadEdge(this, index, 1)
				];
			}
				
			for (orientation in 0...2)
			{
				quadEdge(0, orientation).oNextRef = quadEdge(0, orientation);
				quadEdge(1, orientation).oNextRef = quadEdge(3, orientation);
				quadEdge(2, orientation).oNextRef = quadEdge(2, orientation);
				quadEdge(3, orientation).oNextRef = quadEdge(1, orientation);
			}
		}
		
		public inline function toString():String
		{
			return "{EdgeRecord:" +
				"\n" + _edges[0][0] +
				"\n" + _edges[0][1] +
				"\n" + _edges[1][0] +
				"\n" + _edges[1][1] +
				"\n" + _edges[2][0] +
				"\n" + _edges[2][1] +
				"\n" + _edges[3][0] +
				"\n" + _edges[3][1] +
			"\n}";
		}
		
	}