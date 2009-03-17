package
{
	import com.google.maps.LatLng;
	import com.google.maps.Map;
	import com.google.maps.MapEvent;
	import com.google.maps.controls.ZoomControl;
	import com.google.maps.overlays.Marker;
	import com.google.maps.overlays.MarkerOptions;
	import com.google.maps.services.ClientGeocoder;
	import com.google.maps.services.GeocodingEvent;
	
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.system.Security;
	
	import net.yahoo.fireeagle.IFireEagleLocation;
	import net.yahoo.fireeagle.IFireEagleUser;

	public class FEGoogleMap implements IFEMap
	{
		private var _mapApiKey:String = "";
		private var _mapUrl:String = "";
		
		private var _map:Map;
		
		private var _overlays:Object = new Object();
		
		private var _level:Number = 3;
		private var _constZoomLevel:Number = 5;
		
		private var _initWidth:Number;
		private var _initHeight:Number;
		
		public function FEGoogleMap()
		{
		}

		public function init(level:Number, width:Number, height:Number):void
		{
			_level = level;
			_initWidth = width;
			_initHeight = height;
			
			_map = new Map();
			_map.key = _mapApiKey;
			_map.url = _mapUrl;
			_map.addEventListener(MapEvent.MAP_READY, onMapInitialize);
			_map.initialize();
		}
		
		private function onMapInitialize(event:MapEvent):void  
		{
			_map.enableScrollWheelZoom();
			_map.enableContinuousZoom();
			_map.addControl(new ZoomControl());
			// use const zoom level to help with panning
			_map.setZoom(_constZoomLevel);
			
			setSize(_initWidth, _initHeight);
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
			_map.setSize(new Point(width, height));
		}
		
		public function centerOnAddress(addressString:String):void
		{
			geocode(addressString, function(point:LatLng):void {
				_map.setCenter(point);
			});
		}
		
		public function panToUserLocation(user:IFireEagleUser):void
		{
			var loc:IFireEagleLocation = getUserLocationAtLevel(user, _level);
			if (loc != null) {
				geocode(loc.name, function(point:LatLng):void{
					_map.panTo(point);
				});
			}
		}
		
		public function addToUserLocationCounter(user:IFireEagleUser):void
		{
			var loc:IFireEagleLocation = getUserLocationAtLevel(user, _level);
			if (loc != null) {
				geocode(loc.name, function(point:LatLng):void{
					var o:Marker = (_overlays[loc.name] as Marker);
					if (o == null) {
						o = new Marker(point, new MarkerOptions({label:"0"}));
						_map.addOverlay(o);
						_overlays[loc.name] = o;
					}
					var opt:MarkerOptions = o.getOptions();
					opt.label = (Number(opt.label) + 1).toString();
					o.setOptions(opt);
				});
			}
		}
		
		static private function geocode(addressString:String, f:Function):void
		{
			var geocoder:ClientGeocoder = new ClientGeocoder();
			geocoder.addEventListener(GeocodingEvent.GEOCODING_SUCCESS, function(event:GeocodingEvent):void {
				var placemarks:Array = event.response.placemarks;
				if (placemarks.length > 0) {
					f(placemarks[0].point);
				}
			});
			geocoder.geocode(addressString);
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
