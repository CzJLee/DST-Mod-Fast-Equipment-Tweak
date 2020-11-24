local KEY_WEAPON = GetModConfigData("Key_Weapon")
local KEY_AXE = GetModConfigData("Key_Axe")
local KEY_PICKAXE = GetModConfigData("Key_Pickaxe")
local KEY_SHOVEL = GetModConfigData("Key_Shovel")
local KEY_HAMMER = GetModConfigData("Key_Hammer")
local KEY_PITCHFORK = GetModConfigData("Key_Pitchfork")
local KEY_LIGHT = GetModConfigData("Key_Light")
local KEY_ARMOR = GetModConfigData("Key_Armor")
local KEY_HELMET = GetModConfigData("Key_Helmet")
local KEY_CANE = GetModConfigData("Key_Cane")
local KEY_RANGED = GetModConfigData("Key_Ranged")
local RANGED = GetModConfigData("Ranged")
local LETTERS = GetModConfigData("Letters")
local DISABLE_KEYS = GetModConfigData("Disable_Keys")
local DISABLE_BUTTONS = GetModConfigData("Disable_Buttons")
local SUPPORT_EXTRAE = GetModConfigData("Support_ExtraE")
local SUPPORT_SCYTHES = GetModConfigData("Support_Scythes")
local KEY_SCYTHE = GetModConfigData("Key_Scythe")
local LB_HORIZONTAL_OFFSET = GetModConfigData("LB_Horizontal_Offset")
local RB_HORIZONTAL_OFFSET = GetModConfigData("RB_Horizontal_Offset")
local VERTICAL_OFFSET = GetModConfigData("Vertical_Offset")
local KEY_REFRESH = GetModConfigData("Key_Refresh")

local KEYS = {
	KEY_WEAPON,
	KEY_AXE,
	KEY_PICKAXE,
	KEY_SHOVEL,
	KEY_HAMMER,
	KEY_PITCHFORK,
	KEY_LIGHT,
	KEY_ARMOR,
	KEY_HELMET,
	KEY_CANE
}
if RANGED then
	table.insert(KEYS, KEY_RANGED)
else 
	table.insert(KEYS, false)
end

if SUPPORT_SCYTHES then
	table.insert(KEYS, KEY_SCYTHE)
else 
	table.insert(KEYS, false)
end

SUPPORT_PANFOOD = true
-- "\" key
KEY_PANFOOD = 92
if SUPPORT_PANFOOD then
	table.insert(KEYS, KEY_PANFOOD)
else 
	table.insert(KEYS, false)
end

SUPPORT_CANESWAP = true
-- "]" key
KEY_CANESWAP = 93
if SUPPORT_CANESWAP then
	table.insert(KEYS, KEY_CANESWAP)
else 
	table.insert(KEYS, false)
end

-- SUPPORT_HEALS = true
-- -- "[" key
-- KEY_HEALS = 91
-- if SUPPORT_HEALS then
-- 	table.insert(KEYS, KEY_HEALS)
-- else 
-- 	table.insert(KEYS, false)
-- end

local Player
local Widget = GLOBAL.require("widgets/widget")
local Image = GLOBAL.require("widgets/image")
local ImageButton = GLOBAL.require("widgets/imagebutton")
local Button = GLOBAL.require("widgets/button")

local button = {}
local icon_button = {}
local actual_item = {}
local letter = {}

local button_order = {}
local button_side = {}

if RANGED then
	if SUPPORT_SCYTHES then
		button_order = {2,1,3,4,5,6,7,4,5,1,3,2}
		button_side = {1,0,0,0,0,0,0,1,1,1,1,0}
	else
		button_order = {2,1,2,3,4,5,6,4,5,1,3}
		button_side = {1,0,0,0,0,0,0,1,1,1,1}
	end
else
	if SUPPORT_SCYTHES then
		button_order = {2,1,3,4,5,6,7,3,4,1,nil,2} --stupid crash fix, i'm sorry for this
		button_side = {1,0,0,0,0,0,0,1,1,1,nil,0}
	else
		button_order = {2,1,2,3,4,5,6,3,4,1}
		button_side = {1,0,0,0,0,0,0,1,1,1}
	end
end

local tools_back
local equip_back

local finish_init = false

local default_icon = {
	"spear",
	"axe",
	"pickaxe",
	"shovel",
	"hammer",
	"pitchfork",
	"torch",
	"armorwood",
	"footballhat",
	"cane",
	"boomerang",
	"scythe",
	"panflute", -- (panfood) Adding the category requires this to be added, or else it crashes. I think it has something to do with how it resets categories.
	"cane", -- (cane swap)
	-- ""healingsalve"" -- (heals)
}

local weapons = {
	"glasscutter",
	"cutlass",
	"nightsword",
	"hambat", -- I want hambat to have a higher priority than Thulecite Club.
	"ruins_bat",
	"spear_obsidian",
	"tentaclespike",
	"nightstick",
	"batbat",
	"gears_mace",
	"spear_wathgrithr",
	"gears_staff",
	"sword_rock",
	"spear_poison",
	"spear",
	"peg_leg",
	"trident",
	"bullkelp_root",
	"whip",
	"needlespear",
	"bug_swatter"
}

local rweapons = {
	"musket",
	"crossbow",
	"bow",
	"blowdart_yellow",
	"blowdart_fire",
	"blowdart_poison",
	"blowdart_sleep",
	"blowdart_pipe",
	"slingshot",
	"icestaff",
	"firestaff",
	"boomerang"
}

local axes = {
	"lucy",
	"moonglassaxe",
	"gears_multitool",
	"multitool_axe_pickaxe",
	"goldenaxe",
	"axe"
}

local pickaxes = {
	"gears_multitool",
	"multitool_axe_pickaxe",
	"goldenpickaxe",
	"pickaxe"
}

local shovels = {
	"goldenshovel",
	"shovel"
}

local scythes = {
	"scythe_golden",
	"scythe"
}

local canes = {
	"orangestaff",
	"cane",
	"ruins_bat"
}

local armors = {
	"armorskeleton",
	"armorruins",
	"armordragonfly",
	"armorobsidian",
	"armorsnurtleshell",
	"armormarble",
	"armorlimestone",
	"armor_sanity",
	"armor_rock",
	"armorseashell",
	"armorcactus",
	"armor_bone",
	"armor_stone",
	"armorwood",
	"armor_bramble",
	"armorgrass",
	"yellowamulet"
}

local helmets = {
	"skeletonhat",
	"ruinshat",
	"hivehat",
	"hat_marble",
	"slurtlehat",
	"hat_rock",
	"wathgrithrhat",
	"oxhat",
	"hat_wood",
	"beehat",
	"footballhat"
}

local backpacks = {
	"backpack",
	"piggyback",
	"krampus_sack",
	"icepack",
	"thatchpack",
	"piratepack",
	"seasack",
	"equip_pack",
	"wool_sack",
	"spicepack"
}

local lights = {
	"gears_hat_goggles",
	"molehat",
	"bottlelantern",
	"lantern",
	"minerhat",
	"redlantern",
	"tarlamp",
	"torch",
	"lighter",
	"yellowamulet"
}

local pitchfork = {
	"pitchfork",
	"oar",
	"oar_driftwood",
	"malbatross_beak",
	"purpleamulet",
	"batnosehat", -- Milkmade Hat
	"eyebrellahat",
	"umbrella",
	"beefalohat",
	"walrushat",
	"deserthat",
	"mermhat",
	"blueamulet",
	"featherhat",
	"winterhat",
	"earmuffshat",
	"rainhat",
	"catcoonhat",
	"icehat",
	"watermelonhat",
	"bushhat",
	"blue_mushroomhat",
	"green_mushroomhat",
	"red_mushroomhat",
	"beargervest",
	"trunkvest_winter",
	"raincoat",
	"hawaiianshirt",
	"trunkvest_summer",
	"sweatervest",
	"reflectivevest",
	"reskin_tool",
	"armorslurper",
	"amulet",
	"tophat",
	"flowerhat",
	"strawhat",
	"oceanfishingrod",
	"fishingrod"
}

local panfood = {
	"panflute",
	"rock_avocado_fruit_ripe_cooked",
	"rock_avocado_fruit_ripe",
	"berries_juicy _cooked",
	"berries_cooked",
	"carrot_cooked",
	"cave_banana_cooked",
	"cave_banana",
	"turkeydinner",
	"dragonpie",
	"meatballs",
	"bonestew",
	"baconeggs",
	"honeyham",
	"smallmeat",
	"cookedsmall_meat",
	"smallmeat_dried",
	"meat_dried",
	"cookedmeat",
	"cutlichen",
	"trunk_cooked",
	"honey",
	"froglegs_cooked",
	"bird_egg_cooked",
	"butterflywings",
	"berries_juicy",
	"carrot",
	"berries"
}

local heals = {
	"dragonpie",
	"perogies"
}

Assets = {
	Asset("ATLAS", "images/basic_back.xml"),
	Asset("IMAGE", "images/basic_back.tex"),
	Asset("ATLAS", "images/button_large.xml"),
	Asset("IMAGE", "images/button_large.tex")
}

local info_buttons = {}
local info_stack = {last=0}
local info_names = {last=0}
local info_back_button
local info_actual_button
local base_position = { x =-600, y = -50}
local col = 0
local row = 0
local offset_x = 160
local offset_y = 55
local fishingfix_offset = 325
local offset_px = 45
local offset_extrae = 0

if SUPPORT_EXTRAE then
	offset_extrae = 75
end

local function ClearInfoTable()
	info_stack = {last=0}
	info_names = {last=0}
	
	if (info_back_button) then
		info_back_button:Kill()
	end
		
	if (info_actual_button) then
		info_actual_button:Kill()
	end
	
	info_back_button = nil
	info_actual_button = nil
	
	for i,v in pairs(info_buttons) do
		v:Kill()
	end
	info_buttons = {}
end

local function InfoTable(inst, info, last_info, init)
	local info_root = inst.HUD.controls.top_root
	col = 0
	row = 0
	
	if (init) then
		info_stack = {last=0}
		info_names = {last=0}
	end
	
	if (info_back_button) then
		info_back_button:Kill()
	end
		
	if (info_actual_button) then
		info_actual_button:Kill()
	end
	
	if (last_info) then
		info_stack.last = info_stack.last + 1
		info_stack[info_stack.last] = last_info
	end
	
	info_back_button = info_root:AddChild(ImageButton())
	info_back_button:SetText("<-")
	info_back_button:UpdatePosition(base_position.x+(col*offset_x),base_position.y-(row*offset_y),0)
	info_back_button:SetScale(0.7,0.7,0.7)
	info_back_button:Disable()
	col = 1
	
	info_actual_button = info_root:AddChild(ImageButton("images/button_large.xml","normal.tex","focus.tex","disabled.tex"))
	local dir = ""
	for i=1, info_names.last do
		dir = dir.."/"..info_names[i]
	end
	info_actual_button:SetText(dir)
	info_actual_button:UpdatePosition(base_position.x+(3*offset_x),base_position.y-(row*offset_y),0)
	info_actual_button:SetScale(0.5,0.5,0.5)
	info_actual_button:Disable()
	row = row + 1
	col = 0
	
	if (info_stack.last ~= 0) then
		info_back_button:Enable()
		local back_info = info_stack[info_stack.last]
		info_back_button:SetOnClick(function()
			info_stack.last = info_stack.last - 1
			info_names.last = info_names.last - 1
			InfoTable(inst, back_info, nil, false)
		end)
	end
	
	for i,v in pairs(info_buttons) do
		v:Kill()
	end
	info_buttons = {}
	for i,v in pairs(info) do
		info_buttons[i] = info_root:AddChild(ImageButton())
		info_buttons[i]:UpdatePosition(base_position.x+(col*offset_x),base_position.y-(row*offset_y),0)
		info_buttons[i]:SetScale(0.7,0.7,0.7)
		info_buttons[i]:SetTextFocusColour(1,0,0,1)
		if (type(v) == "table") then
			info_buttons[i].image:SetTint(0,0.8,0.8,1)
			info_buttons[i]:SetText(tostring(i))
			info_buttons[i]:SetOnClick(function() 
				info_names.last = info_names.last + 1
				info_names[info_names.last] = tostring(i)
				InfoTable(inst, v, info, false) 
			end)
		else
			info_buttons[i]:SetText("["..tostring(i).."]\n"..tostring(v))
		end
		col = col + 1
		if (col == 8) then
			row = row + 1
			col = 0
		end
	end
end

local function IsInItemGroup(item,group)
	for i,v in pairs(group) do
		if (item and v == item) then
			return true
		end
	end
	return false
end

local function EquipItem(index)
	local equiped_item
	if (index == 14) then
		equiped_item = Player.replica.inventory:GetEquippedItem("hands")
		-- If the currently equiped item is the best cane, equip the best weapon. 
		if (equiped_item == actual_item[10]) then
			Player.replica.inventory:UseItemFromInvTile(actual_item[1])
		-- Else if the currently equiped item is the best weapon, equip the best cane. 
		elseif (equiped_item == actual_item[1]) then
			Player.replica.inventory:UseItemFromInvTile(actual_item[10])
		-- Else if the currently equiped item is not the best cane or best weapon...
		elseif (equiped_item ~= actual_item[10] and equiped_item ~= actual_item[1]) then
			-- Then equip the cane. 
			Player.replica.inventory:UseItemFromInvTile(actual_item[10])
		end
	else
		if (actual_item[index]) then
			if (index == 7) then
				equiped_item = Player.replica.inventory:GetEquippedItem("hands")
				if (equiped_item == nil or equiped_item.prefab ~= actual_item[index].prefab) then
					equiped_item = Player.replica.inventory:GetEquippedItem("head")
				end
			elseif (index == 8) then
				equiped_item = Player.replica.inventory:GetEquippedItem("body")
			elseif (index == 9) then
				equiped_item = Player.replica.inventory:GetEquippedItem("head")
			else
				equiped_item = Player.replica.inventory:GetEquippedItem("hands")
			end

			-- If there is currently nothing equiped, or the best item is not the currently equiped item...
			if (equiped_item == nil or actual_item[index].prefab ~= equiped_item.prefab) then
				-- Then equip the best item.
				Player.replica.inventory:UseItemFromInvTile(actual_item[index])
				--Player.replica.inventory:Equip(actual_item[index],nil)
			-- Else if the best item is currently equiped
			elseif (actual_item[index].prefab == equiped_item.prefab) then
				-- Then unequip the item.
				local active_item = Player.replica.inventory:GetActiveItem()
				if (not(index == 8 and active_item and active_item.prefab == "torch")) then
					Player.replica.inventory:UseItemFromInvTile(equiped_item)
				end
			end
		end
	end
end


local function IsInGroup(item,group)
	if (item) then
		for i,v in pairs(group) do
			if (v == item.prefab) then
				return true
			end
		end
	end
	return false
end

local function IsItemEquipped(item)
	return IsInItemGroup(item, Player.replica.inventory:GetEquips())
end

-- Return the item with less durability.
local function CompareItems(item1,item2)
	if (not item1 and item2) then
		return item2
	elseif (not item2 and item1) then
		return item1
	elseif (not item1 and not item2) then
		return nil
	end

	local uses1 = item1.replica.inventoryitem.classified.percentused:value()
	local uses2 = item2.replica.inventoryitem.classified.percentused:value()

	if (not uses1 and uses2) then
		return item2
	elseif (not uses2 and uses1) then
		return item1
	elseif (not uses1 and not uses2) then
		return nil
	end
		
	--GLOBAL.TheNet:Say("compare uses 1: "..uses1..", 2: "..uses2,true)
	
	if (uses1 > uses2) then
		return item2
	elseif (uses2 > uses1) then
		return item1
	else
		return nil
	end
end

-- If XOR(item1,item2), return the item that exists. If neither exist, return nil.
-- If both item exists, return the item with higher priority in group.
-- If multiple of the same item exist, return the one with the lowest durability.
local function GetBestItem(item1,item2,group)
	if (not item1 and item2) then
		return item2
	elseif (not item2 and item1) then
		return item1
	elseif (not item1 and not item2) then
		return nil
	else
		local prefitem1, prefitem2
		for i,v in pairs(group) do
			if (v == item1.prefab) then
				prefitem1 = i
			end
			if (v == item2.prefab) then
				prefitem2 = i
			end
		end
		if (prefitem1 < prefitem2) then
			return item1
		elseif (prefitem1 > prefitem2) then
			return item2
		else
			-- Pick the item with less durability
			local winner_item = CompareItems(item1,item2)
			-- GLOBAL.TheNet:Say("I am comparing item1: "..tostring(item1)..", and item2: "..tostring(item2),true)
			if (winner_item) then
				return winner_item
			else
				return item2 -- Change to item2 to not alternate the same item. 
			end
		end
	end
end

local function GetBestItemNoGroup(item1,item2)
	if (not item1 and item2) then
		return item2
	elseif (not item2 and item1) then
		return item1
	elseif (not item1 and not item2) then
		return nil
	else
		local winner_item = CompareItems(item1,item2)
		if (winner_item) then
			return winner_item
		else
			return item1
		end
	end
end

local function ChangeButtonIcon(index,item)
	if (item) then
		if (icon_button[index] and button[index]) then 
			button[index]:RemoveChild(icon_button[index])
			icon_button[index]:Kill()

			icon_button[index] = Image(item.replica.inventoryitem:GetAtlas(),item.replica.inventoryitem:GetImage())
			icon_button[index]:SetScale(0.8,0.8,0.8)
			button[index]:AddChild(icon_button[index])
			
			if (DISABLE_BUTTONS) then
				button[index]:Hide()
				icon_button[index]:Hide()
			end
		end
		if (letter[index]) then
			letter[index]:MoveToFront()
			
			if (DISABLE_BUTTONS) then
				letter[index]:Hide()
			end
		end
	end
end

-- This is the only spot where the list of items is called.
-- The passed "item" seems to be an object in the inventory.
-- At each elif, check if the "item" passed matches one of the prefab names in the group. 
-- Don't know what actual_item is yet, but the index represents each of the item types. For example, index 2 represents axes. I assume acutal_item is the item it has chosen to be selected. 
-- Hypothesis: Only one item is selected becasue these are elif statements. If they were changed to "If" statements, then if an item is listed in multiple groups, it can get chosen twice. 
local function CheckButtonItem(item)
	if (item.prefab == "multitool_axe_pickaxe" or item.prefab == "gears_multitool") then
		actual_item[2] = GetBestItem(actual_item[2],item,axes)
		ChangeButtonIcon(2,actual_item[2])
		actual_item[3] = GetBestItem(actual_item[3],item,pickaxes)
		ChangeButtonIcon(3,actual_item[3])
	elseif (item.prefab == "hammer") then
		actual_item[5] = GetBestItemNoGroup(actual_item[5],item)
		ChangeButtonIcon(5,actual_item[5])
	elseif (IsInGroup(item,helmets)) then
		actual_item[9] = GetBestItem(actual_item[9],item,helmets)
		ChangeButtonIcon(9,actual_item[9])
	elseif (IsInGroup(item,axes)) then
		actual_item[2] = GetBestItem(actual_item[2],item,axes)
		ChangeButtonIcon(2,actual_item[2])
	elseif (IsInGroup(item,pickaxes)) then
		actual_item[3] = GetBestItem(actual_item[3],item,pickaxes)
		ChangeButtonIcon(3,actual_item[3])
	elseif (IsInGroup(item,shovels)) then
		actual_item[4] = GetBestItem(actual_item[4],item,shovels)
		ChangeButtonIcon(4,actual_item[4])
	elseif (IsInGroup(item,rweapons)) then
		actual_item[11] = GetBestItem(actual_item[11],item,rweapons)
		ChangeButtonIcon(11,actual_item[11])
	elseif (IsInGroup(item,pitchfork)) then
		actual_item[6] = GetBestItem(actual_item[6],item,pitchfork)
		ChangeButtonIcon(6,actual_item[6])
	elseif (IsInGroup(item,scythes)) then
		actual_item[12] = GetBestItem(actual_item[12],item,scythes)
		ChangeButtonIcon(12,actual_item[12])
	end

	-- These groups contain items in multiple categories. 
	if (IsInGroup(item,canes)) then
		actual_item[10] = GetBestItem(actual_item[10],item,canes)
		ChangeButtonIcon(10,actual_item[10])
	end
	if (IsInGroup(item,weapons)) then
		actual_item[1] = GetBestItem(actual_item[1],item,weapons)
		ChangeButtonIcon(1,actual_item[1])
	end
	if (IsInGroup(item,armors)) then
		actual_item[8] = GetBestItem(actual_item[8],item,armors)
		ChangeButtonIcon(8,actual_item[8])
	end
	if (IsInGroup(item,lights)) then
		actual_item[7] = GetBestItem(actual_item[7],item,lights)
		ChangeButtonIcon(7,actual_item[7])
	end
	if (IsInGroup(item,panfood)) then
		actual_item[13] = GetBestItem(actual_item[13],item,panfood)
		-- ChangeButtonIcon(13,actual_item[13])
	end
	-- if (IsInGroup(item,heals)) then
	-- 	actual_item[15] = GetBestItem(actual_item[15],item,heals)
	-- 	-- ChangeButtonIcon(15,actual_item[15])
	-- end
end

local function ClearButtonItem(index)
	actual_item[index] = nil
	if (icon_button[index] and button[index]) then 
		button[index]:RemoveChild(icon_button[index])
		icon_button[index]:Kill()
		
		if (default_icon[index]) then
			if (index == 12) then
				icon_button[index] = Image("images/inventoryimages/scythe.xml",default_icon[index]..".tex")
			else
				icon_button[index] = Image("images/inventoryimages.xml",default_icon[index]..".tex")
			end
		else
			icon_button[index] = Image("images/inventoryimages.xml","spear.tex")
		end
		icon_button[index]:SetScale(0.8,0.8,0.8)
		icon_button[index]:SetTint(0,0,0,0.7)
		button[index]:AddChild(icon_button[index])
		letter[index]:MoveToFront()
		
		if (DISABLE_BUTTONS) then
			button[index]:Hide()
			icon_button[index]:Hide()
			letter[index]:Hide()
		end
	end
end

local function ClearAllButtonItem()
	for i=1, #default_icon do
		ClearButtonItem(i)
	end
end

local containers_visited = {}

local function ContainerEvents(self)
	if (not IsInItemGroup(self,containers_visited)) then
		--CONTAINER ITEM GET EVENT--
		self.inst:ListenForEvent("itemget", function(inst, data)
			--GLOBAL.TheNet:Say("container itemget",true)
			if (finish_init and self:IsOpenedBy(Player)) then
				if (self.type == "pack") then
					ClearAllButtonItem()
					for i,v in pairs(Player.replica.inventory:GetItems()) do
						CheckButtonItem(v)
					end
					for i,v in pairs(Player.replica.inventory:GetEquips()) do
						CheckButtonItem(v)
					end
					if (Player.replica.inventory:GetActiveItem()) then
						CheckButtonItem(Player.replica.inventory:GetActiveItem())
					end
					local backpack = Player.replica.inventory:GetOverflowContainer()

					if (backpack) then				
						local items = backpack.inst.replica.container:GetItems()
						for i,v in pairs(items) do
							CheckButtonItem(v)
						end
					end
				end
			end
		end)
		--CONTAINER ITEM LOSE EVENT--
		self.inst:ListenForEvent("itemlose", function(inst, data)
			--GLOBAL.TheNet:Say("container itemlose",true)
			if (finish_init and self:IsOpenedBy(Player)) then
				if (self.type == "pack") then
					ClearAllButtonItem()
					for i,v in pairs(Player.replica.inventory:GetItems()) do
						CheckButtonItem(v)
					end
					for i,v in pairs(Player.replica.inventory:GetEquips()) do
						CheckButtonItem(v)
					end
					if (Player.replica.inventory:GetActiveItem()) then
						CheckButtonItem(Player.replica.inventory:GetActiveItem())
					end
					local backpack = Player.replica.inventory:GetOverflowContainer()
					--GLOBAL.TheNet:Say("backpack: "..tostring(backpack),true)
					if (backpack) then				
						local items = backpack.inst.replica.container:GetItems()
						for i,v in pairs(items) do
							CheckButtonItem(v)
						end
					end
				end
			end
		end)
		table.insert(containers_visited, self)
	end
end

local function CheckAllButtonItem()
	if (finish_init) then
		ClearAllButtonItem()
		for i,v in pairs(Player.replica.inventory:GetItems()) do
			CheckButtonItem(v)
		end
		for i,v in pairs(Player.replica.inventory:GetEquips()) do
			CheckButtonItem(v)
		end
		if (Player.replica.inventory:GetActiveItem()) then
			CheckButtonItem(Player.replica.inventory:GetActiveItem())
		end
		local backpack = Player.replica.inventory:GetOverflowContainer()
		
		if (backpack) then
			ContainerEvents(backpack.inst.replica.container)
			local items = backpack.inst.replica.container:GetItems()
			for i,v in pairs(items) do
				CheckButtonItem(v)
			end
		end
	end
end

local function InventoryEvents(inst)
	--NEW ACTIVE ITEM EVENT--
	inst:ListenForEvent("newactiveitem", function(inst, data)
		--GLOBAL.TheNet:Say("newactiveitem, "..tostring(data.item),true)
		CheckAllButtonItem()
	end)
	--ITEM GET EVENT--
	inst:ListenForEvent("itemget", function(inst, data)
		--GLOBAL.TheNet:Say("itemget, "..tostring(data.item),true)
		if (finish_init) then
			if (not IsInGroup(data.item,backpacks)) then
				CheckButtonItem(data.item)
			end
		end
	end)
	--EQUIP EVENT--
	inst:ListenForEvent("equip", function(inst, data)
		--GLOBAL.TheNet:Say("equip, "..tostring(data.item),true)
		CheckAllButtonItem()
	end)
	--UNEQUIP EVENT--
	inst:ListenForEvent("unequip", function(inst, data) 
		--GLOBAL.TheNet:Say("unequip",true)
		CheckAllButtonItem()
	end)
	--ITEM LOSE EVENT--
	inst:ListenForEvent("itemlose", function(inst, data)
		--GLOBAL.TheNet:Say("itemlose",true)
		CheckAllButtonItem()
	end)
	--GOT NEW ITEM EVENT--
	inst:ListenForEvent("gotnewitem", function(inst, data)
		--GLOBAL.TheNet:Say("gotnewitem",true)
		if (finish_init) then
			if (not IsInGroup(data.item,backpacks)) then
				CheckButtonItem(data.item)
			end
		end
	end)
	--OTHER EVENTS--
	--inst:ListenForEvent("dropitem", function(inst, data) GLOBAL.TheNet:Say("dropitem",true) end)
	--inst:ListenForEvent("setowner", function(inst, data) GLOBAL.TheNet:Say("setowner",true) end)
	--inst:ListenForEvent("picksomething", function(inst, data) GLOBAL.TheNet:Say("picksomething",true) end)
	--inst:ListenForEvent("onremove", function(inst, data) GLOBAL.TheNet:Say("onremove",true) end)
end

local function keys_letters(letter)
	for i = 1, #KEYS do
		if letter == 282 then return "F1"
		elseif letter == 283 then return "F2"
		elseif letter == 284 then return "F3"
		elseif letter == 285 then return "F4"
		elseif letter == 286 then return "F5"
		elseif letter == 287 then return "F6"
		elseif letter == 288 then return "F7"
		elseif letter == 289 then return "F8"
		elseif letter == 290 then return "F9"
		elseif letter == 291 then return "F10"
		elseif letter == 292 then return "F11"
		elseif letter == 293 then return "F12"
		elseif letter == 49 then return "1"
		elseif letter == 50 then return "2"
		elseif letter == 51 then return "3"
		elseif letter == 52 then return "4"
		elseif letter == 53 then return "5"
		elseif letter == 54 then return "6"
		elseif letter == 55 then return "7"
		elseif letter == 56 then return "8"
		elseif letter == 57 then return "9"
		elseif letter == 48 then return "0"
		elseif letter == 97 then return "A"
		elseif letter == 98 then return "B"
		elseif letter == 99 then return "C"
		elseif letter == 100 then return "D"
		elseif letter == 101 then return "E"
		elseif letter == 102 then return "F"
		elseif letter == 103 then return "G"
		elseif letter == 104 then return "H"
		elseif letter == 105 then return "I"
		elseif letter == 106 then return "J"
		elseif letter == 107 then return "K"
		elseif letter == 108 then return "L"
		elseif letter == 109 then return "M"
		elseif letter == 110 then return "N"
		elseif letter == 111 then return "O"
		elseif letter == 112 then return "P"
		elseif letter == 113 then return "Q"
		elseif letter == 114 then return "R"
		elseif letter == 115 then return "S"
		elseif letter == 116 then return "T"
		elseif letter == 117 then return "U"
		elseif letter == 118 then return "V"
		elseif letter == 119 then return "W"
		elseif letter == 120 then return "X"
		elseif letter == 121 then return "Y"
		elseif letter == 122 then return "Z"
		else return
		end
	end
end

local function AddKeybindButton(self,index)
	button[index] = self:AddChild(ImageButton("images/hud.xml","inv_slot_spoiled.tex","inv_slot.tex","inv_slot_spoiled.tex","inv_slot_spoiled.tex","inv_slot_spoiled.tex"))
	
	local x
	if SUPPORT_SCYTHES then
		if (button_side[index] == 0) then
			x = 68*(button_order[index]-5)+(offset_px*LB_HORIZONTAL_OFFSET)
		else
			if (RANGED == false) then
				x = 68*button_order[index]+420-(12*(4-button_order[index]))-offset_extrae+(offset_px*RB_HORIZONTAL_OFFSET)
			else
				x = 68*button_order[index]+345-(12*(4-button_order[index]))-offset_extrae+(offset_px*RB_HORIZONTAL_OFFSET)
			end
		end
	else
		if (button_side[index] == 0) then
			x = 68*(button_order[index]-4)+(offset_px*LB_HORIZONTAL_OFFSET)
		else
			if (RANGED == false) then
				x = 68*button_order[index]+420-(12*(4-button_order[index]))-offset_extrae+(offset_px*RB_HORIZONTAL_OFFSET)
			else
				x = 68*button_order[index]+345-(12*(4-button_order[index]))-offset_extrae+(offset_px*RB_HORIZONTAL_OFFSET)
			end
		end
	end

	button[index]:SetPosition(x-fishingfix_offset,160+(offset_px*VERTICAL_OFFSET),0)
	button[index]:SetOnClick(function(inst) return EquipItem(index) end)
	button[index]:MoveToFront()
	
	if (default_icon[index]) then
		if (index == 12) then
			icon_button[index] = Image("images/inventoryimages/scythe.xml",default_icon[index]..".tex")
		else
			icon_button[index] = Image("images/inventoryimages.xml",default_icon[index]..".tex")
		end
	else
		icon_button[index] = Image("images/inventoryimages.xml","spear.tex")
	end
	icon_button[index]:SetScale(0.8,0.8,0.8)
	icon_button[index]:SetTint(0,0,0,0.7)
	button[index]:AddChild(icon_button[index])
	
	letter[index] = button[index]:AddChild(Button())
	if (LETTERS and KEYS[index] ~= false) then
		letter[index]:SetText(keys_letters(KEYS[index]))
	end
	letter[index]:SetPosition(5,0,0)
	letter[index]:SetFont("stint-ucr")
	letter[index]:SetTextColour(1,1,1,1)
	letter[index]:SetTextFocusColour(1,1,1,1)
	letter[index]:SetTextSize(50)
	--letter[index]:Disable()
	letter[index]:MoveToFront()
	
	if (DISABLE_BUTTONS) then
		button[index]:Hide()
		icon_button[index]:Hide()
		letter[index]:Hide()
	end
end

local function InitKeybindButtons(self)

	if SUPPORT_SCYTHES then
		tools_back = self:AddChild(Image("images/basic_back.xml","tools_back_ship.tex"))
		tools_back:SetPosition(-67-fishingfix_offset+(offset_px*LB_HORIZONTAL_OFFSET),170+(offset_px*VERTICAL_OFFSET),0)
	else
		tools_back = self:AddChild(Image("images/basic_back.xml","tools_back.tex"))
		tools_back:SetPosition(-36-fishingfix_offset+(offset_px*LB_HORIZONTAL_OFFSET),170+(offset_px*VERTICAL_OFFSET),0)
	end
	tools_back:MoveToBack()
	
	if (RANGED == false) then
		equip_back = self:AddChild(Image("images/basic_back.xml","equip_back.tex"))
		equip_back:SetPosition(570-fishingfix_offset-offset_extrae+(offset_px*RB_HORIZONTAL_OFFSET),170+(offset_px*VERTICAL_OFFSET),0)
	else
		equip_back = self:AddChild(Image("images/basic_back.xml","equip_back_long.tex"))
		equip_back:SetPosition(536-fishingfix_offset-offset_extrae+(offset_px*RB_HORIZONTAL_OFFSET),170+(offset_px*VERTICAL_OFFSET),0)
	end
	equip_back:MoveToBack()
	
	if DISABLE_BUTTONS then
		tools_back:Hide()
		equip_back:Hide()
	end
	
	for i=1, #default_icon do
		icon_button[i] = nil
		actual_item[i] = nil
	end
	AddKeybindButton(self,1)
	AddKeybindButton(self,2)
	AddKeybindButton(self,3)
	AddKeybindButton(self,4)
	AddKeybindButton(self,5)
	AddKeybindButton(self,6)
	AddKeybindButton(self,7)
	AddKeybindButton(self,8)
	AddKeybindButton(self,9)
	AddKeybindButton(self,10)
	if RANGED then
		AddKeybindButton(self,11)
	end
	if SUPPORT_SCYTHES then
		AddKeybindButton(self,12)
	end
	
	finish_init = true
end
AddClassPostConstruct("widgets/inventorybar", InitKeybindButtons)

local function Init(inst)
	inst:DoTaskInTime(1,function()
		Player = GLOBAL.ThePlayer
		
		InventoryEvents(inst)
		
		CheckAllButtonItem()
	end)
end
AddPlayerPostInit(Init)

local function IsDefaultScreen()
	if GLOBAL.TheFrontEnd:GetActiveScreen() and GLOBAL.TheFrontEnd:GetActiveScreen().name and type(GLOBAL.TheFrontEnd:GetActiveScreen().name) == "string" and GLOBAL.TheFrontEnd:GetActiveScreen().name == "HUD" then
		return true
	else
		return false
	end
end

-- Boolian is confusing, DISABLE_KEYS == false means that keybinds are active. 
if (DISABLE_KEYS == false or KEY_REFRESH ~= false) then
	function KeyHandler(pkey, down)
		if not GLOBAL.IsPaused() and IsDefaultScreen() then
			if down then
				-- GLOBAL.TheNet:Say("pkey is: "..tostring(pkey),ttrue)
				for i,key in pairs(KEYS) do
					if key == pkey then
						-- GLOBAL.TheNet:Say("index is: "..tostring(i),true)
						EquipItem(i)
					end
				end
				if (KEY_REFRESH ~= false) then
					if KEY_REFRESH == pkey then 
						CheckAllButtonItem()
						--GLOBAL.TheNet:Say("DONE",true)
					end
				end
			end
		end
	end

	function gamepostinit()	
		GLOBAL.TheInput:AddKeyHandler(KeyHandler)
	end

	-- add a post init to the game starting up
	AddGamePostInit(gamepostinit)
end

--[[
local info_flag = false
GLOBAL.TheInput:AddKeyUpHandler(
	289, 
	function()
		if not GLOBAL.IsPaused() and IsDefaultScreen() then
			if (not info_flag) then
				InfoTable(Player,Player,nil,true)
				info_flag = true
			else
				ClearInfoTable()
				info_flag = false
			end
		end
	end
)
]]--