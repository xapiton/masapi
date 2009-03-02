package ch.capi.utils{	import ch.capi.errors.ParseError;			/**	 * This class contains useful methods about <code>String</code> parsing.	 * 	 * @author 	Cedric Tabin - thecaptain	 * @version	1.0	 */	public class ParseUtils	{		//---------//		//Constants//		//---------//				/**		 * Regular expression used for checking if a <code>String</code> is a <code>Number</code>.		 */		private static const REGEXP_NUMBER:RegExp = /^-?([0-9]+\.?|[0-9]*(\.[0-9]+))$/ ;				/**		 * Regular expression used for checking if a <code>String</code> is an <code>Integer</code>.		 */		private static const REGEXP_INTEGER:RegExp = /^-?[0-9]+(\.0*)?$/ ;				/**		 * Regular expression used for checking if a <code>String</code> is an unsigned <code>Integer</code>.		 */		private static const REGEXP_UNSIGNED_INTEGER:RegExp = /^[0-9]+(\.0*)?$/;				/**		 * Regular expression used for checking if a <code>String</code> is a <code>Boolean</code>.		 */		private static const REGEXP_BOOLEAN:RegExp = /^(true|false|-?[0-9]+|yes|no)$/i;				//---------//		//Variables//		//---------//				//-----------------//		//Getters & Setters//		//-----------------//				//-----------//		//Constructor//		//-----------//				/**		 * Creates a new <code>ParseUtils</code> object.		 */		public function ParseUtils():void { }				//--------------//		//Public methods//		//--------------//				/**		 * Retrieves if the specified <code>String</code> is a valid <code>Number</code>.		 * <p>A valid <code>Number</code> can be one of the following :<br />		 * <ul>		 * 	<li>Any signed or unsigned <code>Integer</code> value</li>		 * 	<li>Any value that begins with a dot (.35)</li>		 * 	<li>Any value that ends with a dot (10.)</li>		 * </ul></p>		 * 		 * @param	str		The <code>String</code> to check.		 * @return	<code>true</code> if the <code>String</code> is a valid <code>Number</code>.		 */		public static function isNumber(str:String):Boolean		{			return REGEXP_NUMBER.test(str);		}				/**		 * Retrieves if the specified <code>String</code> is a valid <code>Integer</code>. A valid <code>Integer</code>		 * can end with a dot (10.).		 * 		 * @param	str		The <code>String</code> to check.		 * @return	<code>true</code> if the <code>String</code> is a valid <code>Integer</code>.		 */		public static function isInteger(str:String):Boolean		{			return REGEXP_INTEGER.test(str);		} 				/**		 * Retrieves if the specified <code>String</code> is a valid unsigned <code>Integer</code>. A valid unsigned		 * <code>Integer</code> can end with a dot (10.).		 * 		 * @param	str		The <code>String</code> to check.		 * @return	<code>true</code> if the <code>String</code> is a valid unsigned <code>Integer</code>.		 */		public static function isUnsigned(str:String):Boolean		{			return REGEXP_UNSIGNED_INTEGER.test(str);		}		/**		 * Retrieves if the specified <code>String</code> is a valid <code>Boolean</code>. 		 * <p>A valid boolean can be the following values : <br />		 * <ul>		 * 	<li><code>true</code></li>		 * 	<li><code>false</code></li>		 * 	<li>Any <code>Integer</code> value</li>		 * 	<li>yes</li>		 * 	<li>no</li>		 * </ul>		 * All other values are not valid values. Not that the values are not case sensitive.		 * </p>		 * 		 * @param	str		The <code>String</code> to check.		 * @return	<code>true</code> if the <code>String</code> is a valid <code>Boolean</code>.		 */
		public static function isBoolean(str:String):Boolean		{			return REGEXP_BOOLEAN.test(str);		}				/**		 * Parses the specified <code>String</code> to a <code>Float</code> using the <code>parseFloat</code> global function.		 * 		 * @param	str		The <code>String</code> to parse.		 * @return	A <code>Number</code>.		 * @throws	ch.capi.errors.ParseError	If the sepcified <code>String</code> is not a valid <code>Number</code>.		 * @see		#isNumber()		isNumber()		 */		public static function parseFloat(str:String):Number		{			if (!isNumber(str)) throw new ParseError("parseNumber", "The value '"+str+"' is not a valid Number");			return parseFloat(str);		}				/**		 * Parses the specified <code>String</code> to a <code>Number</code> using the <code>Number</code> global function. This		 * method can be useful for parsing special number string such as colors.		 * 		 * @param	str		The <code>String</code> to parse.		 * @return	A <code>Number</code>.		 */		public static function parseNumber(str:String):Number		{			return Number(str);		}				/**		 * Parses the specified <code>String</code> to a <code>Integer</code> using the <code>parseInt</code> global function.		 * 		 * @param	str		The <code>String</code> to parse.		 * @param	radix	The base for the attribute parsing.		 * @return	A <code>int</code>.		 * @throws	ch.capi.errors.ParseError	If the sepcified <code>String</code> is not a valid <code>Integer</code>.		 * @see		#isInteger()		isInteger()		 */		public static function parseInteger(str:String, radix:int=0):int		{			if (!isInteger(str)) throw new ParseError("parseInt", "The value '"+str+"' is not a valid Integer");			return parseInt(str, radix);		}				/**		 * Parses the specified <code>String</code> to a unsigned <code>Integer</code>.		 * 		 * @param	str		The <code>String</code> to parse.		 * @return	A <code>uint</code>.		 * @throws	ch.capi.errors.ParseError	If the sepcified <code>String</code> is not a valid unsigned <code>Integer</code>.		 * @see		#isUnsigned()		isUnsigned()		 */		public static function parseUnsigned(str:String):uint		{			if (!isUnsigned(str)) throw new ParseError("parseUnsigned", "The value '"+str+"' is not a valid unsigned Integer");			return parseInt(str);		}				/**		 * Parses the specified <code>String</code> to a <code>Boolean</code>.		 * 		 * @param	str		The <code>String</code> to parse.		 * @return	A <code>uint</code>.		 * @throws	ch.capi.errors.ParseError	If the sepcified <code>String</code> is not a valid <code>Boolean</code>.		 * @see		#isBoolean()		isBoolean()		 */		public static function parseBoolean(str:String):Boolean		{			if (!isBoolean(str)) throw new ParseError("parseBoolean", "The value '"+str+"' is not a valid Boolean");			if (str == "true") return true;			if (str == "false") return false;			if (str == "yes") return true;			if (str == "no") return false;						var v:int = parseInt(str);			return (v != 0);		}				//-----------------//		//Protected methods//		//-----------------//				//---------------//		//Private methods//		//---------------//	}}