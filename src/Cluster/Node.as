package Cluster 
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public class Node extends Ball_design
	{
		private var _connectedNodes:Vector.<Node>;
		private var _connectedNodesWithDistance:Vector.<NodeDistance>;
	
		public var Position:Point;
		private var _index:int;
		
		public function get Index():int{
			return _index;
		}
		
		public function set Index(value:int):void {
			_index = value;
			this.txtID.text = value.toString();
		}
		
		public function SetBorderColor(id:int) : void
		{
			var transform:ColorTransform = new ColorTransform();
			
			switch (id){
				case -1: transform.color = 0xFFFFFF; break;
				case 0: transform.color = 0x4F31D6; break;
				case 1: transform.color = 0x1E6C17; break;
				case 2: transform.color = 0x7C4C1C; break;
				case 3: transform.color = 0x8700BF; break;
				case 4: transform.color = 0xA8A8FE; break;
				case 5: transform.color = 0x81C97B; break;
				case 6: transform.color = 0xE6E0BC; break;
				case 7: transform.color = 0xA62226; break;
				case 8: transform.color = 0x50D0D0; break;
				case 9: transform.color = 0xF6F43E; break;
				case 10: transform.color = 0xF59539; break;
				case 11: transform.color = 0xFECAF3; break;
				case 12: transform.color = 0x575757; break;
				case 13: transform.color = 0xA0A0A0; break;
				default: transform.color = 0x000000; break;
			}
			
			this.BG.transform.colorTransform = transform;
		}
		
		public function Clone(): Node
		{
			var node:Node = new Node();
			node.Position = Position;
			node.Index = _index;
			
			return node;
		}
		
		public function Node() : void
		{
			Position = new Point(this.x, this.y);
			
			this.addEventListener(MouseEvent.CLICK, function(e:MouseEvent):void
			{
				trace(Index);
			});
		}
		
		public function AddConnectedNodes(nodes:Vector.<Node>):void
		{
			//_connectedNodes = nodes;
			//_connectedNodesWithDistance = new Vector.<NodeDistance>();
			//
			//for (var i:int = _connectedNodes.length - 1; i >= 0; i--)
			//{
				//var node:Node = _connectedNodes[i];
				//
				//if (node.Index != this.Index)
				//{
					//var nodeDistance = new NodeDistance(node, 0);
					//_connectedNodesWithDistance.push(nodeDistance);
				//}
			//}
		}
		
		public function CalculateDistance():void
		{
			//if (_connectedNodesWithDistance.length <= 0) return;
			//
			//var connectedCount:int = _connectedNodesWithDistance.length;
			////_connectedNodesDistance = new Vector.<Number>(connectedNodesCount);
			//
			//for (var i:int = connectedCount - 1; i >= 0; i--)
			//{
				//var node:Node = _connectedNodesWithDistance[i].NodeTarget;
				//
				//if (this != node) 
				//{
					//_connectedNodesWithDistance[i].Distance = Point.distance(Position, new Point(node.x, node.y));
				//}
			//}
			//
			////Sort distance
			//var array:Array = [];
			//while(_connectedNodesWithDistance.length > 0) array.push(_connectedNodesWithDistance.pop());
			//array.sortOn("Distance", Array.NUMERIC | Array.DESCENDING);
			//_connectedNodesWithDistance.length = 0;
			//while (array.length > 0) _connectedNodesWithDistance.push(array.pop());
			//
			//trace("CURRENTNODE = " + this.Index);
			//for each(var obj:NodeDistance in _connectedNodesWithDistance)
			//{
				//trace("From " + this.Index + " To " + obj.NodeTarget.Index + " = " + obj.Distance);
			//}
			//trace("");
		}
		
		public function GetNodesInDistanceRange():void
		{
			
		}
		
		//public function Node(ball:Ball_design, balls:Vector.<Ball_design>):void 
		//{
			//_ball = ball;
			//Position = new Point(_ball.x, _ball.y);
			//
			//if (balls.length <= 0)
			//{
				//return;
			//}
			//
			//var ballCount:Number = balls.length - 1;
			//
			//_connectedBalls = balls;
			//_connectedBallsDistance = new Vector.<Number>(ballCount);
			//
			//for (var i:int = ballCount - 1; i >= 0; i--)
			//{
				//var ball:Ball_design = _connectedBalls[i];
				//if (_ball != ball) 
				//{
					//_connectedBalls[i] = ball;
					//_connectedBallsDistance[i] = Point.distance(Position, new Point(ball.x, ball.y));
					//
					//trace(_connectedBallsDistance[i]);
				//}
			//}
		//}
	}
	
	//public class Node
	//{
		//private var _ball:Ball_design;
		//private var _connectedBalls:Vector.<Ball_design>;
		//private var _connectedBallsDistance:Vector.<Number>;
		//public var Position:Point;
		//
		//public function Node(ball:Ball_design, balls:Vector.<Ball_design>):void 
		//{
			//_ball = ball;
			//Position = new Point(_ball.x, _ball.y);
			//
			//if (balls.length <= 0)
			//{
				//return;
			//}
			//
			//var ballCount:Number = balls.length - 1;
			//
			//_connectedBalls = balls;
			//_connectedBallsDistance = new Vector.<Number>(ballCount);
			//
			//for (var i:int = ballCount - 1; i >= 0; i--)
			//{
				//var ball:Ball_design = _connectedBalls[i];
				//if (_ball != ball) 
				//{
					//_connectedBalls[i] = ball;
					//_connectedBallsDistance[i] = Point.distance(Position, new Point(ball.x, ball.y));
					//
					//trace(_connectedBallsDistance[i]);
				//}
			//}
		//}
	//}
}