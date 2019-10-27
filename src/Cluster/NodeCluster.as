package Cluster 
{
	/**
	 * ...
	 * @author Wroah
	 */
	public class NodeCluster 
	{
		private var _nodes:Vector.<Node>;
		
		public function NodeCluster() 
		{
			_nodes = new Vector.<Node>();
		}
		
		public function Add(node:Node):void
		{
			_nodes.push(node);
		}
	}
}