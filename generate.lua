do
	dofile("WoWAPI.lua")

	Ovale = {}
	LoadAddonFile("OvaleLexer.lua")
	LoadAddonFile("OvaleSimulationCraft.lua")
	local OvaleSimulationCraft = Ovale.OvaleSimulationCraft

	local profilesDirectory = "..\\SimulationCraft\\profiles\\Tier16H"
	local outputDirectory = "profiles"

	local saveInput = io.input()
	local saveOutput = io.output()

	local dir = io.popen("dir /b " .. profilesDirectory)
	os.execute("mkdir " .. outputDirectory)
	for filename in dir:lines() do
		if string.match(filename, "^[A-Z]") then
			local inputName = string.gsub(profilesDirectory, "\\", "/") .. "/" .. filename
			io.input(inputName)
			local simcStr = io.read("*all")
			if not string.find(simcStr, "optimal_raid=") then
				local simc = OvaleSimulationCraft(simcStr)
				simc.simcComments = true

				local outputFileName = string.gsub(filename, ".simc", ".txt")
				print("Generating " .. outputFileName)
				local outputName = outputDirectory .. "/" .. outputFileName
				io.output(outputName)
				io.write(table.concat(simc:GenerateScript(), "\n"))
			end
		end
	end

	io.input(saveInput)
	io.output(saveOutput)
end