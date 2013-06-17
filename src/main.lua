math.randomseed( os.time() )

git,git_count = "missing git.lua",0
pcall( function() return require("git") end );