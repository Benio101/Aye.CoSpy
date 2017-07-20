local Aye = Aye;
if not Aye.addModule("Aye.CoSpy") then return end;

Aye.modules.CoSpy.OnEnable = function()
	RegisterAddonMessagePrefix("D4"); -- DBM
end;

Aye.modules.CoSpy.events.PLAYER_TARGET_CHANGED = function()
	if
			GetRealZoneText() == "Court of Stars"
		and	GetMinimapZoneText() == "The Jeweled Estate"
		and	UnitName("target") == "Suspicious Noble"
	then
		-- get Sex name, eventually GUI formatted
		--
		-- @param sexID {uint} id of sex, as returned by UnitSex()
		-- @parem colored {bool} if returned Sex name should be GUI formatted
		-- @return {string} Sex name. if colored, Sex name will be GUI formatted
		local SexText = function(sexID, colored)
			if sexID == 2 then return colored and "|cff80b0ffMale|r" or "Male" end;
			if sexID == 3 then return colored and "|cffff8080Female|r" or "Female" end;
			
			return colored and "|cffaaaaaa?|r" or "Unknown";
		end;
		
		-- Clue titles (without sex)
		local titles = {"Vest", "Cloak", "Sleeves", "Gloves", "Belt"};
		
		-- prepare models and titles/headers
		if not Aye.modules.CoSpy.CoS_Spy then
			Aye.modules.CoSpy.CoS_Spy = CreateFrame("Frame", nil, UIParent);
			Aye.modules.CoSpy.CoS_Spy:ClearAllPoints();
			Aye.modules.CoSpy.CoS_Spy:SetPoint("LEFT", UIParent, "CENTER", 200, 0);
			Aye.modules.CoSpy.CoS_Spy:SetWidth(128 *2 +10);
			Aye.modules.CoSpy.CoS_Spy:SetHeight(32 +(10 +32 +128) *3);
			Aye.modules.CoSpy.CoS_Spy:SetFrameStrata("HIGH");
			
			Aye.modules.CoSpy.CoS_Spy.sex = CreateFrame("Frame", nil, Aye.modules.CoSpy.CoS_Spy);
			Aye.modules.CoSpy.CoS_Spy.sex:SetBackdrop(Aye.modules.CoSpy.config.backdrop);
			Aye.modules.CoSpy.CoS_Spy.sex:SetBackdropColor(.1, .1, .1, .75);
			Aye.modules.CoSpy.CoS_Spy.sex:SetBackdropBorderColor(0, 0, 0, .75);
			Aye.modules.CoSpy.CoS_Spy.sex:ClearAllPoints();
			Aye.modules.CoSpy.CoS_Spy.sex:SetPoint("TOPLEFT", Aye.modules.CoSpy.CoS_Spy, "TOPLEFT");
			Aye.modules.CoSpy.CoS_Spy.sex:SetWidth(128);
			Aye.modules.CoSpy.CoS_Spy.sex:SetHeight(32);
			
			Aye.modules.CoSpy.CoS_Spy.sex.txt = Aye.modules.CoSpy.CoS_Spy.sex:CreateFontString();
			Aye.modules.CoSpy.CoS_Spy.sex.txt:ClearAllPoints();
			Aye.modules.CoSpy.CoS_Spy.sex.txt:SetPoint("CENTER", Aye.modules.CoSpy.CoS_Spy.sex, "CENTER");
			Aye.modules.CoSpy.CoS_Spy.sex.txt:SetFont(Aye.modules.CoSpy.config.font, 16);
			Aye.modules.CoSpy.CoS_Spy.sex.txt:SetWidth(128 -4);
			Aye.modules.CoSpy.CoS_Spy.sex.txt:SetHeight(32 -4);
			Aye.modules.CoSpy.CoS_Spy.sex.txt:SetJustifyH("CENTER");
			Aye.modules.CoSpy.CoS_Spy.sex.txt:SetJustifyV("CENTER");
			Aye.modules.CoSpy.CoS_Spy.sex.txt:SetTextColor(1, 1, 1);
			Aye.modules.CoSpy.CoS_Spy.sex.txt:SetWordWrap(false);
			
			Aye.modules.CoSpy.CoS_Spy.sexKnown = CreateFrame("Frame", nil, Aye.modules.CoSpy.CoS_Spy);
			Aye.modules.CoSpy.CoS_Spy.sexKnown:SetBackdrop(Aye.modules.CoSpy.config.backdrop);
			Aye.modules.CoSpy.CoS_Spy.sexKnown:SetBackdropColor(.1, .1, .1, .75);
			Aye.modules.CoSpy.CoS_Spy.sexKnown:SetBackdropBorderColor(0, 0, 0, .75);
			Aye.modules.CoSpy.CoS_Spy.sexKnown:ClearAllPoints();
			Aye.modules.CoSpy.CoS_Spy.sexKnown:SetPoint("TOPRIGHT", Aye.modules.CoSpy.CoS_Spy, "TOPRIGHT");
			Aye.modules.CoSpy.CoS_Spy.sexKnown:SetWidth(128);
			Aye.modules.CoSpy.CoS_Spy.sexKnown:SetHeight(32);
			
			Aye.modules.CoSpy.CoS_Spy.sexKnown.txt = Aye.modules.CoSpy.CoS_Spy.sexKnown:CreateFontString();
			Aye.modules.CoSpy.CoS_Spy.sexKnown.txt:ClearAllPoints();
			Aye.modules.CoSpy.CoS_Spy.sexKnown.txt:SetPoint("CENTER", Aye.modules.CoSpy.CoS_Spy.sexKnown, "CENTER");
			Aye.modules.CoSpy.CoS_Spy.sexKnown.txt:SetFont(Aye.modules.CoSpy.config.font, 16);
			Aye.modules.CoSpy.CoS_Spy.sexKnown.txt:SetWidth(128 -4);
			Aye.modules.CoSpy.CoS_Spy.sexKnown.txt:SetHeight(32 -4);
			Aye.modules.CoSpy.CoS_Spy.sexKnown.txt:SetJustifyH("CENTER");
			Aye.modules.CoSpy.CoS_Spy.sexKnown.txt:SetJustifyV("CENTER");
			Aye.modules.CoSpy.CoS_Spy.sexKnown.txt:SetTextColor(1, 1, 1);
			Aye.modules.CoSpy.CoS_Spy.sexKnown.txt:SetWordWrap(false);
			
			for i = 1, 5 do
				Aye.modules.CoSpy.CoS_Spy["icon" ..i] = CreateFrame("Frame", nil, Aye.modules.CoSpy.CoS_Spy);
				Aye.modules.CoSpy.CoS_Spy["icon" ..i]:SetBackdrop(Aye.modules.CoSpy.config.backdrop);
				Aye.modules.CoSpy.CoS_Spy["icon" ..i]:SetBackdropColor(.1, .1, .1, .5);
				Aye.modules.CoSpy.CoS_Spy["icon" ..i]:SetBackdropBorderColor(0, 0, 0, .75);
				Aye.modules.CoSpy.CoS_Spy["icon" ..i]:ClearAllPoints();
				Aye.modules.CoSpy.CoS_Spy["icon" ..i]:SetPoint(
					"TOPLEFT",
					Aye.modules.CoSpy.CoS_Spy, "TOPLEFT",
					(128 +10) *(floor(i /3)  -floor(i /5)),
					-32 -(10 +32 +128) *(floor(i /5) *2 +(i -1) %2) -10 -32
				);
				Aye.modules.CoSpy.CoS_Spy["icon" ..i]:SetWidth(128 +floor(i /5) *(128 +10));
				Aye.modules.CoSpy.CoS_Spy["icon" ..i]:SetHeight(128);
				
				Aye.modules.CoSpy.CoS_Spy["icon" ..i].title = CreateFrame("Frame", nil, Aye.modules.CoSpy.CoS_Spy["icon" ..i]);
				Aye.modules.CoSpy.CoS_Spy["icon" ..i].title:SetBackdrop(Aye.modules.CoSpy.config.backdrop);
				Aye.modules.CoSpy.CoS_Spy["icon" ..i].title:SetBackdropColor(.1, .1, .1, .75);
				Aye.modules.CoSpy.CoS_Spy["icon" ..i].title:SetBackdropBorderColor(0, 0, 0, .75);
				Aye.modules.CoSpy.CoS_Spy["icon" ..i].title:ClearAllPoints();
				Aye.modules.CoSpy.CoS_Spy["icon" ..i].title:SetPoint("BOTTOM", Aye.modules.CoSpy.CoS_Spy["icon" ..i], "TOP");
				Aye.modules.CoSpy.CoS_Spy["icon" ..i].title:SetWidth(128 +floor(i /5) *(128 +10));
				Aye.modules.CoSpy.CoS_Spy["icon" ..i].title:SetHeight(32);
				
				Aye.modules.CoSpy.CoS_Spy["icon" ..i].title.txt = Aye.modules.CoSpy.CoS_Spy["icon" ..i].title:CreateFontString();
				Aye.modules.CoSpy.CoS_Spy["icon" ..i].title.txt:ClearAllPoints();
				Aye.modules.CoSpy.CoS_Spy["icon" ..i].title.txt:SetPoint("CENTER", Aye.modules.CoSpy.CoS_Spy["icon" ..i].title, "CENTER");
				Aye.modules.CoSpy.CoS_Spy["icon" ..i].title.txt:SetFont(Aye.modules.CoSpy.config.font, 16);
				Aye.modules.CoSpy.CoS_Spy["icon" ..i].title.txt:SetWidth(128 +floor(i /5) *(128 +10) -4);
				Aye.modules.CoSpy.CoS_Spy["icon" ..i].title.txt:SetHeight(32 -4);
				Aye.modules.CoSpy.CoS_Spy["icon" ..i].title.txt:SetJustifyH("CENTER");
				Aye.modules.CoSpy.CoS_Spy["icon" ..i].title.txt:SetJustifyV("CENTER");
				Aye.modules.CoSpy.CoS_Spy["icon" ..i].title.txt:SetTextColor(1, 1, 1);
				Aye.modules.CoSpy.CoS_Spy["icon" ..i].title.txt:SetWordWrap(false);
				Aye.modules.CoSpy.CoS_Spy["icon" ..i].title.txt:SetText(Aye.modules.CoSpy.CoS_Spy_clues[titles[i]]);
				
				Aye.modules.CoSpy.CoS_Spy["icon" ..i].model = CreateFrame("PlayerModel", nil, Aye.modules.CoSpy.CoS_Spy["icon" ..i]);
				Aye.modules.CoSpy.CoS_Spy["icon" ..i].model:ClearAllPoints();
				Aye.modules.CoSpy.CoS_Spy["icon" ..i].model:SetPoint("CENTER", Aye.modules.CoSpy.CoS_Spy["icon" ..i], "CENTER");
				Aye.modules.CoSpy.CoS_Spy["icon" ..i].model:SetWidth(128 +floor(i /5) *(128 +10) -4);
				Aye.modules.CoSpy.CoS_Spy["icon" ..i].model:SetHeight(128 -4);
			end;
		end;
		
		Aye.modules.CoSpy.CoS_Spy:Show();
		Aye.modules.CoSpy.CoS_Spy.sex:Show();
		Aye.modules.CoSpy.CoS_Spy.sex.txt:SetText("Target Sex: " ..SexText(UnitSex("target"), true));
		Aye.modules.CoSpy.CoS_Spy.sex.txt:Show();
		Aye.modules.CoSpy.CoS_Spy.sexKnown.txt:SetText(Aye.modules.CoSpy.CoS_Spy_clues.Sex);
		
		for i = 1, 5 do
			Aye.modules.CoSpy.CoS_Spy["icon" ..i]:Show();
			
			Aye.modules.CoSpy.CoS_Spy["icon" ..i].title:Show();
			Aye.modules.CoSpy.CoS_Spy["icon" ..i].title.txt:SetText(Aye.modules.CoSpy.CoS_Spy_clues[titles[i]]);
			Aye.modules.CoSpy.CoS_Spy["icon" ..i].title.txt:Show();
			
			Aye.modules.CoSpy.CoS_Spy["icon" ..i].model:Show();
			Aye.modules.CoSpy.CoS_Spy["icon" ..i].model:SetUnit("target");
			Aye.modules.CoSpy.CoS_Spy["icon" ..i].model:SetAnimation(15);
			
			-- position cache hack
			Aye.modules.CoSpy.CoS_Spy["icon" ..i].model:SetPosition(0, 0, 0);
			Aye.modules.CoSpy.CoS_Spy["icon" ..i].model:Hide();
			Aye.modules.CoSpy.CoS_Spy["icon" ..i].model:Show();
			
			Aye.modules.CoSpy.CoS_Spy["icon" ..i].model:SetCustomCamera(1);
		end;
		
		if SexText(UnitSex("target"), false) == "Male" then
			-- Vest
			Aye.modules.CoSpy.CoS_Spy["icon1"].model:SetPosition(0, -.04, -.4);
			Aye.modules.CoSpy.CoS_Spy["icon1"].model:SetCameraDistance(.5);
			
			-- Cloak
			Aye.modules.CoSpy.CoS_Spy["icon2"].model:SetPosition(0, -.04, -.25);
			Aye.modules.CoSpy.CoS_Spy["icon2"].model:SetCameraPosition(-1, 0, .5);
			Aye.modules.CoSpy.CoS_Spy["icon2"].model:SetCameraDistance(.5);
			
			-- Sleeves
			Aye.modules.CoSpy.CoS_Spy["icon3"].model:SetPosition(0, -.45, -.2);
			Aye.modules.CoSpy.CoS_Spy["icon3"].model:SetCameraDistance(1);
			
			-- Gloves
			Aye.modules.CoSpy.CoS_Spy["icon4"].model:SetPosition(0, -.45, .3);
			Aye.modules.CoSpy.CoS_Spy["icon4"].model:SetCameraDistance(.5);
			
			-- Belt
			Aye.modules.CoSpy.CoS_Spy["icon5"].model:SetPosition(0, 0, 0);
			Aye.modules.CoSpy.CoS_Spy["icon5"].model:SetCameraDistance(.85);
		else
			-- Vest
			Aye.modules.CoSpy.CoS_Spy["icon1"].model:SetPosition(0, 0, -.7);
			Aye.modules.CoSpy.CoS_Spy["icon1"].model:SetCameraDistance(.5);
			
			-- Cloak
			Aye.modules.CoSpy.CoS_Spy["icon2"].model:SetPosition(0, 0, -.25);
			Aye.modules.CoSpy.CoS_Spy["icon2"].model:SetCameraPosition(-1, 0, .5);
			Aye.modules.CoSpy.CoS_Spy["icon2"].model:SetCameraDistance(.5);
			
			-- Sleeves
			Aye.modules.CoSpy.CoS_Spy["icon3"].model:SetPosition(0, -.3, -.55);
			Aye.modules.CoSpy.CoS_Spy["icon3"].model:SetCameraDistance(1);
			
			-- Gloves
			Aye.modules.CoSpy.CoS_Spy["icon4"].model:SetPosition(0, -.3, -.05);
			Aye.modules.CoSpy.CoS_Spy["icon4"].model:SetCameraDistance(.5);
			
			-- Belt
			Aye.modules.CoSpy.CoS_Spy["icon5"].model:SetPosition(0, 0, -.25);
			Aye.modules.CoSpy.CoS_Spy["icon5"].model:SetCameraDistance(.85);
		end;
	else
		if Aye.modules.CoSpy.CoS_Spy then
			Aye.modules.CoSpy.CoS_Spy:Hide();
			Aye.modules.CoSpy.CoS_Spy.sex:Hide();
			Aye.modules.CoSpy.CoS_Spy.sex.txt:Hide();
			for i = 1, 5 do
				Aye.modules.CoSpy.CoS_Spy["icon" ..i]:Hide();
				Aye.modules.CoSpy.CoS_Spy["icon" ..i].title:Hide();
				Aye.modules.CoSpy.CoS_Spy["icon" ..i].title.txt:Hide();
				Aye.modules.CoSpy.CoS_Spy["icon" ..i].model:Hide();
			end;
		end;
	end;
end;