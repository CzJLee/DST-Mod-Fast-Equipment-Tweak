name = "Fast Equipment (HLI update)"
version = "1.25"
description = "Adds buttons over the inventory that give a fast access to the best main tools, weapons, armors, helmets and light resources. Besides optionally adds keybinds for the mentioned tools."
author = "IceGrog, updates by M1A1EM"
forumthread = ""
icon = "modicon.tex"
icon_atlas = "modicon.xml"

api_version = 10

dont_starve_compatible = true
reign_of_giants_compatible = true
all_clients_require_mod = false
dst_compatible = true
client_only_mod = true

local keyslist = {
	{description="DISABLED", data = false},
	{description="F1", data = 282},
	{description="F2", data = 283},
	{description="F3", data = 284},
	{description="F4", data = 285},
	{description="F5", data = 286},
	{description="F6", data = 287},
	{description="F7", data = 288},
	{description="F8", data = 289},
	{description="F9", data = 290},
	{description="F10", data = 291},
	{description="F11", data = 292},
	{description="F12", data = 293},
	{description="1", data = 49},
	{description="2", data = 50},
	{description="3", data = 51},
	{description="4", data = 52},
	{description="5", data = 53},
	{description="6", data = 54},
	{description="7", data = 55},
	{description="8", data = 56},
	{description="9", data = 57},
	{description="0", data = 48},
	{description="A", data = 97},
	{description="B", data = 98},
	{description="C", data = 99},
	{description="D", data = 100},
	{description="E", data = 101},
	{description="F", data = 102},
	{description="G", data = 103},
	{description="H", data = 104},
	{description="I", data = 105},
	{description="J", data = 106},
	{description="K", data = 107},
	{description="L", data = 108},
	{description="M", data = 109},
	{description="N", data = 110},
	{description="O", data = 111},
	{description="P", data = 112},
	{description="Q", data = 113},
	{description="R", data = 114},
	{description="S", data = 115},
	{description="T", data = 116},
	{description="U", data = 117},
	{description="V", data = 118},
	{description="W", data = 119},
	{description="X", data = 120},
	{description="Y", data = 121},
	{description="Z", data = 122},
	{description="DISABLED", data = false}
	
}

local numbersx = {}
local k = -30
for i = 0, 65 do
	numbersx[i+1] = {description = k, data = k}
	k = k + 1
end

local numbersy = {}
local k = -2
for i = 0, 7 do
	numbersy[i+1] = {description = k, data = k}
	k = k + 1
end

configuration_options = {
  {
    name = "Key_Axe",
    label = "Axe's Keybind",
    default = 49,
    options = keyslist
  },
  {
    name = "Key_Pickaxe",
    label = "Pickaxe's Keybind",
    default = 50,
    options = keyslist
  },
  {
    name = "Key_Shovel",
    label = "Shovel's Keybind",
    default = 51,
    options = keyslist
  },
  {
    name = "Key_Hammer",
    label = "Hammer's Keybind",
    default = 52,
    options = keyslist
  },
  {
    name = "Key_Pitchfork",
    label = "Pitchfork's Keybind",
    default = 53,
    options = keyslist
  },
  {
    name = "Key_Light",
    label = "Light Source's Keybind",
    default = 116,
    options = keyslist
  },
  {
    name = "Key_Cane",
    label = "Walking Cane's Keybind",
    default = 104,
    options = keyslist
  },
  {
    name = "Key_Weapon",
    label = "Weapon's Keybind",
    default = 103,
    options = keyslist
  },
  {
    name = "Key_Armor",
    label = "Armor's Keybind",
    default = 99,
    options = keyslist
  },
  {
    name = "Key_Helmet",
    label = "Helmet's Keybind",
    default = 118,
    options = keyslist
  },
  {
    name = "Ranged",
    label = "Additional range weapon slot",
    default = true,
    options = {
		{description = "NO", data = false},
		{description = "YES", data = true}
	}
  },
  {
    name = "Key_Ranged",
    label = "Range Weapon's Keybind",
    default = 114,
    options = keyslist
  },
  {
    name = "Letters",
    label = "Letters on Buttons",
    default = false,
    options = {
		{description = "NO", data = false},
		{description = "YES", data = true}
	}
  },
  {
    name = "Disable_Keys",
    label = "Disable Keybinds",
    default = false,
    options = {
		{description = "NO", data = false},
		{description = "YES", data = true}
	}
  },
  {
    name = "Disable_Buttons",
    label = "Disable Buttons",
    default = false,
    options = {
		{description = "NO", data = false},
		{description = "YES", data = true}
	}
  },
  {
    name = "Support_ExtraE",
    label = "Support Extra Equip Slots",
    default = false,
	hover = "",
    options = {
		{description = "NO", data = false},
		{description = "YES", data = true}
	}
  },
  {
    name = "Support_Scythes",
    label = "Support Scythes Mod",
    default = false,
	hover = "!!! Enabling without Scythes Mod will cause crash !!!",
    options = {
		{description = "NO", data = false},
		{description = "YES", data = true}
	}
  },
  {
    name = "Key_Scythe",
    label = "Scythe's Keybind",
    default = false,
    options = keyslist
  },
  {
    name = "LB_Horizontal_Offset",
    label = "Tools Bar Horizontal Offset",
    default = 0,
    options = numbersx
  },
  {
    name = "RB_Horizontal_Offset",
    label = "Equipments Bar Horizontal Offset",
    default = 0,
    options = numbersx
  },
  {
    name = "Vertical_Offset",
    label = "Vertical Offset",
    default = 0,
    options = numbersy
  },
  {
    name = "Key_Refresh",
    label = "Refresh Key",
    default = false,
    options = keyslist
  },
}
