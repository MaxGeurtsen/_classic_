Comment = {}

function Comment:Set(playerName, comment)
    DebugHelper:Print("Comment:Set("..playerName..", "..comment..")")
    SavedComments[playerName] = comment
end

function Comment:Get(playerName)
    DebugHelper:Print("Comment:Get("..playerName..")")
    return SavedComments[playerName] or ""
end

function Comment:Delete(playerName)
    DebugHelper:Print("Comment:Delete("..playerName..")")
    if SavedComments[playerName] then
        SavedComments[playerName] = nil
    end
end

function Comment:Reset()
    SavedComments = {}
end

if SavedComments == nil then SavedComments = {} end