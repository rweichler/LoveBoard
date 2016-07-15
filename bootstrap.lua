function FILE_EXISTS(name)
   local f = io.open(name, 'r')
   if f then
       io.close(f)
       return name
   end
end


local uname = os.capture([[uname]])

local funcs = {}
funcs.Darwin = function()
    local file = FILE_EXISTS(GAME_DIRECTORY.."love.app/Contents/MacOS/love")
    if file then
        os.execute(file..' '..GAME_DIRECTORY)
    else -- install love2d
        local file = "love-0.10.1-macosx-x64.zip"
        print("downloading love.app")
        os.execute([[curl -O --progress-bar http://cydia.r333d.com/misc/]]..file)
        os.execute([[unzip ]]..file..[[ -d ]]..GAME_DIRECTORY..[[> /dev/null]])
        os.execute([[rm ]]..file)
        print("Done! Run "..GAME_DIRECTORY.."main.lua again.")
    end
end

for k,v in pairs(funcs) do
    if string.match(uname, k) then
        v()
        return
    end
end

print("Warning: This has only been tested for OS X.")
print("Go to http://love2d.org and download it. Open it with this folder.")
