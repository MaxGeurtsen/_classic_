local _, CLM = ...

-- local UTILS = CLM.UTILS

local Profile = {}

function Profile:New(entry, name, class, main)
    local o = {}

    setmetatable(o, self)
    self.__index = self

    o._GUID = ""
    o.entry = entry
    o.name  = (name ~= nil) and tostring(name) or ""
    o.class = (class ~= nil) and tostring(class) or ""
    o.main  = (main ~= nil) and tostring(main) or ""
    o.version = {
        major = 0,
        minor = 0,
        patch = 0,
        changeset = ""
    }
    o:SetSpec()
    o.alts = {}

    o._versionString = CLM.L["Unknown"]

    return o
end

function Profile:Name()
    return self.name
end

function Profile:Class()
    return self.class
end

function Profile:Spec()
    return self.spec
end

function Profile:SetSpec(one, two, three)
    self.spec = {
        one = one or 0,
        two = two or 0,
        three = three or 0
    }
end

function Profile:SpecString()
    return self.spec.one .. "/" .. self.spec.two .. "/" .. self.spec.three
end

function Profile:Main()
    return self.main
end

function Profile:SetMain(main)
    self.main = main
end

function Profile:ClearMain()
    self.main = ""
end

function Profile:Alts()
    return self.alts
end

function Profile:HasAlts()
    return not rawequal(next(self.alts), nil)
end

function Profile:AddAlt(GUID)
    if not self.alts[GUID] then
        self.alts[GUID] = true
    end
end

function Profile:RemoveAlt(GUID)
    if self.alts[GUID] then
        self.alts[GUID] = nil
    end
end

function Profile:SetGUID(GUID)
    self._GUID = GUID
end

function Profile:GUID()
    return self._GUID
end

function Profile:SetVersion(major, minor, patch, changeset)
    self.version.major = tonumber(major) or 0
    self.version.minor = tonumber(minor) or 0
    self.version.patch = tonumber(patch) or 0
    changeset = changeset or ""
    self.version.changeset = tostring(changeset)

    if self.version.changeset == "" then
        self._versionString = string.format("v%d.%d.%d", self.version.major, self.version.minor, self.version.patch)
    else
        self._versionString = string.format("v%d.%d.%d-%s", self.version.major, self.version.minor, self.version.patch, self.version.changeset)
    end

end

function Profile:Version()
    return self.version
end

function Profile:VersionString()
    return self._versionString
end

function Profile:Entry()
    return self.entry
end

CLM.MODELS.Profile = Profile