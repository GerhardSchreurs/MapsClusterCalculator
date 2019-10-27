package Cluster
{
	import com.adobe.tvsdk.mediacore.ItemLoaderListener;
	import fl.controls.Button;
	import fl.controls.TextInput;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author Wroah
	 */
	public class Main extends Sprite 
	{
		[SWF(backgroundColor="0xec9900" , width="980" , height="880")]
		public function Main() 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private const NUMBEROFBALLS:Number = 100;
		private const MAXNUMBEROFBALLS:Number = 5;
		
		private var _nodesMap:Vector.<Node>;
		private var _nodesDetail:Vector.<Node>;
		private var _nodesCluster:Vector.<NodeCluster>;
		
		//Outline
		private var _map:Map;
		private var _nodeDetailView:BallContainer;
		private var _nodeContainerB:BallContainer;
		private var _box:BoxArea_design;
		private var _btnGenerate:Button;
		private var _btnCalculate:Button;
		private var _txtGenerate:TextInput;
		private var _txtCalculate:TextInput;
		
		private function initDesign():void
		{
			_map = new Map();
			_map.x = 20;
			_map.y = 20;
			addChild(_map);
			
			_nodeDetailView = new BallContainer();
			_nodeDetailView.x = 550;
			_nodeDetailView.y = 20;
			addChild(_nodeDetailView);
			
			_nodeContainerB = new BallContainer();
			_nodeContainerB.x = 550;
			_nodeContainerB.y = 470;
			addChild(_nodeContainerB);
			
			_btnGenerate = new Button();
			_btnGenerate.label = "Generate"
			_btnGenerate.x = 420;
			_btnGenerate.y = 840;
			addChild(_btnGenerate);
			
			_txtGenerate = new TextInput();
			_txtGenerate.x = 300;
			_txtGenerate.y = 840;
			addChild(_txtGenerate);	
			
			_btnCalculate = new Button();
			_btnCalculate.label = "Calculate";
			_btnCalculate.x = 800;
			_btnCalculate.y = 390;
			addChild(_btnCalculate);
			
			_txtCalculate = new TextInput();
			_txtCalculate.x = 680;
			_txtCalculate.y = 390;
			addChild(_txtCalculate);
		}
		
		private function hookEvents():void
		{
			_btnGenerate.addEventListener(MouseEvent.CLICK, handle_btnGenerateClick);
			_btnCalculate.addEventListener(MouseEvent.CLICK, handle_btnCalculateClick);
			stage.addEventListener(MouseEvent.MOUSE_UP, handle_stageMouseUp);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			initDesign();
			hookEvents();
			
			_txtGenerate.text = NUMBEROFBALLS.toString();
			_txtCalculate.text = MAXNUMBEROFBALLS.toString();
			
			_nodesMap = new Vector.<Node>();
		}
		
		private function handle_btnGenerateClick(e:MouseEvent):void 
		{
			generateNodes(Number(_txtGenerate.text));
		}
		
		private function handle_stageMouseUp(evt:MouseEvent):void
		{
			stopDrag();
				
			if (_box != null)
			{
				copyNodesToDetailView();
			}
		}
		

		private function handle_btnCalculateClick(e:MouseEvent):void 
		{
			//_nodesCluster = new Vector.<NodeCluster>();
			//
			////Calculate distance
			//for (var i:int = 0; i<_nodesDetail.length; i++)
			//{
				//var node:Node = _nodesDetail[i];
				//node.AddConnectedNodes(_nodesDetail);
				//node.CalculateDistance();
			//}
			//
			//for (var i:int = 0; i<_nodesDetail.length; i++)
			//{
			//}
			
			DoStuff();
		}
		
		private function handle_boxMouseDown(evt:MouseEvent):void
		{
			_box.startDrag(false, new Rectangle(0,0, _map.width - _box.width, _map.height - _box.height));
		}
		
		private function copyNodesToDetailView():void {
			removeKids(_nodeDetailView);
			
			if (_nodesDetail != null)
			{
				_nodesDetail.length = 0;
				_nodesDetail = null;
			}
			
			_nodesDetail = new Vector.<Node>();
			_nodesCluster = new Vector.<NodeCluster>();
			
			var rect:Rectangle = new Rectangle(_box.x, _box.y, _box.width, _box.height);
			var multiplier = _nodeDetailView.width / _box.width;

			sortBalls();	
			
			//First iteration; calculate distance between nodes
			for (var i:int = 0; i<_nodesMap.length; i++)
			{
				var node:Node = _nodesMap[i];
				
				if (rect.contains(node.x + (node.width / 2), node.y + (node.height / 2)))
				{
					var relativeX = (node.x - rect.x);
					var relativeY = (node.y - rect.y);
					var size = Math.round(node.width * multiplier);
					
					relativeX *= multiplier;
					relativeY *= multiplier;
					
					var dup = node.Clone();
					
					dup.width = size; 
					dup.height = size;
					
					dup.x = relativeX;
					dup.y = relativeY;
					
					_nodeDetailView.addChild(dup);
					_nodesDetail.push(dup);
				}
			}
		}
		
		private function sortBalls():void 
		{
			var array:Array = [];
			while (_nodesMap.length > 0) array.push(_nodesMap.pop());
			array.sortOn('Index', Array.NUMERIC|Array.DESCENDING);
			while (array.length > 0) _nodesMap.push(array.pop());
		}

		private function dupe(clip:MovieClip):MovieClip
		{
			var sourceClass:Class = Object(clip).constructor;
			var duplicate:MovieClip = new sourceClass();
			return duplicate;
		}

		private function removeKids(mc:MovieClip, destroy:Boolean = true):void
		{
			for (var i : int = mc.numChildren-1 ; i >= 1 ; i--)
			{
				var child = mc.getChildAt(i);

				if(child is MovieClip)
				{
					mc.removeChild(child);
					
					if (destroy)
					{
						child = null;
					}
				}
			}	
		}
		
		private function randomRange(minNum:Number, maxNum:Number):Number 
		{
			return (Math.floor(Math.random() * (maxNum - minNum + 1)) + minNum);
		}
		
		private function generateNodes(number:int):void {
			removeKids(_map);
			removeKids(_nodeDetailView);
			_nodesMap.length = 0;
			
			var w:Number = _map.width;
			var h:Number = _map.height;
			
			for (var i:int = 0; i < number; i++)
			{
				var node:Node = new Node();
				node.Index = i;
				_map.addChild(node);
				_nodesMap.push(node);
				
				var randX:Number = randomRange(0,(w - node.width));		
				var randY:Number = randomRange(0,(h - node.height));
				
				node.x = randX;
				node.y = randY;
			}
			
			generateBox();
			_map.addChild(_box);
		}
		
		private function generateBox():void
		{
			if (_box != null)
			{
				_box.removeEventListener(MouseEvent.MOUSE_DOWN, handle_boxMouseDown);
				_box = null;
			}
			
			if (_box == null)
			{
				_box = new BoxArea_design();
				_box.addEventListener(MouseEvent.MOUSE_DOWN, handle_boxMouseDown);
			}
		}
		
		/***********************************************************************/
		
		
		const MINIMUMNODEDISTANCE:Number = 80;
		const MAXIMUMNODESINAREA:int = 5;
		
		var nodeArray:Array;
		var groupArray:Array;

		private function NodeArrayPrint(argument:String):void
		{
			trace("==============================");
			trace(argument);
			trace("==============================");
			
			for (var i:int = 0; i < nodeArray.length; i++)
			{
				var inner:Array = nodeArray[i];
				var nodeA:Node = inner[0];
				var nodeB:Node = inner[1];
				var distance:Number = inner[2];
				var groupID:int = inner[3];

				trace(nodeA.Index + "," + nodeB.Index + "," + distance + ":" + groupID);
			}
			
			trace("");
		}
		
		private function GroupArrayPrint(argument:String):void
		{
			trace("==============================");
			trace(argument);
			trace("==============================");
			
			for (var i:int = 0; i < groupArray.length; i++)
			{
				var inner:Array = groupArray[i];
				var group:int = inner[0];
				var node:Node = inner[1];

				trace("Group: " + group + " | Node: " + node.Index);
			}
			
			trace("");
		}
		
		private function DoStuff():void
		{
			nodeArray = new Array();
			groupArray = new Array();
			
			NodeArrayBuild();
			NodeArrayRemoveDuplicates();
			NodeArraySortDistance();
			NodeArrayMarkCloseNodes();
			CleanGroupArray();
			NodeArraySetBorderColors();
		}
		
		private function NodeArrayBuild():void
		{
			for (var i:int = 0; i < _nodesDetail.length; i++)
			{
				var node:Node = _nodesDetail[i];
				
				for (var j:int = 0; j < _nodesDetail.length; j++)
				{
					var other:Node = _nodesDetail[j]
					
					if (node === other)
					{
						continue;
					}
					
					var pointA = new Point(node.x, node.y);
					var pointB = new Point(other.x, other.y);
					var distance = Point.distance(pointA, pointB);
					
					var inner:Array = new Array();
					inner.push(node);
					inner.push(other);
					inner.push(Math.round(distance));
					inner.push(-1);
					
					nodeArray.push(inner);
				}
			}
			
			NodeArrayPrint("NodeArrayBuild()");
		}
		
		private function NodeArrayRemoveDuplicates():void
		{
			var nodeArrayLength:int = nodeArray.length;
			
			for (var i:int = 0; i < nodeArrayLength; i++)
			{
				var nodeA:Node = nodeArray[i][0];
				var nodeB:Node = nodeArray[i][1];
				
				if (nodeA == null)
				{
					continue;
				}
				
				for (var j:int = nodeArrayLength - 1; j > i; j--)
				{
					var nodeC:Node = nodeArray[j][0];
					var nodeD:Node = nodeArray[j][1];
					
					if (nodeA == nodeD && nodeB == nodeC)
					{
						nodeArray[j][0] = null;
						continue;
					}
				}
			}
			
			//Cleanup
			for (var i:int = nodeArrayLength - 1; i >= 0; i--)
			{
				if (nodeArray[i][0] == null)
				{
					nodeArray.removeAt(i);
				}
			}
			
			NodeArrayPrint("NodeArrayRemoveDuplicates");
		}
		
		private function NodeArraySortDistance():void
		{
			nodeArray.sortOn('2', Array.NUMERIC);
			NodeArrayPrint("NodeArraySortDistance()");
		}
		
		//private function NodeArrayMarkGroupsTemp(maxOffset:int, targetGroupId:int, newGroupId:int, nodeC:Node, nodeD:Node):void
		//{
			//for (var i:int = 0; i < maxOffset; i++)
			//{
				//var arrayInner:Array = nodeArray[i];
				//var nodeA:Node = arrayInner[0];
				//var nodeB:Node = arrayInner[1];
				//var innerGroupId:Number = arrayInner[3];
				//
				//trace("NodeArrayMarkGroups[" + i + "] : innerGroupId : " + innerGroupId); 
//
				//if (nodeA == nodeC && nodeB != nodeD)
				//{
					//arrayInner[3] = newGroupId;	
					//trace("  ****. Overriding A. Old groupID : " + innerGroupId + ", new : " + newGroupId);
				//}
				//else if (nodeB == nodeD && nodeA != nodeC)
				//{
					//arrayInner[3] = newGroupId;
					//trace("  ****. Overriding B. Old groupID : " + innerGroupId + ", new : " + newGroupId);
				//}
				//else if (innerGroupId == targetGroupId)
				//{
					//trace("  ****. Replacing. Old groupID : " + arrayInner[3] + ", new : " + newGroupId);
					//arrayInner[3] = newGroupId;
				//}
			//}
			//
			////Is there already a node connected to nodeC or ?
		//}
		//
		//private function NodeArrayMarkGroups(maxOffset:int, targetGroupId:int, newGroupId:int, nodeC:Node, nodeD:Node):void
		//{
			//for (var i:int = 0; i < maxOffset; i++)
			//{
				//var arrayInner:Array = nodeArray[i];
				//var nodeA:Node = arrayInner[0];
				//var nodeB:Node = arrayInner[1];
				//var innerGroupId:Number = arrayInner[3];
				//
				//trace("NodeArrayMarkGroups[" + i + "] : innerGroupId : " + innerGroupId); 
//
				//if (nodeA == nodeC && nodeB != nodeD)
				//{
					//arrayInner[3] = newGroupId;	
					//trace("  ****. Overriding A. Old groupID : " + innerGroupId + ", new : " + newGroupId);
				//}
				//else if (nodeB == nodeD && nodeA != nodeC)
				//{
					//arrayInner[3] = newGroupId;
					//trace("  ****. Overriding B. Old groupID : " + innerGroupId + ", new : " + newGroupId);
				//}
				//else if (innerGroupId == targetGroupId)
				//{
					//trace("  ****. Replacing. Old groupID : " + arrayInner[3] + ", new : " + newGroupId);
					//arrayInner[3] = newGroupId;
				//}
			//}
			//
			////Is there already a node connected to nodeC or ?
		//}
		
		private function GroupArrayContains(node:Node):int
		{
			for (var i:int = 0; i < groupArray.length; i++)
			{
				if (groupArray[i][1] == node)
				{
					return groupArray[i][0];
				}
			}
			
			return -1;
		}
		
		private function GroupArrayReplace(oldGroup:int, newGroup:int):void
		{
			for (var i:int = 0; i < groupArray.length; i++)
			{
				if (groupArray[i][0] == oldGroup)
				{
					groupArray[i][0] = newGroup;
				}
			}
		}
		
	

		private function AddToGroupArray(node:Node, groupId:int):void
		{
			var oldGroupId = GroupArrayContains(node);
			
			if (oldGroupId > -1)
			{
				GroupArrayReplace(oldGroupId, groupId);
			}
			else 
			{
				var array:Array = new Array();
				array[0] = groupId;
				array[1] = node;
				
				groupArray.push(array);
			}
		}
		
		private function CleanGroupArray():void
		{
			//0, 1, 4, 5
			//Sort by GroupID
			
			
			groupArray = groupArray.sortOn('0', Array.NUMERIC);
			
			GroupArrayPrint("After sort");

			var group:int = 0;
			var groupSearch:int = 0;
			
			for (var i:int = 0; i < groupArray.length; i++)
			{
				var groupNow:int = groupArray[i][0];
				
				if (groupNow > groupSearch)
				{
					group++;
					groupSearch = groupNow;
					groupArray[i][0] = group; 
				}
				else
				{
					groupArray[i][0] = group;
				}
			}
			
			GroupArrayPrint("After clean");
		}
		
		
		private function NodeArrayMarkCloseNodes():void
		{
			var groupCountID:int = 0;
			
			for (var i:int = 0; i < nodeArray.length; i++)
			{
				var array:Array = nodeArray[i];
				var nodeA:Node = array[0];
				var nodeB:Node = array[1];
				var distance:Number = array[2];
				var groupID:int = array[3];
				
				trace("i = " + i + ". Processing " + nodeA.Index + "," + nodeB.Index + " / GroupCountID = " + groupCountID)

				if (distance > MINIMUMNODEDISTANCE)
				{
					break;
				}
				else 
				{
					AddToGroupArray(nodeA, groupCountID);
					AddToGroupArray(nodeB, groupCountID);
					
					groupCountID ++;

					
					//
					
					
					//Do we have any other nodes connected to nodeA or nodeB?
					//for (var j:int = i - 1; j >= 0; j--)
					//{
						//var arrayInner:Array = nodeArray[j];
						//var nodeC:Node = arrayInner[0]; 
						//var nodeD:Node = arrayInner[1];
						//var innerGroupId:Number = arrayInner[3];
//
						//trace("  j = " + j + ". Processing " + nodeC.Index + "," + nodeD.Index + " / GroupID = " + innerGroupId)
//
						//
						//if (nodeA == nodeC || nodeA == nodeD || nodeB == nodeC || nodeB == nodeD)
						//{
							////TODO: Find all nodes with same group id, replace
							////trace("  ####. Replacing. Old groupID : " + innerGroupId + ", new : " + groupCountID);
							//trace("  ####. Replacing. Old groupID : " + innerGroupId + ", new : " + groupCountID);
							//
							//arrayInner[3] = groupCountID;
							//NodeArrayMarkGroups(i, innerGroupId, groupCountID, nodeC, nodeD);
							//break;
						//}
					//}
					//
					//trace("");
					//
					//for (var k:int = 0; k < nodeArray.length; k++)
					//{
						//var xarray:Array = nodeArray[k];
						//var xnodeA:Node = xarray[0];
						//var xnodeB:Node = xarray[1];
						//var xdistance:Number = xarray[2];
						//var xgroupID:int = xarray[3];
						//
						//if (xgroupID > -1)
						//{
							//trace ("      [" + xgroupID + "] : " + xnodeA.Index + "," + xnodeB.Index)
						//}
					//}
//
					//trace("***");
				}
			}
			
			GroupArrayPrint("");			
			//NodeArrayPrint("NodeArrayMarkCloseNodes()");
		}
		
		private function NodeArraySetBorderColorsOLD():void
		{
			for (var i:int = 0; i < nodeArray.length; i++)
			{
				var groupID:int = nodeArray[i][3];
				if (groupID > -1)
				{
					nodeArray[i][0].SetBorderColor(groupID);
					nodeArray[i][1].SetBorderColor(groupID);
				}
			}
			
			trace("Done setting border colors");
		}
		
		private function NodeArraySetBorderColors():void
		{
			for (var i:int = 0; i < groupArray.length; i++)
			{
				var groupID:int = groupArray[i][0];
				var node:Node = groupArray[i][1];
				
				for (var j:int = 0; j < nodeArray.length; j++)
				{
					if (nodeArray[j][0] == node)
					{
						nodeArray[j][0].SetBorderColor(groupID);
					}
					if (nodeArray[j][1] == node)
					{
						nodeArray[j][1].SetBorderColor(groupID);
					}
				}
			}
			
			trace("Done setting border colors");
		}

	}
}