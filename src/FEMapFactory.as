/*
Copyright (c) 2009 Yahoo! Inc.  All rights reserved.  
The copyrights embodied in the content of this file are licensed under the BSD (revised) open source license
*/
package
{
	
	public class FEMapFactory
	{
		public function FEMapFactory()
		{
		}
		
		static public function getMap():IFEMap
		{
			return new FEYahooMap();
			//return new FEGoogleMap();
		}
	}
}
