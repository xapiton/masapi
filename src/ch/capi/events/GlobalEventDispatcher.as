package ch.capi.events{	import flash.events.Event;		import flash.events.EventDispatcher;			/**	 * Dispatched before an event is dispatched.	 * 	 * @eventType	ch.capi.events.GlobalEvent.GLOBAL_BEFORE	 */	[Event(name="globalBefore", type="ch.capi.events.GlobalEvent")]		/**	 * Dispatched after an event is dispatched.	 * 	 * @eventType	ch.capi.events.GlobalEvent.GLOBAL_AFTER	 */	[Event(name="globalAfter", type="ch.capi.events.GlobalEvent")]	
	/**	 * The <code>GlobalEventDispatcher</code> class allows to add some listeners to 	 * any kind of event sent by a sub-class.	 * 	 * @author		Cedric Tabin - thecaptain	 * @version		1.0	 */	public class GlobalEventDispatcher extends EventDispatcher	{		//---------//		//Constants//		//---------//				//---------//		//Variables//		//---------//				//-----------------//		//Getters & Setters//		//-----------------//				//-----------//		//Constructor//		//-----------//				public function GlobalEventDispatcher():void {}				//--------------//		//Public methods//		//--------------//		/**		 * Dispatches the specified <code>Event</code> through the listeners. This method		 * will also dispatch a <code>GlobalEvent.GLOBAL_BEFORE</code> and <code>GlobalEvent.GLOBAL_AFTER</code>		 * event before and after the event dispatching.		 * If the <code>GlobalEvent.GLOBAL_BEFORE</code> dispatching returns <code>false</code>, then the		 * event won't ben dispatched trought the listeners and <code>false</code> is returned. Otherwise,		 * the event source and the event <code>GlobalEvent.GLOBAL_AFTER</code> are dispatched and the result		 * is the returned value of the source event dispatching.		 * 		 * @param	evt		The source <code>Event</code>.		 * @return	<code>true</code> if all the events have been dispatched.		 */		public override function dispatchEvent(evt:Event):Boolean		{			//dispatch global before			var gb:GlobalEvent = new GlobalEvent(GlobalEvent.GLOBAL_BEFORE, evt);			var continueDispatch:Boolean = super.dispatchEvent(gb);			if (!continueDispatch) return false;						//dispatch the real event			var result:Boolean = super.dispatchEvent(evt);						//dispatch global after			var ab:GlobalEvent = new GlobalEvent(GlobalEvent.GLOBAL_AFTER, evt);			super.dispatchEvent(ab);						return result;		}		//-----------------//		//Protected methods//		//-----------------//				//---------------//		//Private methods//		//---------------//	}}