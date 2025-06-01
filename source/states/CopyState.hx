/*
 * Copyright (C) 2025 Mobile Porting Team
 *
 * Permission is hereby granted, free of charge, to any person obtaining a
 * copy of this software and associated documentation files (the "Software"),
 * to deal in the Software without restriction, including without limitation
 * the rights to use, copy, modify, merge, publish, distribute, sublicense,
 * and/or sell copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
 * DEALINGS IN THE SOFTWARE.
 */

package states;

#if COPYSTATE_ALLOWED
import states.TitleState;
import lime.utils.Assets as LimeAssets;
import openfl.utils.Assets as OpenFLAssets;
import openfl.utils.ByteArray;
import haxe.io.Path;
import flixel.ui.FlxBar;
import flixel.ui.FlxBar.FlxBarFillDirection;
import lime.system.ThreadPool;
import flixel.text.FlxText;
import sys.FileSystem;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import flixel.FlxCamera;

/**
 * CopyState
 *
 * Esta pantalla se encarga de mover mods desde los assets hasta la carpeta de mods, mientras te bombardea con comentarios acelerados sobre el mod actual y el archivo en cuestión. 
 * Si ves esto, probablemente tenías ganas de ver barras de progreso y chistes innecesarios.
 */
class CopyState extends MusicBeatState
{
	private static final textFilesExtensions:Array<String> = ['ini', 'txt', 'xml', 'hxs', 'hx', 'lua', 'json', 'frag', 'vert'];
	public static final IGNORE_FOLDER_FILE_NAME:String = "CopyState-Ignore.txt";
	private static var directoriesToIgnore:Array<String> = [];
	public static var locatedFiles:Array<String> = [];
	public static var maxLoopTimes:Int = 0;

	public var loadingImage:FlxSprite;
	public var loadingBar:FlxBar;
	public var loadedText:FlxText;
	public var logText:FlxText;
	public var headline:FlxText;
	public var thread:ThreadPool;
	public var tipText:FlxText;
	public var bg:FlxSprite;
	public var cam:FlxCamera;

	var failedFilesStack:Array<String> = [];
	var failedFiles:Array<String> = [];
	var shouldCopy:Bool = false;
	var canUpdate:Bool = true;
	var loopTimes:Int = 0;
	var tips:Array<String> = [
		"¿Mods con nombre raro? El menú los arregla (a veces).",
		"Esta barra sube más lento si la miras fijo. Pruébalo.",
		"¿Agrega los mods? Sí. ¿Hace milagros? Solo los domingos.",
		"Si los mods aparecen, dale las gracias a esta pantalla.",
		"No garantizamos mods libres de bugs. Pero sí libres.",
		"Si todo explota, siempre puedes culpar al Ikvi de mierda.",
		"¡Sorpresa! Los mods no se ponen solos... espera, sí.",
		"¿Ves mods nuevos? No fue magia, fue CopyState.",
		"Like si eres fnf",
		"¿Por qué hay una carpeta que se llama 'sexmod-opt'? Nadie lo sabe...",
		"Tip: Si hay más mods que amigos, deberías salir más."
	];

	override function create()
	{
		cam = new FlxCamera();
		FlxG.cameras.reset(cam);

		bg = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.fromRGB(32, 30, 48));
		add(bg);
		FlxTween.color(
			bg,
			2,
			FlxColor.fromRGB(32, 30, 48),
			FlxColor.fromRGB(60, 60, 110),
			{ type: FlxTween.PINGPONG }
		);

		locatedFiles = [];
		maxLoopTimes = 0;
		checkExistingFiles();
		if (maxLoopTimes <= 0)
		{
			MusicBeatState.switchState(new TitleState());
			return;
		}

		headline = new FlxText(0, 32, FlxG.width, "¡Agregando los mods al juego!", 27);
		headline.setFormat(Paths.font("vcr.ttf"), 27, FlxColor.CYAN, CENTER);
		add(headline);
		FlxTween.tween(headline, {y: 26}, 1, {type: FlxTween.PINGPONG, ease: flixel.tweens.FlxEase.quadInOut});

		tipText = new FlxText(0, FlxG.height - 60, FlxG.width, tips[Std.random(tips.length)], 15);
		tipText.setFormat(Paths.font("vcr.ttf"), 15, FlxColor.LIME, CENTER);
		add(tipText);
		new FlxTimer().start(3.5, (timer) -> {
			tipText.text = tips[Std.random(tips.length)];
		}, 0);

		#if android
		createAllFoldersForAllMods();
		#end

		CoolUtil.showPopUp(
			"Los mods están a punto de mudarse a la carpeta necesaria para que el juego los reconozca. ¿Preparado para ver nombres impronunciables y rutas larguísimas? Yo tampoco.",
			"Agregando mods"
		);

		shouldCopy = true;

		loadingImage = new FlxSprite(0, 0, Paths.image('funkay'));
		loadingImage.setGraphicSize(0, FlxG.height);
		loadingImage.updateHitbox();
		loadingImage.screenCenter();
		loadingImage.alpha = 0.32;
		add(loadingImage);

		loadingBar = new FlxBar(0, FlxG.height - 26, FlxBarFillDirection.LEFT_TO_RIGHT, FlxG.width, 26);
		loadingBar.setRange(0, maxLoopTimes);
		loadingBar.createFilledBar(FlxColor.BLACK, FlxColor.YELLOW);
		add(loadingBar);

		loadedText = new FlxText(loadingBar.x, loadingBar.y + 4, FlxG.width, '', 17);
		loadedText.setFormat(Paths.font("vcr.ttf"), 17, FlxColor.WHITE, CENTER);
		add(loadedText);

		logText = new FlxText(0, loadingBar.y - 55, FlxG.width, '', 15);
		logText.setFormat(Paths.font("vcr.ttf"), 15, FlxColor.YELLOW, CENTER);
		add(logText);

		thread = new ThreadPool(0, CoolUtil.getCPUThreadsCount());
		thread.doWork.add(function(poop)
		{
			for (file in locatedFiles)
			{
				loopTimes++;
				var modName = extractModName(file);
				logText.text = getExcitedMessage(file, modName, loopTimes, maxLoopTimes);
				copyAsset(file);
			}
		});
		new FlxTimer().start(0.6, (tmr) ->
		{
			thread.queue({});
		});

		super.create();
	}

	override function update(elapsed:Float)
	{
		if (shouldCopy)
		{
			if (loopTimes >= maxLoopTimes && canUpdate)
			{
				if (failedFiles.length > 0)
				{
					CoolUtil.showPopUp(
						"Ni modo, estos archivos se rebelaron y no se agregaron:\n" + failedFiles.join('\n'),
						'Hasta aquí llegaron esos mods'
					);
					final folder:String = #if android StorageUtil.getExternalStorageDirectory() + #else Sys.getCwd() + #end 'logs/';
					if (!FileSystem.exists(folder))
						FileSystem.createDirectory(folder);
					File.saveContent(folder + Date.now().toString().replace(' ', '-').replace(':', "'") + '-CopyState' + '.txt', failedFilesStack.join('\n'));
				}

				FlxG.sound.play(Paths.sound('confirmMenu')).onComplete = () ->
				{
					MusicBeatState.switchState(new TitleState());
				};

				canUpdate = false;
			}

			if (loopTimes >= maxLoopTimes)
				loadedText.text = "¡Lista! Revisa el menú de mods o el freeplay si tienes alguna duda.";
			else
				loadedText.text = '$loopTimes/$maxLoopTimes archivos agregados.';

			loadingBar.percent = Math.min((loopTimes / maxLoopTimes) * 100, 100);
		}
		super.update(elapsed);
	}

	// Saca el nombre del mod de una ruta estilo mods/loquesea/archivo...
	function extractModName(file:String):String
	{
		if (file.startsWith("mods/")) {
			var parts = file.substr(5).split("/");
			if (parts.length > 0 && parts[0].length > 0) {
				// Normalización: quita espacios, mayúsculas raras y variantes comunes
				var n = parts[0].trim().toLowerCase();
				n = n.replace("mod_", "").replace("pack", "").replace("final", "").replace("_v2", "").replace("_def", "");
				n = ~/[^a-z0-9]/g.replace(n, ""); // solo letras y números
				if (n.length > 0)
					return n.charAt(0).toUpperCase() + n.substr(1);
			}
		}
		return "Desconocido";
	}

	function getExcitedMessage(file:String, modName:String, current:Int, total:Int):String
	{
		// Mensaje hiperactivo y con referencias al mod
		var frases = [
			"¡Bien! El mod '" + modName + "' está en camino.",
			"¿Listo para '" + modName + "'? Porque este archivo lo está.",
			"Pasando cosas de '" + modName + "' al lugar donde deben estar.",
			"¿Ese archivo? Claro, parte de '" + modName + "'. ¡No puede faltar!",
			"'"+modName+"' está empacando archivos. Sí, todos.",
			"¿Sabías que '" + modName + "' tiene más archivos que sentido común?",
			"Archivo nuevo para '" + modName + "'. ¿Qué podría salir mal?",
			"Agregando para '" + modName + "'. ¿O era para mods/raros/? Da igual.",
			"¡Que no falte nada de '" + modName + "'! Bueno, casi nada.",
			"¿Por qué tantos archivos en '" + modName + "'? Pregunta seria."
		];
		var detalle = "Archivo: " + Path.withoutDirectory(file);
		var idx = (modName.length * 3 + current + file.length) % frases.length;
		var main = frases[idx];
		var extra = [
			"Esto va rápido. O no.",
			"No, no se está trabando. Es tu imaginación.",
			"Si un mod no aparece, pues no se we.",
			"¿Cuántos archivos faltan? Mejor no lo pienses.",
			"¿Te aburre la barra? A mí también.",
			"Siguiente archivo, siguiente esperanza.",
			"¿Ya te suscribiste a Jere? Hacelo o los mods se revelan.",
			"Nadie lee estos mensajes, ¿verdad?",
			"Archivo en movimiento. No lo interrumpas.",
			"Esperate tantito"
		];
		var ext = extra[(file.length + current * 7) % extra.length];
		return main + "\n" + detalle + " (" + current + "/" + total + ")\n" + ext;
	}

	public function createAllFoldersForAllMods() {
		var modPrefixes = new Map<String, Bool>();
		for (asset in OpenFLAssets.list()) {
			if (asset.startsWith("mods/")) {
				var slashIdx = asset.indexOf("/", 5);
				if (slashIdx != -1) {
					var modName = asset.substr(0, slashIdx + 1);
					modPrefixes.set(modName, true);
				}
			}
		}
		for (modPrefix in modPrefixes.keys()) {
			var targetBase = StorageUtil.getExternalStorageDirectory() + modPrefix;
			createAllFoldersFromAssets(modPrefix, targetBase);
		}
	}

	public function createAllFoldersFromAssets(modPrefix:String, targetBase:String) {
		for (asset in OpenFLAssets.list()) {
			if (asset.startsWith(modPrefix)) {
				var relativePath = asset.substr(modPrefix.length);
				if (relativePath.indexOf("/") != -1) {
					var folderPath = relativePath.substr(0, relativePath.lastIndexOf("/"));
					var fullTarget = Path.join([targetBase, folderPath]);
					if (!FileSystem.exists(fullTarget)) {
						FileSystem.createDirectory(fullTarget);
					}
				}
			}
		}
	}

	public function ensurePathExists(path:String) {
		var parts = path.split("/");
		var build = "";
		for (i in 0...parts.length-1) {
			build += parts[i] + "/";
			if (!FileSystem.exists(build)) FileSystem.createDirectory(build);
		}
	}

	public function copyAsset(file:String)
	{
		if (!FileSystem.exists(file))
		{
			var directory = Path.directory(file);
			if (!FileSystem.exists(directory))
				FileSystem.createDirectory(directory);
			try
			{
				if (OpenFLAssets.exists(getFile(file)))
				{
					if (textFilesExtensions.contains(Path.extension(file)))
						createContentFromInternal(file);
					else
					{
						var path:String = '';
						#if android
						if (file.startsWith('mods/'))
							path = StorageUtil.getExternalStorageDirectory() + file;
						else
						#end
							path = file;
						ensurePathExists(path);
						File.saveBytes(path, getFileBytes(getFile(file)));
					}
				}
				else
				{
					failedFiles.push(getFile(file) + " (File Dosen't Exist)");
					failedFilesStack.push('Asset ${getFile(file)} does not exist.');
				}
			}
			catch (e:haxe.Exception)
			{
				failedFiles.push('${getFile(file)} (${e.message})');
				failedFilesStack.push('${getFile(file)} (${e.stack})');
			}
		}
	}

	public function createContentFromInternal(file:String)
	{
		var fileName = Path.withoutDirectory(file);
		var directory = Path.directory(file);
		#if android
		if (fileName.startsWith('mods/'))
			directory = StorageUtil.getExternalStorageDirectory() + directory;
		#end
		try
		{
			var fileData:String = OpenFLAssets.getText(getFile(file));
			if (fileData == null)
				fileData = '';
			var fullPath = Path.join([directory, fileName]);
			ensurePathExists(fullPath);
			File.saveContent(fullPath, fileData);
		}
		catch (e:haxe.Exception)
		{
			failedFiles.push('${getFile(file)} (${e.message})');
			failedFilesStack.push('${getFile(file)} (${e.stack})');
		}
	}

	public function getFileBytes(file:String):ByteArray
	{
		switch (Path.extension(file).toLowerCase())
		{
			case 'otf' | 'ttf':
				return ByteArray.fromFile(file);
			default:
				return OpenFLAssets.getBytes(file);
		}
	}

	public static function getFile(file:String):String
	{
		if (OpenFLAssets.exists(file))
			return file;

		@:privateAccess
		for (library in LimeAssets.libraries.keys())
		{
			if (OpenFLAssets.exists('$library:$file') && library != 'default')
				return '$library:$file';
		}

		return file;
	}

	public static function checkExistingFiles():Bool
	{
		locatedFiles = OpenFLAssets.list();

		var assets = locatedFiles.filter(folder -> folder.startsWith('assets/'));
		var mods = locatedFiles.filter(folder -> folder.startsWith('mods/'));
		locatedFiles = assets.concat(mods);
		locatedFiles = locatedFiles.filter(file -> !FileSystem.exists(file));
		#if android
		for (file in locatedFiles)
			if (file.startsWith('mods/'))
				locatedFiles = locatedFiles.filter(file -> !FileSystem.exists(StorageUtil.getExternalStorageDirectory() + file));
		#end

		var filesToRemove:Array<String> = [];

		for (file in locatedFiles)
		{
			if (filesToRemove.contains(file))
				continue;

			if(file.endsWith(IGNORE_FOLDER_FILE_NAME) && !directoriesToIgnore.contains(Path.directory(file)))
				directoriesToIgnore.push(Path.directory(file));

			if (directoriesToIgnore.length > 0)
			{
				for (directory in directoriesToIgnore)
				{
					if (file.startsWith(directory))
						filesToRemove.push(file);
				}
			}
		}

		locatedFiles = locatedFiles.filter(file -> !filesToRemove.contains(file));

		maxLoopTimes = locatedFiles.length;

		return (maxLoopTimes <= 0);
	}
}
#end
