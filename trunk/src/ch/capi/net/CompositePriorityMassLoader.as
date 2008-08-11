package ch.capi.net 
{
	import flash.net.URLRequest;	
	
	/**
	 * This is a utility class to avoid too much verbose code within the masapi API. Note that this
	 * class simply uses the <code>IMassLoader</code> and <code>LoadableFileFactory</code> to creates
	 * the <code>ILoadableFile</code> and for the loading management.
	 * <p>The difference with the <code>CompositeMassLoader</code> is that this class uses directly a
	 * <code>PriorityMassLoader</code> and provides some more methods to add the files.</p>
	 *
	 * @example
	 * <listing version="3.0">
	 * var cm:CompositePriorityMassLoader = new CompositePriorityMassLoader();
	 * cm.addPrioritizedFile("myAnimation.swf", 5);
	 * cm.addFile("otherSWF.swf", LoadableFileType.BINARY); //priority = 0
	 * cm.addPrioritizedFile("myVariables.php", 3, LoadableFileType.TEXT);
	 * 
	 * cm.start();
	 * </listing>
	 *
	 * @see			ch.capi.net.PriorityMassLoader		PriorityMassLoader
	 * @see			ch.capi.net.LoadableFileFactory 	LoadableFileFactory
	 * @see			ch.capi.net.IMassLoader				IMassLoader
	 * @author		Cedric Tabin - thecaptain
	 * @version		1.0
	 */
	public class CompositePriorityMassLoader extends CompositeMassLoader
	{
		//-----------------//
		//Getters & Setters//
		//-----------------//
		
		/**
		 * Defines the <code>PriorityMassLoader</code> to use. If the value is of another type, then
		 * a <code>ArgumentError</code> will be thrown.
		 */
		public override function get massLoader():IMassLoader { return super.massLoader; }
		public override function set massLoader(value:IMassLoader):void
		{
			if (value == null) throw new ArgumentError("value is not defined");
			if (!(value is PriorityMassLoader)) throw new ArgumentError("value must be a PriorityMassLoader");
			super.massLoader = value;
		}
		
		//-----------//
		//Constructor//
		//-----------//
		
		/**
		 * Creates a new <code>CompositePriorityMassLoader</code> object.
		 * 
		 * @param	keepFiles				If the <code>CompositeMassLoader</code> must keep a reference on the created <code>ILoadableFile</code> instances.
		 * @param	massLoader				The <code>PriorityMassLoader</code> to use.
		 * @param	loadableFileFactory		The <code>LoadableFileFactory</code> to use.
		 * @see		ch.capi.net.CompositeMassLoader#keepFiles	CompositeMassLoader.keepFiles
		 */
		public function CompositePriorityMassLoader(keepFiles:Boolean=true, massLoader:PriorityMassLoader=null, factory:LoadableFileFactory=null):void
		{
			super(keepFiles, (massLoader==null) ? new PriorityMassLoader() : massLoader, factory);
		}
		
		//--------------//
		//Public methods//
		//--------------//
		
		/**
		 * Creates a <code>ILoadableFile</code> from a url and add it to the current loading queue.
		 * 
		 * @param 	url			The url of the file.
		 * @param	priority	The priority of the file.
		 * @param	fileType	The type of the file.
		 * @param	onOpen		The <code>Event.OPEN</code> listener.
		 * @param	onProgress	The <code>ProgressEvent.PROGRESS</code> listener.
		 * @param	onComplete	The <code>Event.COMPLETE</code> listener.
		 * @param	onClose		The <code>Event.CLOSE</code> listener.
		 * @param	onIOError	The <code>IOErrorEvent.IO_ERROR</code> listener.
		 * @param	onSecurityError The <code>SecurityErrorEvent.SECURITY_ERROR</code> listener.
		 * @return	The created <code>ILoadableFile</code>.
		 */
		public function addPrioritizedFile(url:Object, priority:int, fileType:String = null,
														onOpen:Function=null, 
											   			onProgress:Function=null, 
											   			onComplete:Function=null, 
											   			onClose:Function=null,
											   			onIOError:Function=null,
											   			onSecurityError:Function=null):ILoadableFile
		{
			var request:URLRequest = LoadableFileFactory.getRequest(url);
			var file:ILoadableFile = createLoadableFile(request, fileType);
			loadableFileFactory.attachListeners(file,onOpen, onProgress, onComplete, onClose, onIOError, onSecurityError);
			(massLoader as PriorityMassLoader).addPrioritizedFile(file, priority);
			
			if (keepFiles) storeFile(file);
			
			return file;
		}
	}
}
