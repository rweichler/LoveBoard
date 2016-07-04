local nsdict = require 'nsdict'
APP = require 'app'

return function()
    local app_folders = SCANDIR("/Applications")
    local apps = {}
    for i,v in ipairs(app_folders) do
        local file = FILE_EXISTS("/Applications/"..v.."/Info.plist")
                  or FILE_EXISTS("/Applications/"..v.."/Contents/Info.plist")
        if file then
            local dict = nsdict(file)
            local identifier = dict.CFBundleIdentifier
            if identifier then
                table.insert(apps, APP(identifier))
            end
        end
    end

    return apps
end
