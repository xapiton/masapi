package ch.capi.net.app{
	import ch.capi.net.ILoadableFile;	import flash.errors.IllegalOperationError;	
	import ch.capi.errors.NameAlreadyExistsError;	
	import ch.capi.data.IMap;	import ch.capi.data.LinkedMap;		
	/**	 * Represents a context for the <code>ApplicationFile</code> objects.	 * 	 * @see			ch.capi.net.app.ApplicationFile	ApplicationFile	 * @see			ch.capi.net.app.ApplicationContextRegisterer ApplicationContextRegisterer	 * @author		Cedric Tabin - thecaptain	 * @version		1.1	 */	public final class ApplicationContext implements IApplicationContext	{		//---------//		//Constants//		//---------//				//---------//		//Variables//		//---------//		private var _files:IMap										= new LinkedMap();		private var _name:String;		//-----------------//		//Getters & Setters//		//-----------------//				/**		 * Defines the name of the <code>ApplicationContext</code>.		 */		public function get name():String { return _name; }				//-----------//		//Constructor//		//-----------//				/**		 * Creates a new <code>ApplicationContext</code> object.		 * 		 * @param	name		The name of the <code>ApplicationContext</code>. The name must be unique if defined. If the		 * 						name is <code>null</code>, then the <code>ApplicationContext</code> won't be registered. Else the		 * 						<code>ApplicationContext</code> will register itself into the <code>applicationContexts</code>		 * 						constant.		 * @param	register	Defines if the <code>ApplicationContext</code> must register itself info the 		 * 						<code>ApplicationContextRegisterer</code> automatically.		 */		public function ApplicationContext(name:String=null, register:Boolean=true):void 		{ 			_name = name;						//put the context into the set			if (name != null && register) ApplicationContextRegisterer.register(this);		}		//--------------//		//Public methods//		//--------------//		/**		 * Get the <code>ApplicationFile</code> linked to the specified name.		 * 		 * @param	name	The name of the <code>ApplicationFile</code>.		 * @return	The <code>ApplicationFile</code> or <code>null</code> if the file doesn't exist.		 * @throws	Error	If there is no <code>ApplicationFile</code> matching the specified name.		 */		public function getFile(name:String):ApplicationFile		{			var file:ApplicationFile = _files.getValue(name) as ApplicationFile;			if (file == null) throw new Error("There is no ApplicationFile matching the name '"+name+"'");			return file;		}				/**		 * Retrieves the first <code>ApplicationFile</code> that matches the specified properties.		 * 		 * @param	props		An <code>Object</code> containing the properties to match.		 * @param	strict		Defines if the check must be strict or not.		 * @return	The first <code>ApplicationFile</code> instance that matches the properties		 * 			or <code>null</code>.		 * 					 * @see		ch.capi.net.ILoadableFile#properties	ILoadableFile.properties		 * @see		ch.capi.data.IMap#matches()				IMap.matches()		 */		public function getFileByProps(props:Object, strict:Boolean=false):ApplicationFile		{			var files:Array = _files.values();			for each(var app:ApplicationFile in files)			{				var lf:ILoadableFile = app.loadableFile;				if (lf != null)				{					var m:IMap = lf.properties.variables;					if (m.matches(props, strict)) return app;				}			}						return null;		}		/**		 * Retrieves all the files that matche the specified properties.		 * 		 * @param	props		An <code>Object</code> containing the properties to match.		 * @param	strict		Defines if the check must be strict or not.		 * @return	An <code>Array</code> of <code>ILoadableFile</code> that matche the 		 * 			specified properties.		 * 					 * @see		ch.capi.net.ILoadableFile#properties	ILoadableFile.properties		 * @see		ch.capi.data.IMap#matches()				IMap.matches()		 */		public function getFilesByProps(props:Object, strict:Boolean=false):Array		{			var results:Array = new Array();			var files:Array = _files.values();			for each(var app:ApplicationFile in files)			{				var lf:ILoadableFile = app.loadableFile;				if (lf != null)				{					var m:IMap = lf.properties.variables;					if (m.matches(props, strict)) results.push(app);				}			}						return results;		}
		/**		 * Add the specified <code>ApplicationFile</code> to the current <code>ApplicationContext</code>. If		 * the context of the <code>ApplicationFile</code> is already specified, this method will throw an error. 		 * <p>This method will also check that all dependencies of the specified <code>ApplicationFile</code> are		 * already into the current <code>ApplicationContext</code>. If they are in no <code>ApplicationContext</code>		 * they will be added into the current one, otherwise an error will be thrown.</p>		 * 		 * @param	file	The <code>ApplicationFile</code>.		 * @throws	ArgumentError	If the <code>ApplicationContext</code> of the file is not <code>null</code>.		 * @throws	ArguemntError	If one of the dependencies is in another <code>ApplicationContext</code>.		 * @throws	NameAlreadyExistsError	If the name of the <code>ApplicationFile</code> is already taken.		 */		public function addFile(file:ApplicationFile):void		{			if (file.applicationContext != null) throw new ArgumentError("The ApplicationContext of the file '"+file.name+"' " +																			"is already defined");			if (_files.containsKey(file.name)) throw new NameAlreadyExistsError("File name '"+file.name+"' already exists");						/*			 * Try to add the dependencies of the file. If the dependency is already into			 * the current context, then the 'add' will not be recursive. 			 */			var dependencies:Array = file.dependencies;			for each(var dependency:ApplicationFile in dependencies)			{				if (dependency.applicationContext == null) addFile(dependency);				else if (dependency.applicationContext != this) throw new ArgumentError("A dependency of the file '"+file.name+"'" +																			 " is already in another ApplicationContext");			}						//update the file data			_files.put(file.name, file);			file.setContext(this);		}				/**		 * Remove the specified <code>ApplicationFile</code> from the <code>ApplicationContext</code>. All the		 * <code>ApplicationFile</code> having the specified file as dependency, will have it removed.		 * <p>If the recursiveRemoval argument is set to <code>true</code>, then all the dependencies of the specified		 * file will also be removed from the <code>ApplicationContext</code>. In the other case, all the dependencies		 * of the specified <code>ApplicationFile</code> are cleared.</p>		 * 		 * @param	file				The <code>ApplicationFile</code> to remove.		 * @param	recursiveRemoval	If the removal must be applied on all the dependencies of the file.		 * @throws	flash.errors.IllegalOperationError	If the <code>file</code> is not into the <code>ApplicationContext</code>.			 */		public function removeFile(file:ApplicationFile, recursiveRemoval:Boolean=false):void		{			if (file.applicationContext != this) throw new IllegalOperationError("The file "+file+" is not into the specified ApplicationContext");						//remove the file			file.setContext(null);			_files.remove(file.name);						//remove the dependency from all the other files.				var files:Array = _files.values();			for each(var appFile:ApplicationFile in files)			{				appFile.removeDependency(file);			}						//if it is recursive, then apply on all the file dependencies			//otherwise, just remove the dependencies of the removed file			var dependencies:Array = file.dependencies;			for each(var dependency:ApplicationFile in dependencies)			{				if (recursiveRemoval) removeFile(dependency, true);				else file.removeDependency(dependency);			}		}		/**		 * Enumerates all the global <code>ApplicationFile</code> contained into the <code>ApplicationContext</code>.		 * 		 * @return	An <code>Array</code> containing the enumerated <code>ApplicationFile</code>.		 */		public function enumerateGlobals():Array		{			var c:Array = new Array();			var f:Array = _files.values();			for each(var a:ApplicationFile in f)			{				if (a.global) c.push(a);			}						return c;		}		/**		 * Enumerates all the <code>ApplicationFile</code> contained into the <code>ApplicationContext</code>.		 * 		 * @param	excludeGlobalFiles		Defines if the global files must be excluded.		 * @return	An <code>Array</code> containing the enumerated <code>ApplicationFile</code>.		 */		public function enumerateAll(excludeGlobalFiles:Boolean=false):Array		{			var c:Array = new Array();			var f:Array = _files.values();			for each(var a:ApplicationFile in f)			{				if (!a.global || !excludeGlobalFiles) c.push(a);			}						return c;		}				/**		 * Enumerates all the <code>ApplicationFile</code> that are on the root of the tree. That means that no		 * other <code>ApplicationFile</code> have it as dependency.		 * 		 * @return	An <code>Array</code> containing all the <code>ApplicationFile</code> that are not in any dependency.		 * @see		#enumerateLeaves() enumerateLeaves()			 */		public function enumerateRoots():Array		{			var roots:Array = new Array();			var files:Array = _files.values();						for each(var a:ApplicationFile in files)			{				if (a.getParents().length == 0) roots.push(a);			}						return roots;		}				/**		 * Enumerates all the <code>ApplicationFile</code> that doesn't have any dependency.		 * 		 * @return	An <code>Array</code> containing all the <code>ApplicationFile</code> that doesn't have any dependency.		 * @see		#enumerateRoots()	enumerateRoots()		 */		public function enumerateLeaves():Array		{			var leaves:Array = new Array();			var files:Array = _files.values();						for each(var a:ApplicationFile in files)			{				if (a.dependencies.length == 0) leaves.push(a);			}						return leaves;		}				/**		 * Clear all the <code>ApplicationFile</code> of the <code>ApplicationContext</code>. The context property of the		 * <code>ApplicationFile</code> instances are reset to <code>null</code> to let the Garbate Collector take care of		 * the <code>ApplicationContext</code> instance.		 */		public function clear():void		{			var files:Array = _files.keys();			for each (var file:ApplicationFile in files)			{				file.setContext(null);			}						_files.clear();		}				/**		 * Print all the <code>ApplicationFile</code> instances contained into the current <code>ApplicationContext</code>.		 * This method is mainly for debug purposes but can also be used online.		 * 		 * @param	traceResult	Defines if the result must be traced.		 * @return	A <code>String</code> of all the <code>ApplicationFile</code>.		 */		public function printFiles(traceResult:Boolean=true):String		{			var builder:String = "ApplicationContext[\n";			for each (var file:ApplicationFile in enumerateAll())			{				builder += "  "+file.toString()+"\n";			}			builder += "]";						if (traceResult) trace(builder);						return builder;		}				/**		 * Returns a <code>String</code> presentation of the <code>ApplicationContext</code>.		 * 		 * @return	A <code>String</code> representation of the <code>ApplicationContext</code>. 		 * @see		#printFiles()	printFiles()		 */		public function toString():String		{			return printFiles(false);		}				//-----------------//		//Protected methods//		//-----------------//				//---------------//		//Private methods//		//---------------//	}}