-- zlpds
local Weave = {}

local RunService = game:GetService("RunService")

function Weave.new()
	local self = setmetatable({}, { __index = Weave })
	self.modules = {}
	self.handlers = {
		Heartbeat = {},
		RenderStepped = {},
		Stepped = {}
	}
	self.messageBus = {}
	self.logs = {}
	return self
end

function Weave:log(message, level)
	level = level or "INFO"
	print(string.format("[%s] %s", level, message))
	table.insert(self.logs, {level, message})
end

function Weave:sendMessage(channel, message)
	if not self.messageBus[channel] then
		self.messageBus[channel] = {}
	end

	for _, callback in ipairs(self.messageBus[channel]) do
		callback(message)
	end
end

function Weave:subscribeToChannel(channel, callback)
	if not self.messageBus[channel] then
		self.messageBus[channel] = {}
	end
	table.insert(self.messageBus[channel], callback)
end

function Weave:loadFolder(folder)
	if not folder or not folder:IsA("Folder") then
		self:log("Invalid folder provided.", "ERROR")
		return
	end

	local moduleFiles = {}
	for _, moduleScript in ipairs(folder:GetChildren()) do
		if moduleScript:IsA("ModuleScript") then
			table.insert(moduleFiles, moduleScript)
		end
	end

	table.sort(moduleFiles, function(a, b)
		local aLoadOrder = require(a).LoadOrder or 1
		local bLoadOrder = require(b).LoadOrder or 1
		return aLoadOrder > bLoadOrder
	end)

	for _, moduleScript in ipairs(moduleFiles) do
		local module = require(moduleScript)

		if module.init then
			module:init(self)
		end

		self:mergeModuleHandlers(module)
		table.insert(self.modules, module)
	end

	self:startRunServiceConnections()
end

function Weave:mergeModuleHandlers(module)
	for _, eventName in ipairs({"Heartbeat", "RenderStepped", "Stepped"}) do
		if module[eventName] then
			table.insert(self.handlers[eventName], module[eventName])
		end
	end
end

function Weave:startRunServiceConnections()
	RunService.Heartbeat:Connect(function(dt)
		for _, handler in ipairs(self.handlers.Heartbeat) do
			handler(dt)
		end
	end)

	RunService.RenderStepped:Connect(function(dt)
		for _, handler in ipairs(self.handlers.RenderStepped) do
			handler(dt)
		end
	end)

	RunService.Stepped:Connect(function(dt)
		for _, handler in ipairs(self.handlers.Stepped) do
			handler(dt)
		end
	end)
end

function Weave:cleanup()
	for _, module in ipairs(self.modules) do
		if module.cleanup then
			module:cleanup()
		end
	end
end

return Weave
