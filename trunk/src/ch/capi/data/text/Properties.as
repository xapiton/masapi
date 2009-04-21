package ch.capi.data.text{	import ch.capi.utils.VariableReplacer;		import ch.capi.utils.ParseUtils;		import ch.capi.utils.Matcher;		import ch.capi.data.DictionnaryMap;		import ch.capi.data.IMap;		
	/**	 * The Properties class can store and parse some key/value pairs.	 * 	 * @author		Cedric Tabin - thecaptain	 * @version		1.0	 */	public class Properties implements IProperties	{		//---------//		//Constants//		//---------//				/**		 * Regular expressions for the key/value pairs.		 */		private static const PARSE_REGEXP:RegExp = /(\s*)(.*?)(\s*)=(.*)/g;				/**		 * Regular expression for the comments.		 */		private static const COMMENT_REGEX:RegExp = /(.*?)#(.*)/g;		//---------//		//Variables//		//---------//		private var _variables:IMap;		//-----------------//		//Getters & Setters//		//-----------------//				/**		 * Defines the variables contained into the <code>Properties</code>.		 */		public function get variables():IMap { return _variables; }				//-----------//		//Constructor//		//-----------//				/**		 * Creates a new <code>Properties</code> object.		 * 		 * @param	source		The source <code>IMap</code>. If not defined, then a new		 * 						instance of <code>DictionnaryMap</code> will be created.		 */		public function Properties(source:IMap=null):void		{			if (source != null) _variables = source;			else _variables = new DictionnaryMap();		}		//--------------//		//Public methods//		//--------------//		/**		 * Parses the specified <code>String</code>.		 * 		 * @param	properties		The <code>String</code> containing the properties.		 * @param	source			TThe source <code>IMap</code>. If not defined, then a new		 * 							instance of <code>DictionnaryMap</code> will be created.		 * @param 	replaceChars	 		 * @return	The created <code>Properties</code> instance.		 * @see		#replaceEscapedChars()	replaceEscapedChars()		 */		public static function parse(properties:String, source:IMap=null, replaceChars:Boolean=true):Properties		{			var p:Properties = new Properties(source);			p.parseData(properties, replaceChars);			return p;		}		/**		 * Maps the specified key with the value. If the key is already set, the value will be erased by		 * the new one.		 * 		 * @param	key		The key.		 * @param	value	The value.		 * @return	The old value or <code>null</code> if the value was not defined.		 */		public function setValue(key:String, value:*):*		{			return _variables.put(key, value);		}		/**		 * Retrieves the value of the specified key. If the key doesn't exist, then <code>null</code>		 * is returned.		 * 		 * @param	key		The key.		 * @return	The value or <code>null</code>.		 */		public function getValue(key:String):*		{			return _variables.getValue(key);		}			/**		 * Removes the specified key.		 * 		 * @param	key		The key to remove.		 * @return	The value of the key or <code>null</code> if the key was not defined.		 */		public function remove(key:String):*		{			return _variables.remove(key);		}
		/**		 * Retrieves the value with no variables into it. That means that the value is retrieved as a <code>String</code>		 * and then the source <code>IMap</code> is used to replace all the variables into it.		 * 		 * @param	key		The key.		 * @return	The value with no variable into it.		 * @throws	Error	If the value is not a <code>String</code>.		 * @see		ch.capi.utils.VariableReplacer#replace()	VariableReplacer.replace()		 */		public function getUpdatedValue(key:String):String		{			var value:Object = getValue(key);			if (! (key is String)) throw new Error("The key '"+key+"' has not a string value");						return VariableReplacer.replace(value as String, _variables);		}		/**		 * Retrieves the value of the specified key as integer.		 * 		 * @param	key		The key.		 * @return	The value as integer.		 * @throws	Error	If the value is not an integer.		 * @see		ch.capi.utils.ParseUtils#parseInteger()	ParseUtils.parseInteger()		 */		public function getValueAsInt(key:String):int		{			var value:Object = _variables.getValue(key);			if (! (value is String)) throw new Error("The key '"+key+"' has not a string value");						return ParseUtils.parseInteger(value as String);		}				/**		 * Retrieves the value of the specified key as float.		 * 		 * @param	key		The key.		 * @return	The value as Number.		 * @throws	Error	If the value is not an Number.		 * @see		ch.capi.utils.ParseUtils#parseFloat()	ParseUtils.parseFloat()		 */		public function getValueAsFloat(key:String):Number		{			var value:Object = _variables.getValue(key);			if (! (value is String)) throw new Error("The key '"+key+"' has not a string value");						return ParseUtils.parseFloat(value as String);		}		/**		 * Retrieves the value of the specified key as Number.		 * 		 * @param	key		The key.		 * @return	The value as Number.		 * @throws	Error	If the value is not an Number.		 * @see		ch.capi.utils.ParseUtils#parseNumber()	ParseUtils.parseNumber()		 */		public function getValueAsNumber(key:String):Number		{			var value:Object = _variables.getValue(key);			if (! (value is String)) throw new Error("The key '"+key+"' has not a string value");						return ParseUtils.parseNumber(value as String);		}				/**		 * Retrieves the value of the specified key as unsigned integer.		 * 		 * @param	key		The key.		 * @return	The value as unsigned integer.		 * @throws	Error	If the value is not an unsigned integer.		 * @see		ch.capi.utils.ParseUtils#parseUnsigned()	ParseUtils.parseUnsigned()		 */		public function getValueAsUnsigned(key:String):uint		{			var value:Object = _variables.getValue(key);			if (! (value is String)) throw new Error("The key '"+key+"' has not a string value");						return ParseUtils.parseUnsigned(value as String);		}				/**		 * Retrieves the value of the specified key as Boolean.		 * 		 * @param	key		The key.		 * @return	The value as Boolean.		 * @throws	Error	If the value is not a Boolean.		 * @see		ch.capi.utils.ParseUtils#parseBoolean()	ParseUtils.parseBoolean()		 */		public function getValueAsBoolean(key:String):Boolean		{			var value:Object = _variables.getValue(key);			if (! (value is String)) throw new Error("The key '"+key+"' has not a string value");						return ParseUtils.parseBoolean(value as String);		}				/**		 * Retrieves the value of the specified key as color (unsigned int).		 * 		 * @param	key		The key.		 * @return	The value as color.		 * @throws	Error	If the value is not a color value.		 * @see		ch.capi.utils.ParseUtils#parseColor()	ParseUtils.parseColor()		 */		public function getValueAsColor(key:String):uint		{			var value:Object = _variables.getValue(key);			if (! (value is String)) throw new Error("The key '"+key+"' has not a string value");						return ParseUtils.parseColor(value as String);		}		/**		 * Parses the specified source. The source must be a list of variables formatted like that <code>key=value</code>		 * on each line. The old key/value pairs are kept.		 * 		 * @param	src				The source to parse.		 * @param	replaceChars	Tells the parser to replace the special chars (\n, \t, ...).		 * @see		#replaceEscapedChars()		replaceEscapedChars()		 */		public function parseData(src:String, replaceChars:Boolean=true):void		{			//removes the comments			src = src.replace(COMMENT_REGEX, "$1");					//parse the variables			var matcher:Matcher = new Matcher(PARSE_REGEXP, src);			while (matcher.find())			{				var key:String = matcher.group(2);				var value:String = matcher.group(4);								//if the special chars must be replaced, then do it :)				if (replaceChars) value = replaceEscapedChars(value);					_variables.put(key, value);			}		}				/**		 * Deletes all the key/value pairs of the <code>IMap</code>.		 * 		 * @see		ch.capi.data.IMap#clear()	IMap.clear()		 */		public function clear():void		{			_variables.clear();		}				/**		 * Returns a <code>String</code> representation of the <code>Properties</code>		 * object. The <code>String</code> contains the list of the keys with their values.		 * 		 * @return	A <code>String</code> representation of the <code>Properties</code> object.		 */		public function toString():String		{			var builder:String = "Properties [\n";			var keys:Array = _variables.keys();			for each(var key:* in keys)			{				var value:* = _variables.getValue(key);				builder += "  "+key+" = "+value+"\n";			}			builder+="]";						return builder;		}		//-----------------//		//Protected methods//		//-----------------//				/**		 * Replaces the escaped chars into the specified <code>String</code> and		 * return the new <code>String</code>.		 * <p>The special chars that will be replaced :<br />		 * <ul>		 * 	<li>\n (newline)</li>		 * 	<li>\t (tab)</li>		 * 	<li>\r (return)</li>		 * 	<li>\u0020 (space)</li>		 * </ul>		 * 		 * @param	str		The source <code>String</code>.		 * @return	A new <code>String</code> with replaced chars.		 */		protected function replaceEscapedChars(str:String):String		{			str = str.replace("\\n", "\n");			str = str.replace("\\t", "\t");			str = str.replace("\\r", "\r");			str = str.replace("\\u0020", " ");						return str;		}				//---------------//		//Private methods//		//---------------//	}}