/*
Copyright (c) 2009 Yahoo! Inc.  All rights reserved.  
The copyrights embodied in the content of this file are licensed under the BSD (revised) open source license
*/
package
{
	import com.yahoo.maps.api.YahooMapEvent;
	import com.yahoo.maps.api.core.location.LatLon;
	import com.yahoo.maps.api.overlays.Overlay;
	
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	public class FEYahooCircleOverlay extends Overlay
	{	
		private var _text:TextField = new TextField();
		private var _centerLatLon:LatLon;
		private var _radiusPixels:Number;
		private var _displayNumber:Number = 0;
		public var fillColor:uint;
		public var fillAlpha:Number=1;
		public var lineThickness:Number;
		public var lineColor:uint;
		public var lineAlpha:Number;
		
		public function FEYahooCircleOverlay(centerLatLon:LatLon, radiusPixels:Number, fillColor:uint=0xFF0000, fillAlpha:Number=.5, lineColor:uint=0x000000, lineAlpha:Number=1, lineThickness:Number=.5)
		{
			super();
			
			_centerLatLon = centerLatLon;
			_radiusPixels = radiusPixels;
			
			this.fillColor = fillColor;
			this.fillAlpha = fillAlpha;
			this.lineColor = lineColor;
			this.lineAlpha = lineAlpha;
			this.lineThickness = lineThickness;
			
			_text.background = false;
			_text.border = false;
			_text.wordWrap = false;
			_text.selectable = false;
			_text.autoSize = TextFieldAutoSize.CENTER;
			var format:TextFormat = new TextFormat();
			format.font = "Verdana";
			format.color = 0xFFFFFF;
			format.size = 10;
			
			_text.defaultTextFormat = format;
			_text.text = "";
			
			addChild(_text);
		}
		
		public override function onMapZoom(event:YahooMapEvent):void 
		{
			redraw();
		}
		
		public function redraw():void
		{
			graphics.clear();
			graphics.lineStyle(lineThickness, lineColor, lineAlpha);
			graphics.beginFill(fillColor, fillAlpha);
			
			moveToLatLon(_centerLatLon);
			
			var p:Point = getLatLonToLocalPoint(_centerLatLon);
			
			graphics.drawCircle(p.x, p.y, radiusPixels);
			
			graphics.endFill();
			
			_text.text = _displayNumber.toString();
			_text.x = p.x - ((_text.width)/2);
			_text.y = p.y - ((_text.height)/2);
		}
		
		public function get centerLatLon():LatLon 
		{
			return _centerLatLon;
		}
		
		public function set centerLatLon(value:LatLon):void
		{
			_centerLatLon = value;
			redraw();
		}
		
		public function get radiusPixels():Number 
		{
			return Math.max(_radiusPixels, 4);
		}
		
		public function set radiusPixels(value:Number):void
		{
			_radiusPixels = value;
			redraw();
		}
		
		public function get displayNumber():Number 
		{
			return _displayNumber;
		}
		
		public function set displayNumber(value:Number):void
		{
			_displayNumber = value;
			redraw();
		}
	}
}
