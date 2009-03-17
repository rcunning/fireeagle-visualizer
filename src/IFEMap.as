/*
Copyright (c) 2009 Yahoo! Inc.  All rights reserved.  
The copyrights embodied in the content of this file are licensed under the BSD (revised) open source license
*/
package
{
	import flash.display.Sprite;
	
	import net.yahoo.fireeagle.IFireEagleUser;

	public interface IFEMap
	{
		function init(level:Number, width:Number, height:Number):void;
		function set level(value:Number):void;
		function get sprite():Sprite;
		function setSize(width:Number, height:Number):void;
		function centerOnAddress(addressString:String):void;
		function panToUserLocation(user:IFireEagleUser):void;
		function addToUserLocationCounter(user:IFireEagleUser):void;
	}
}
