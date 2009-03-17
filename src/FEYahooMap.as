/*
Copyright (c) 2009 Yahoo! Inc.  All rights reserved.  
The copyrights embodied in the content of this file are licensed under the BSD (revised) open source license
*/
package
{
	import com.yahoo.maps.api.YahooMap;
	import com.yahoo.maps.api.YahooMapEvent;
	import com.yahoo.maps.api.core.location.Address;
	import com.yahoo.maps.webservices.geocoder.Geocoder;
	import com.yahoo.maps.webservices.geocoder.GeocoderResult;
	import com.yahoo.maps.webservices.geocoder.GeocoderResultSet;
	import com.yahoo.maps.webservices.geocoder.cache.GeocoderCache;
	import com.yahoo.maps.webservices.geocoder.events.GeocoderEvent;
	
	import flash.display.Sprite;
	import flash.utils.getTimer;
	
	import net.yahoo.fireeagle.IFireEagleLocation;
	import net.yahoo.fireeagle.IFireEagleUser;

	public class FEYahooMap implements IFEMap
	{
		private var _mapApiKey:String = "";
		
		private var _map:YahooMap;
		
		private var _overlays:Object = new Object();
		
		private var _level:Number = 3;
		private var _constZoomLevel:Number = 13;
		
		private var _oldTime:int = -2000;
		
		public function FEYahooMap()
		{
		}

		public function init(level:Number, width:Number, height:Number):void
		{
			_level = level;
			
			_map = new YahooMap();
			_map.addEventListener(YahooMapEvent.MAP_INITIALIZE, onMapInitialize);
			_map.init(_mapApiKey, width, height);
			
			_map.addPanControl(); 
			_map.addZoomWidget(); 
			_map.addTypeWidget();
			//_map.addCrosshair();
		}
		
		private function onMapInitialize(event:YahooMapEvent):void  
		{
			// use const zoom level to help with panning
			_map.zoomLevel = _constZoomLevel;
			
			centerOnAddress("San Francisco, CA");
		}
		
		public function set level(value:Number):void
		{
			_level = value;
		}
		
		public function get sprite():Sprite
		{
			return _map;
		}
		
		public function setSize(width:Number, height:Number):void
		{
			_map.setSize(width, height);
		}
		
		public function centerOnAddress(addressString:String):void
		{
			var address:Address = new Address(addressString);
			address.addEventListener(GeocoderEvent.GEOCODER_SUCCESS, function(e:GeocoderEvent):void{
				var result:GeocoderResult = address.geocoderResultSet.firstResult;
				//_map.zoomLevel = result.zoomLevel;
				_map.centerLatLon = result.latlon;
			});
			address.geocode();
		}
		
		public function panToUserLocation(user:IFireEagleUser):void
		{
			var loc:IFireEagleLocation = getUserLocationAtLevel(user, _level);
			if (loc != null) {
				geoCodeWoeid(loc.woeid.toString(), function(result:GeocoderResult):void{
					//_map.zoomLevel = result.zoomLevel;
					var newTime:int = getTimer();
					try {
						if (newTime > _oldTime + 2000) { // don't call pan again until last pan finished else get exception and lock up the panning forever!
							_map.panToLatLon(result.latlon, 2000);
							_oldTime = newTime;
						}
					} catch (e:Error) {
						// ignore exception on panning while a pan is already in process, just skip this pan
						trace("uggg, panning broke.");
						_map.centerLatLon = result.latlon;
					}
				});
			}
		}
		
		public function addToUserLocationCounter(user:IFireEagleUser):void
		{
			var loc:IFireEagleLocation = getUserLocationAtLevel(user, _level);
			if (loc != null) {
				geoCodeWoeid(loc.woeid.toString(), function(result:GeocoderResult):void{
					var o:FEYahooCircleOverlay = (_overlays[loc.woeid] as FEYahooCircleOverlay);
					if (o == null) {
						o = new FEYahooCircleOverlay(result.latlon.clone(), 1);
						_map.overlayManager.addOverlay(o);
						_overlays[loc.woeid] = o;
					}
					o.displayNumber++;
					o.radiusPixels = factorPixelSize(o.displayNumber);
				});
			}
		}
		
		static private function factorPixelSize(count:Number):Number
		{
			return Math.min(30, count + 4);
		}
		
		static private function geoCodeWoeid(woeidString:String, f:Function):void
		{
			GeocoderCache.getInstance().resetCache(); // cache uses address string, since we are using "" it causes a cache hit every time
			var geo:Geocoder = new Geocoder();
			geo.addEventListener(GeocoderEvent.GEOCODER_SUCCESS, function(ev:GeocoderEvent):void{
				var result:GeocoderResult = (ev.data as GeocoderResultSet).firstResult;
				f(result);
			});
			geo.geocode(new Address(""), {woeid:woeidString});
		}
		
		static private function getUserLocationAtLevel(user:IFireEagleUser, level:Number):IFireEagleLocation
		{
			for (var i:int = 0; i < user.locations.length; i++) {
				if (user.locations[i].level >= level) {
					return user.locations[i];
				}
			}
			return null;
		}
	}
}
