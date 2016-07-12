local nsdict = require 'nsdict'
APP = require 'app'

return function()
    local app_folders = SCANDIR("/Applications")
    local apps = {}
    for i,v in ipairs(app_folders) do
        local folder = "/Applications/"..v
        local file = FILE_EXISTS(folder.."/Info.plist")
                  or FILE_EXISTS(folder.."/Contents/Info.plist")
        if file then
            local dict = nsdict(file)
            if dict.SBAppTags and dict.SBAppTags[1] == 'hidden' then
                --continue
            else
                local identifier = dict.CFBundleIdentifier
                local icon = dict.CFBundleIconFiles and dict.CFBundleIconFiles[1]
                if identifier then
                    table.insert(apps, APP(identifier, folder, icon))
                end
            end
        end
    end

    return apps
end
