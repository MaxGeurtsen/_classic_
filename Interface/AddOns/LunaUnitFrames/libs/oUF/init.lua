local parent, ns = ...
ns.oUF = {}
ns.oUF.Private = {}

ns.oUF.isClassic = select(4, GetBuildInfo()) < 20000
ns.oUF.isClassicTBC = select(4, GetBuildInfo()) < 30000 and not ns.oUF.isClassic
ns.oUF.isRetail = not ns.oUF.isClassic and not ns.oUF.isClassicTBC
