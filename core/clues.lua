local Aye = Aye;

-- Collect /p chat clues
Aye.modules.CoSpy.events.CHAT_MSG_PARTY = function(message)
	Aye.modules.CoSpy.events.CHAT_MSG_PARTY_ALL(message);
end;
Aye.modules.CoSpy.events.CHAT_MSG_PARTY_LEADER = function(message)
	Aye.modules.CoSpy.events.CHAT_MSG_PARTY_ALL(message);
end;

-- Collect /i chat clues
Aye.modules.CoSpy.events.CHAT_MSG_INSTANCE_CHAT = function(message)
	Aye.modules.CoSpy.events.CHAT_MSG_PARTY_ALL(message);
end;
Aye.modules.CoSpy.events.CHAT_MSG_INSTANCE_CHAT_LEADER = function(message)
	Aye.modules.CoSpy.events.CHAT_MSG_PARTY_ALL(message);
end;

-- Collect /s chat clues
Aye.modules.CoSpy.events.CHAT_MSG_SAY = function(message)
	Aye.modules.CoSpy.events.CHAT_MSG_PARTY_ALL(message);
end;

-- Collect DBM clues
-- DBM-Party-Legion/CourtofStars/CoSTrash integration
Aye.modules.CoSpy.events.CHAT_MSG_ADDON = function(...)
	local prefix, message, _, sender = ...;
	sender = sender:match("^([^%-]+)-");
	
	-- Addon			DBM
	-- Event Prefix		D4
	-- DBM Prefix		M
	-- DBM Mod			CoSTrash
	-- Mod Prefix		CoS
	local clue = message:match("^M\tCoSTrash\t%d+\tCoS\t(.*)$");
	
	if
			prefix == "D4"
		and	clue
		and	(
					UnitInParty(sender)
				or	UnitInRaid(sender)
				or	UnitIsUnit(sender, "player")
			)
	then
		Aye.modules.CoSpy.events.CHAT_MSG_PARTY_ALL(clue);
	end;
end;

-- GUI ready clue strings
-- used as model headers, and clue titles
Aye.modules.CoSpy.CoS_Spy_clues = {				-- id
	["Sex"]		= "Sex: |cffaaaaaa?|r",
	["Vest"]	= "Vest: |cffaaaaaa?|r",		-- 1
	["Cloak"]	= "Cloak: |cffaaaaaa?|r",		-- 2
	["Gloves"]	= "Gloves: |cffaaaaaa?|r",		-- 3
	["Sleeves"]	= "Sleeves: |cffaaaaaa?|r",		-- 4
	["Belt"]	= "Belt: |cffaaaaaa?|r",		-- 5
};

-- On Clue received (as pseudo event)
-- Update cached Aye.modules.CoSpy.CoS_Spy_clues strings
-- and optionally update existing GUI strings aswell
--
-- @param message {string} clue received
-- @noreturn
Aye.modules.CoSpy.events.CHAT_MSG_PARTY_ALL = function(message)
	message = string.lower(message or "");
	
	-- Sex
	if message == "male" then
		Aye.modules.CoSpy.CoS_Spy_clues.Sex = "Sex: |cff80b0ffMale|r";
		if Aye.modules.CoSpy.CoS_Spy then Aye.modules.CoSpy.CoS_Spy.sexKnown.txt:SetText(Aye.modules.CoSpy.CoS_Spy_clues.Sex) end;
	end;
	if message == "female" then
		Aye.modules.CoSpy.CoS_Spy_clues.Sex = "Sex: |cffff8080Female|r";
		if Aye.modules.CoSpy.CoS_Spy then Aye.modules.CoSpy.CoS_Spy.sexKnown.txt:SetText(Aye.modules.CoSpy.CoS_Spy_clues.Sex) end;
	end;
	
	-- Vest
	if message == "light vest" then
		Aye.modules.CoSpy.CoS_Spy_clues.Vest = "Vest: |cffffff00Light|r";
		if Aye.modules.CoSpy.CoS_Spy then Aye.modules.CoSpy.CoS_Spy["icon1"].title.txt:SetText(Aye.modules.CoSpy.CoS_Spy_clues.Vest) end;
	end;
	if message == "dark vest" then
		Aye.modules.CoSpy.CoS_Spy_clues.Vest = "Vest: |cffff8000Dark|r";
		if Aye.modules.CoSpy.CoS_Spy then Aye.modules.CoSpy.CoS_Spy["icon1"].title.txt:SetText(Aye.modules.CoSpy.CoS_Spy_clues.Vest) end;
	end;
	
	-- Cloak
	if
			message == "cape" -- DBM
		or	message == "cloak" -- Angry Keystones
	then
		Aye.modules.CoSpy.CoS_Spy_clues.Cloak = "Cloak: |cff40ff40Yes|r";
		if Aye.modules.CoSpy.CoS_Spy then Aye.modules.CoSpy.CoS_Spy["icon2"].title.txt:SetText(Aye.modules.CoSpy.CoS_Spy_clues.Cloak) end;
	end;
	if
			message == "no cape" -- DBM
		or	message == "no cloak" -- Angry Keystones
	then
		Aye.modules.CoSpy.CoS_Spy_clues.Cloak = "Cloak: |cffff4040No|r";
		if Aye.modules.CoSpy.CoS_Spy then Aye.modules.CoSpy.CoS_Spy["icon2"].title.txt:SetText(Aye.modules.CoSpy.CoS_Spy_clues.Cloak) end;
	end;
	
	-- Sleeves
	if message == "short sleeves" then
		Aye.modules.CoSpy.CoS_Spy_clues.Sleeves = "Sleeves: |cffffff00Short|r";
		if Aye.modules.CoSpy.CoS_Spy then Aye.modules.CoSpy.CoS_Spy["icon3"].title.txt:SetText(Aye.modules.CoSpy.CoS_Spy_clues.Sleeves) end;
	end;
	if message == "long sleeves" then
		Aye.modules.CoSpy.CoS_Spy_clues.Sleeves = "Sleeves: |cffff8000Long|r";
		if Aye.modules.CoSpy.CoS_Spy then Aye.modules.CoSpy.CoS_Spy["icon3"].title.txt:SetText(Aye.modules.CoSpy.CoS_Spy_clues.Sleeves) end;
	end;
	
	-- Gloves
	if message == "gloves" then
		Aye.modules.CoSpy.CoS_Spy_clues.Gloves = "Gloves: |cff40ff40Yes|r";
		if Aye.modules.CoSpy.CoS_Spy then Aye.modules.CoSpy.CoS_Spy["icon4"].title.txt:SetText(Aye.modules.CoSpy.CoS_Spy_clues.Gloves) end;
	end;
	if message == "no gloves" then
		Aye.modules.CoSpy.CoS_Spy_clues.Gloves = "Gloves: |cffff4040No|r";
		if Aye.modules.CoSpy.CoS_Spy then Aye.modules.CoSpy.CoS_Spy["icon4"].title.txt:SetText(Aye.modules.CoSpy.CoS_Spy_clues.Gloves) end;
	end;
	
	-- Belt
	if
			message == "potions" -- DBM
		or	message == "potion" -- Angry Keystones
	then
		Aye.modules.CoSpy.CoS_Spy_clues.Belt = "Belt: |cff40ff40Potions|r";
		if Aye.modules.CoSpy.CoS_Spy then Aye.modules.CoSpy.CoS_Spy["icon5"].title.txt:SetText(Aye.modules.CoSpy.CoS_Spy_clues.Belt) end;
	end;
	if
			message == "pouch" -- DBM
		or	message == "coinpurse" -- Angry Keystones
	then
		Aye.modules.CoSpy.CoS_Spy_clues.Belt = "Belt: |cffffff00Coin Purse|r";
		if Aye.modules.CoSpy.CoS_Spy then Aye.modules.CoSpy.CoS_Spy["icon5"].title.txt:SetText(Aye.modules.CoSpy.CoS_Spy_clues.Belt) end;
	end;
	if message == "book" then
		Aye.modules.CoSpy.CoS_Spy_clues.Belt = "Belt: |cff80b0ffBook|r";
		if Aye.modules.CoSpy.CoS_Spy then Aye.modules.CoSpy.CoS_Spy["icon5"].title.txt:SetText(Aye.modules.CoSpy.CoS_Spy_clues.Belt) end;
	end;
	if message == "no potion" then
		Aye.modules.CoSpy.CoS_Spy_clues.Belt = "Belt: |cffff4040Empty|r";
		if Aye.modules.CoSpy.CoS_Spy then Aye.modules.CoSpy.CoS_Spy["icon5"].title.txt:SetText(Aye.modules.CoSpy.CoS_Spy_clues.Belt) end;
	end;
end;