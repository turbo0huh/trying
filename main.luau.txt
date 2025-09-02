local Scripts = {
	{
		PlacesIds = {2753915549, 4442272183, 7449423635},
		Path = "BloxFruits.luau"
	},
	{
		PlacesIds = {10260193230},
		Path = "MemeSea.luau"
	}
}

local fetcher, urls = {}, {}

urls.Owner = "https://raw.githubusercontent.com/tlredz/";
urls.Repository = `{ urls.Owner }Scripts/refs/heads/main/`;
urls.Translator = `{ urls.Repository }Translator/`;
urls.Utils = `{ urls.Repository }Utils/`;

do
	local _ENV = (getgenv or getrenv or getfenv)()
	
	if _ENV.rz_error_message then
		_ENV.rz_error_message:Destroy()
	end
	
	local identifyexecutor = identifyexecutor or (function() return "Unknown" end)
	
	local function CreateMessageError(Text)
		_ENV.loadedFarm = nil
		_ENV.OnFarm = false
		
		local Message = Instance.new("Message", workspace)
		Message.Text = string.gsub(Text, urls.Owner, "")
		_ENV.rz_error_message = Message
		
		error(Text, 2)
	end
	
	local function formatUrl(Url)
		for string, path in urls do
			if Url:find("{" .. string .. "}") then
				return Url:gsub("{" .. string .. "}", path)
			end
		end
		
		return Url
	end
	
	function fetcher.get(Url)
		local success, response = pcall(function()
			return game:HttpGet(formatUrl(Url))
		end)
		
		if success then
			return response
		else
			CreateMessageError(`[1] [{ identifyexecutor() }] failed to get http/url/raw: { Url }\n>>{ response }<<`)
		end
	end
	
	function fetcher.load(Url, concat)
		local raw = fetcher.get(Url) .. (if concat then concat else "")
		local execute, error = loadstring(raw)
		
		if type(execute) ~= "function" then
			CreateMessageError(`[2] [{ identifyexecutor() }] sintax error: { Url }\n>>{ error }<<`)
		else
			return execute
		end
	end
end

local function IsPlace(Data)
	if Data.PlacesIds and table.find(Data.PlacesIds, game.PlaceId) then
		return true
	elseif Data.GameId and game.GameId == Data.GameId then
		return true
	end
	
	return false
end

for _, Data in Scripts do
	if IsPlace(Data) then
		return fetcher.load("{Repository}Games/" .. Data.Path)(fetcher, ...)
	end
end
