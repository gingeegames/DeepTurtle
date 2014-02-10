package com.gingee.deepTurtle.settingsAndEnum
{
	import flash.net.SharedObject;

	public class DataStorage
	{
		private static const STORAGE_ID:String = 'com.gingee.turtleDay';

		private var _so:SharedObject;
		
		public function DataStorage(l:LKR)
		{
			if(!l)
				throw new Error('illegal instanciation of a singleton object');
		}
		
		public function load(fieldName:String):Object
		{
			_so = SharedObject.getLocal(STORAGE_ID);
			return _so.data[fieldName];
		}
		
		public function save(fieldName:String, val:*):void
		{
			_so = SharedObject.getLocal(STORAGE_ID);
			_so.data[fieldName] = val;
			_so.flush();
		}
		
		private static var _instance:DataStorage = null;
		
		public static function get instance():DataStorage
		{
			if(!_instance)
				_instance = new DataStorage(new LKR());
			
			return _instance;
		}
	}
}

internal class LKR{}