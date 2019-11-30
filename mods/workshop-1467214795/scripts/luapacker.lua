--This dependency path is really dumb. How are dependency usually handled? -M
-- local LibDeflate = require( "LibDeflate" )

--Pack all contents of the files listed in "files" to a file "filename", remembering the original paths.
local function Pack( root, files, filename )
	assert(filename ~= nil, "Did not specify filename to pack as!")
	assert(type(root) == "string", "Did not provide a path to pack ".. filename .." from!")
	assert(type(files) == "table", "Did not provide a list of files to pack into ".. filename .."!")
	
	local pakfile = io.open(root .. filename ..".lpak", "w")
	-- local tmpfile = io.tmpfile() --doesn't return anything for some reason
	local srcfile
	
	for i, v in ipairs(files) do
		srcfile = io.open(root .. v, "r")
		pakfile:write("%%+%%"..v.."%%-%%") --I assume this is a suitable kind of breaker for testing -M
		pakfile:write(srcfile:read("*a"))
		srcfile:close()
	end
	
	-- pakfile:write(LibDeflate:CompressZlib(tmpfile:read("*a")))
	-- tmpfile:close()
	pakfile:close()
	
	return true
end

--Unpack the contents of the file "filename" to the "root" directory
local function Unpack( root, filename )
	assert(filename ~= nil, "Did not specify filename to unpack!")
	assert(type(root) == "string", "Did not provide a path to unpack ".. filename .." to!")
	
	local pakfile = io.open(root .. filename ..".lpak", "r")
	if not pakfile then print("ERROR: Could not find file \"".. filename .."\" for Unpack()") return false end
	local pakstring = pakfile:read("*a")
	-- pakstring = LibDeflate:DecompressZlib(pakstring)
	pakfile:close()
	
	local targetfile
	local filepath
	local break1start, break1end = pakstring:find("%%+%%",1,true)
	local break2start, break2end
	while break1start do
		break2start, break2end = pakstring:find("%%-%%",1,true)
		filepath = pakstring:sub(break1end + 1, break2start - 1)
		break1start, break1end = pakstring:find("%%+%%", break2end ,true) or (pakstring:len() + 1)
		targetfile = io.open(root .. filepath, "w")
		targetfile:write( pakstring:sub(break2end + 1, break1start - 1) )
		targetfile:close()
		pakstring = pakstring:sub(break1start)
		break1start, break1end = pakstring:find("%%+%%",1,true)
	end
	
	return true
end

--Compare "version" to a local cache file.
--If the cache does not exist or its version is below this one, unpack.
--After unpacking, write that cache file with this version number.
local function UnpackForVersion( root, filename, version )
	assert(filename ~= nil, "Did not specify filename to unpack!")
	assert(type(root) == "string", "Did not provide a path to unpack ".. filename .." to!")
	assert(version ~= nil, "Did not specify version to unpack ".. filename .."!")
	
	local versioncache = io.open(root .. filename .."versioncache", "r")
	
	if (not versioncache or versioncache:read() ~= version) and Unpack( root, filename ) then --TODO actually compare versions
		if versioncache then
			versioncache:close()
		end
		versioncache = io.open(root .. filename .."versioncache", "w")
		versioncache:write(tostring(version))
	end
	
	if versioncache then versioncache:close() end
	
end

return {
	Pack = Pack,
	Unpack = Unpack,
	UnpackForVersion = UnpackForVersion,
}