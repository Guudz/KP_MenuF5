ESX = nil 

local PlayerData = {}
local pPed = GetPlayerPed(-1)
---------------------------------
-------- Message F8  ------------
---------------------------------
print("^1======================================================================^7")
print("^1[^5  Auteur ^0] ^2: ^0Mathéo#2802^7")
print("^1[^5   Info  ^0] ^2: ^0Partager le **/06/2022^7")
print("^1[^5 Version ^0] ^2: ^0V 1.0 ^7")
print("^1[^5 Discord ^0] ^2: ^0https://discord.gg/KdGpw48kES^7")
print("^1======================================================================^7")
---------------------------------
-- Obtient la bibliothèque ESX --
---------------------------------
MDscript = {
    WeaponData = {},
	ItemIndex = {},
    ItemSelected = {},
    ItemSelected2 = {},
	mykey = {},
	billing = {},
	BillData = {},
    Menu = false,
    bank = nil,
    sale = nil,
    map = true,
	cinema = false,
   vehList = {
        "Avant Gauche",
        "Avant Droite",
        "Arrière Gauche",
        "Arrière Droite"
    },
    vehList2 = {
        "Avant Droite",
        "Arrière Gauche",
        "Arrière Droite",
        "Avant Gauche",
    },
    cardList = {
        "Montrer",
        "Regarder"
    },
	LimitateurIndex = 1,
	voiture_limite = {
		"30 km/h",
        "50 km/h",
        "80 km/h",
		"100 km/h",
		"120 km/h",
        "150 km/h",
        "Désactiver"
    },
    vehIndex = 1,
    vehIndex2 = 1,
    cardIndex = 1,
    DoorState = {
        FrontLeft = false,
        FrontRight = false,
        BackLeft = false,
        BackRight = false,
        Hood = false,
        Trunk = false
    },
    WindowState = {
        FrontLeft = false,
        FrontRight = false,
        BackLeft = false,
        BackRight = false,
    },
}


Citizen.CreateThread(function()
    while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(10)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	if Config.DoubleJob then
		while ESX.GetPlayerData().job2 == nil do
			Citizen.Wait(10)
		end
	end

	ESX.PlayerData = ESX.GetPlayerData()

	while actualSkin == nil do
		TriggerEvent('skinchanger:getSkin', function(skin)
			actualSkin = skin
		end)

		Citizen.Wait(10)
	end

	
    MDscript.WeaponData = ESX.GetWeaponList()

	for i = 1, #MDscript.WeaponData, 1 do
		if MDscript.WeaponData[i].name == 'WEAPON_UNARMED' then
			MDscript.WeaponData[i] = nil
		else
			MDscript.WeaponData[i].hash = GetHashKey(MDscript.WeaponData[i].name)
		end
    end

	
	RMenu.Add('location', 'main', RageUI.CreateMenu(Config.MenuTitre, "~b~Votre ID [ ~w~" .. GetPlayerServerId(NetworkGetEntityOwner(GetPlayerPed(-1))) .."~g~ ] Votre Nom [ ~w~" .. GetPlayerName(PlayerId()) .. " ~b~]"))
	-- Menu Principal
	RMenu.Add('location', 'inventaire', RageUI.CreateSubMenu(RMenu:Get('location', 'main'), "Inventaire", "Inventaire"))
	RMenu.Add('location', 'weapon', RageUI.CreateSubMenu(RMenu:Get('location', 'main'), "Inventaire", "Inventaire du joueur"))
	RMenu.Add('location', 'papier', RageUI.CreateSubMenu(RMenu:Get('location', 'main'), "Mes papier(s)", "Mes papier(s)"))
	RMenu.Add('location', 'Divers', RageUI.CreateSubMenu(RMenu:Get('location', 'main'), "Divers", "Divers"))
	RMenu.Add('location', 'portefeuille', RageUI.CreateSubMenu(RMenu:Get('location', 'main'), "Portefeuille", "Portefeuille"))
	RMenu.Add('location', 'Gestionentreprise', RageUI.CreateSubMenu(RMenu:Get('location', 'main'), "Emplois", "Gestions de votre entreprise"))
	RMenu.Add('location', 'Gestionorga', RageUI.CreateSubMenu(RMenu:Get('location', 'main'), "Organisation", "Gestion de votre Organisation"))
	RMenu.Add('location', 'Gestion_car', RageUI.CreateSubMenu(RMenu:Get('location', 'main'), "Gestion Véhicule", "Gestion de votre Véhicule"))	
	RMenu.Add('location', 'habil', RageUI.CreateSubMenu(RMenu:Get('location', 'main'), "Gestion des vetements", "Gestion des vetements"))
	-- Sous menu
	RMenu.Add('location', 'inventaire_use', RageUI.CreateSubMenu(RMenu:Get('location', 'inventaire'), "Inventaire", "Inventaire du joueur"))
	RMenu.Add('location', 'weapon_use', RageUI.CreateSubMenu(RMenu:Get('location', 'weapon'), "Inventaire", "Inventaire du joueur"))

	RMenu.Add('location', 'portefeuille_money', RageUI.CreateSubMenu(RMenu:Get('location', 'portefeuille'), "Portefeuille", "Actions sur votre portefeuille"))
	RMenu.Add('location', 'portefeuille_use', RageUI.CreateSubMenu(RMenu:Get('location', 'portefeuille'), "Portefeuille", "Actions sur votre portefeuille"))	
	Menu = false
end)

 
local hasCinematic = false
Citizen.CreateThread(function()
	while true do
	
		Citizen.Wait(0)
		if IsPauseMenuActive() then
		elseif hasCinematic then
		TriggerEvent('ui:toggle', false)
            DrawRect(1.0, 1.0, 2.0, 0.25, 0, 0, 0, 255)
            DrawRect(1.0, 0.0, 2.0, 0.25, 0, 0, 0, 255)
            ThefeedHideThisFrame()
		elseif interface then
            ThefeedHideThisFrame()
		else
			Citizen.Wait(700)
			TriggerEvent('ui:toggle', true)
		end
	end
end)

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------- SCRIPT ----------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('f5', function()

    RageUI.Visible(RMenu:Get('location', 'main'), not RageUI.Visible(RMenu:Get('location', 'main')))
end)
 
RegisterKeyMapping('f5', 'Ouvrir Le Menu F5', 'keyboard', 'F5')
  
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------ MENU ---------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


Citizen.CreateThread(function()
    while true do

        RageUI.IsVisible(RMenu:Get('location', 'main'), true, true, true, function()
		
			RageUI.Button("Votre Inventaire", "Accédez à la partit item de votre inventaire", {RightLabel = "~b~→"},true, function()
            end, RMenu:Get('location', 'inventaire'))
		if Config.style == 'normal' then
			RageUI.Button("Vos Arme(s)", "Accédez à la partit arme de votre inventaire", {RightLabel = "~b~→"},true, function()
            end, RMenu:Get('location', 'weapon'))
		end
			RageUI.Button("Portefeuille", 'Votre Portefeuille', {RightLabel = "~b~→"},true, function()
            end, RMenu:Get('location', 'portefeuille'))
			
			RageUI.Button("vos papier(s)", "Votre papier(s)", {RightLabel = "~b~→"},true, function()
            end, RMenu:Get('location', 'papier'))
			local plyPed = PlayerPedId()
			if IsPedSittingInAnyVehicle(plyPed) then

				RageUI.Button("Gestion Vehicules", "Gestion Vehicules", {RightLabel = "~b~→"}, true, function(Hovered,Active,Selected)
					if Selected then
					end
				end, RMenu:Get('location', 'Gestion_car'))

			else

				RageUI.Button("Gestion Vehicules", "Gestion Vehicules", {RightBadge = RageUI.BadgeStyle.Lock}, true, function(Hovered,Active,Selected)
					if Selected then
					end
				end)
			end
			RageUI.Button("Vos Vètement(s)", "Gestion des vetement / ac", {RightLabel = "~b~→"}, true, function(Hovered,Active,Selected)
					if Selected then
					end
				end, RMenu:Get('location', 'habil'))
			
			
			if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.grade_name == 'boss' then
				RageUI.Button("Gestion entreprise", 'Gestion Entreprise', {RightLabel = "~b~→"},true, function()
				
				end, RMenu:Get('location', 'Gestionentreprise'))
			end
			if ESX.PlayerData.job2 ~= nil and ESX.PlayerData.job2.grade_name == 'boss' then
				RageUI.Button("Gestion Organisation", 'Gestion Organisation', {RightLabel = "~b~→"},true, function()
				
				end, RMenu:Get('location', 'Gestionorga'))
			end
			
			RageUI.Button("Divers", "Menu Divers", {RightLabel = "~b~→"},true, function()
            end, RMenu:Get('location', 'Divers'))
			
			end, function()
        end)
			

			RageUI.IsVisible(RMenu:Get('location', 'inventaire'), true, true, true, function()

				RageUI.Button("			         ~g~↓ ~s~item(s) ~g~↓", nil, {RightLabel = nil}, true, function(Hovered, Active, Selected)
					if (Selected) then

					end
				end)
				
				if Config.poids == true then
				
					ESX.PlayerData = ESX.GetPlayerData()
						for i = 1, #ESX.PlayerData.inventory do
							if ESX.PlayerData.inventory[i].count > 0 then
								RageUI.Button('~b~[ ~w~' ..ESX.PlayerData.inventory[i].label.. ' ~b~]', nil, {RightLabel = "[" .. ESX.PlayerData.inventory[i].weight * ESX.PlayerData.inventory[i].count .. "kg]  ~b~x ~w~" ..ESX.PlayerData.inventory[i].count.. " ~b~"}, true, function(Hovered, Active, Selected) 
									if (Selected) then 
										MDscript.ItemSelected = ESX.PlayerData.inventory[i]
									end 
								end, RMenu:Get('location', 'inventaire_use'))
							end
						end
					 
					 
				else
					 
					ESX.PlayerData = ESX.GetPlayerData()
					for i = 1, #ESX.PlayerData.inventory do
						if ESX.PlayerData.inventory[i].count > 0 then
							RageUI.Button('~b~[ ~s~' ..ESX.PlayerData.inventory[i].label.. ' ~b~]', nil, {RightLabel = "~s~x ~b~" ..ESX.PlayerData.inventory[i].count.. " ~s~~s~"}, true, function(Hovered, Active, Selected) 
								if (Selected) then 
									MDscript.ItemSelected = ESX.PlayerData.inventory[i]
								end 
							end, RMenu:Get('location', 'inventaire_use'))
						end
					end
					 
				end
				
				if Config.style == 'itemarme' then
					RageUI.Button("			         ~r~↓ ~s~arme(s) ~r~↓", nil, {RightLabel = nil}, true, function(Hovered, Active, Selected)
					if (Selected) then

					end
				end)
				
				ESX.PlayerData = ESX.GetPlayerData()
				for i = 1, #MDscript.WeaponData, 1 do
					local plyPed = PlayerPedId()
						if HasPedGotWeapon(plyPed, MDscript.WeaponData[i].hash, false) then
							local ammo = GetAmmoInPedWeapon(plyPed, MDscript.WeaponData[i].hash)
			
							RageUI.Button('~b~[ ~s~' ..MDscript.WeaponData[i].label.. ' ~b~]', nil, {RightLabel = "~s~x ~b~" ..ammo.. " ~w~~b~"}, true, function(Hovered, Active, Selected)
								if (Selected) then
									MDscript.ItemSelected = MDscript.WeaponData[i]
								end
							end,RMenu:Get('location', 'weapon_use'))
						end
					end
				end
			end,function()
            end)
				 
			RageUI.IsVisible(RMenu:Get('location', 'weapon'), true, true, true, function()
				RageUI.Button("			         ~r~↓ ~s~arme(s) ~r~↓", nil, {RightLabel = nil}, true, function(Hovered, Active, Selected)
					if (Selected) then

					end
				end)
				
				ESX.PlayerData = ESX.GetPlayerData()
				for i = 1, #MDscript.WeaponData, 1 do
				local plyPed = PlayerPedId()
					if HasPedGotWeapon(plyPed, MDscript.WeaponData[i].hash, false) then
						local ammo = GetAmmoInPedWeapon(plyPed, MDscript.WeaponData[i].hash)
		
						RageUI.Button('~b~[ ~s~' ..MDscript.WeaponData[i].label.. ' ~b~]', nil, {RightLabel = "~s~x ~b~" ..ammo.. " ~w~~b~"}, true, function(Hovered, Active, Selected)
							if (Selected) then
								MDscript.ItemSelected = MDscript.WeaponData[i]
							end
						end,RMenu:Get('location', 'weapon_use'))
					end
				end
            end,function()
            end)
				 
            RageUI.IsVisible(RMenu:Get('location', 'inventaire_use'), true, true, true, function()

                    RageUI.Button("			Item sélectionné ~g~[ "..MDscript.ItemSelected.label.." ] ", nil, {RightBadge = ""}, true, function(Hovered, Active, Selected)
                        if (Selected) then
                          
						end
					end) 
					
					RageUI.Button("Utiliser l'item ", nil, {RightBadge = RageUI.BadgeStyle.Heart}, true, function(Hovered, Active, Selected)
                        if (Selected) then
                          --local post,quantity = CheckQuantity(KeyboardInput("Combiens d'items voulez-vous utiliser ?", '', '', 3))
                         if MDscript.ItemSelected.usable then
                             TriggerServerEvent('esx:useItem', MDscript.ItemSelected.name)
                            else
                                ShowAboveRadarMessage('l\'items n\'est pas utilisable', MDscript.ItemSelected.label)
                                end
                            end
                        end) 

                        RageUI.Button("Jeter l'item ", nil, {RightBadge = RageUI.BadgeStyle.Alert}, true, function(Hovered, Active, Selected)
                            if (Selected) then
                                if MDscript.ItemSelected.canRemove then
                                    local post,quantity = CheckQuantity(KeyboardInput("Nombres d'items que vous voulez jeter", '', '', 3))
                                    if post then
                                        if not IsPedSittingInAnyVehicle(PlayerPed) then
                                            TriggerServerEvent('esx:removeInventoryItem', 'item_standard', MDscript.ItemSelected.name, quantity)
                                            --RageUI.CloseAll()
                                        end
                                    end
                                end
                            end
                        end)

                        RageUI.Button("Donner l'item ", nil, {RightBadge = RageUI.BadgeStyle.Tick}, true, function(Hovered, Active, Selected)
                            if (Selected) then
                                local sonner,quantity = CheckQuantity(KeyboardInput("Nombres d'items que vous voulez donner", '', '', 3))
                                local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
                                local pPed = GetPlayerPed(-1)
                                local coords = GetEntityCoords(pPed)
                                local x,y,z = table.unpack(coords)
                                DrawMarker(2, x, y, z+1.5, 0, 0, 0, 180.0,nil,nil, 0.5, 0.5, 0.5, 0, 0, 255, 120, true, true, p19, true)
            
                                if sonner then
                                    if closestDistance ~= -1 and closestDistance <= 3 then
                                        local closestPed = GetPlayerPed(closestPlayer)
            
                                        if IsPedOnFoot(closestPed) then
                                                TriggerServerEvent('esx:giveInventoryItem', GetPlayerServerId(closestPlayer), 'item_standard', MDscript.ItemSelected.name, quantity)
                                                --RageUI.CloseAll()
                                            else
                                                ShowAboveRadarMessage("~∑~ Nombres d'items invalid !")
                                            end
                                        --else
                                            --ShowAboveRadarMessage("~∑~ Tu ne peux pas donner d'items dans un véhicule !", MDscript.ItemSelected.label
                                    else
                                        ShowAboveRadarMessage("∑ Aucun joueur ~r~Proche~n~ !")
                                        end
                                    end
                                end
                            end)
                        end,function()
                    end)

			RageUI.IsVisible(RMenu:Get('location', 'weapon_use'), true, true, true, function() 
			local plyPed = PlayerPedId()
                    RageUI.Button('Donner des ~b~munitions', nil, {RightBadge = RageUI.BadgeStyle.Ammo}, true, function(Hovered, Active, Selected)
                        if (Selected) then
                            local post, quantity = CheckQuantity(KeyboardInput('Nombre de munitions', 'Nombre de munitions'), '', 10)
    
                            if post then
                                local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
    
                                if closestDistance ~= -1 and closestDistance <= 3 then
                                    local closestPed = GetPlayerPed(closestPlayer)
                                    local pPed = GetPlayerPed(-1)
                                    local coords = GetEntityCoords(pPed)
                                    local x,y,z = table.unpack(coords)
                                    DrawMarker(2, x, y, z+1.5, 0, 0, 0, 180.0,nil,nil, 0.5, 0.5, 0.5, 0, 0, 255, 120, true, true, p19, true)
    
                                    if IsPedOnFoot(closestPed) then
                                        local ammo = GetAmmoInPedWeapon(plyPed, MDscript.ItemSelected.hash)
    
                                        if ammo > 0 then
                                            if quantity <= ammo and quantity >= 0 then
                                                local finalAmmo = math.floor(ammo - quantity)
                                                SetPedAmmo(plyPed, MDscript.ItemSelected.name, finalAmmo)
    
                                                TriggerServerEvent('KorioZ-PersonalMenu:Weapon_addAmmoToPedS', GetPlayerServerId(closestPlayer), PersonalMenu.ItemSelected.name, quantity)
                                                ShowAboveRadarMessage('Vous avez donné x%s munitions à %s', quantity, GetPlayerName(closestPlayer))
                                                --RageUI.CloseAll()
                                            else
                                                ShowAboveRadarMessage('Vous ne possédez pas autant de munitions')
                                            end
                                        else
                                            ShowAboveRadarMessage("Vous n'avez pas de munition")
                                        end
                                    else
                                        ShowAboveRadarMessage('Vous ne pouvez pas donner des munitions dans un ~~r~véhicule~s~', MDscript.ItemSelected.label)
                                    end
                                else
                                    ShowAboveRadarMessage('Aucun joueur ~r~proche~s~ !')
                                end
                            else
                                ShowAboveRadarMessage('Nombre de munition ~r~invalid')
                            end
                        end
                    end)
                    
                    RageUI.Button("Jeter ~b~l'arme", nil, {RightBadge = RageUI.BadgeStyle.Gun}, true, function(Hovered, Active, Selected)
                        if Selected then
                            if IsPedOnFoot(plyPed) then
                                TriggerServerEvent('esx:removeInventoryItem', 'item_weapon', MDscript.ItemSelected.name)
                                --RageUI.CloseAll()
                            else
                                ShowAboveRadarMessage("~r~Impossible~s~ de jeter l'armes dans un véhicule", MDscript.ItemSelected.label)
                            end
                        end
                    end)

                    if HasPedGotWeapon(plyPed, MDscript.ItemSelected.hash, false) then
                        RageUI.Button("Donner ~b~l'arme", nil, {RightBadge = RageUI.BadgeStyle.Gun}, true, function(Hovered, Active, Selected)
                            if Selected then
                                local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
    
                            if closestDistance ~= -1 and closestDistance <= 3 then
                                local closestPed = GetPlayerPed(closestPlayer)
                                local pPed = GetPlayerPed(-1)
                                local coords = GetEntityCoords(pPed)
                                local x,y,z = table.unpack(coords)
                                DrawMarker(2, x, y, z+1.5, 0, 0, 0, 180.0,nil,nil, 0.5, 0.5, 0.5, 0, 0, 255, 120, true, true, p19, true)
    
                                if IsPedOnFoot(closestPed) then
                                    local ammo = GetAmmoInPedWeapon(plyPed, MDscript.ItemSelected.hash)
                                    TriggerServerEvent('esx:giveInventoryItem', GetPlayerServerId(closestPlayer), 'item_weapon', MDscript.ItemSelected.name, ammo)
                                    --seAll()
                                else
                                    ShowAboveRadarMessage('~r~Impossible~s~ de donner une arme dans un véhicule', MDscript.ItemSelected.label)
                                end
                            else
                                ShowAboveRadarMessage('Aucun joueur ~r~proche !')
                            end
                        end
                    end)
                end
			end, function()
			end)
			
			 RageUI.IsVisible(RMenu:Get('location', 'habil'), true, true, true, function()

                    
					RageUI.Button("			         ~r~↓ ~s~Vos Vètement ~r~↓", nil, {RightLabel = nil}, true, function(Hovered, Active, Selected)
						if (Selected) then

						end
					end)
                    local pPed = PlayerPedId()

                    RageUI.Button("Haut", nil, {RightBadge = RageUI.BadgeStyle.Clothes}, true, function(Hovered,Active,Selected) 
                        if Selected then
                            setUniform("torso", pPed)
                        end
                    end)

                    RageUI.Button("Pantalon", nil, {RightBadge = RageUI.BadgeStyle.Clothes}, true, function(Hovered,Active,Selected) 
                        if Selected then
                            setUniform("pants", pPed)
                        end
                    end)

                    RageUI.Button("Chaussure", nil, {RightBadge = RageUI.BadgeStyle.Clothes}, true, function(Hovered,Active,Selected) 
                        if Selected then
                            setUniform("shoes", pPed)
                        end
                    end)

                    RageUI.Button("Sac", nil, {RightBadge = RageUI.BadgeStyle.Clothes}, true, function(Hovered,Active,Selected) 
                        if Selected then
                            setUniform("bag", pPed)
                        end
                    end)

                    RageUI.Button("Gilet par balle", nil, {RightBadge = RageUI.BadgeStyle.Armour}, true, function(Hovered,Active,Selected) 
                        if Selected then
                            setUniform("bproof", pPed)
                        end
                    end)

                   
					RageUI.Button("			         ~r~↓ ~s~Vos Accessoire ~r~↓", nil, {RightLabel = nil}, true, function(Hovered, Active, Selected)
						if (Selected) then

						end
					end)
                    RageUI.Button("Casque", nil, {RightBadge = RageUI.BadgeStyle.Clothes}, true, function(Hovered,Active,Selected) 
                        if Selected then
                            Citizen.Wait(1000);
                            ClearPedTasks(PlayerPedId());
                            ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin1)
                                    TriggerEvent('skinchanger:getSkin', function(skin2)
                                    if skin1.helmet_1 ~= skin2.helmet_1 then
                                        TriggerEvent('skinchanger:loadClothes', skin2, {['helmet_1'] = skin1.helmet_1, ['helmet_2'] = skin1.helmet_2});
                                    else
                                        TriggerEvent('skinchanger:loadClothes', skin2, {['helmet_1'] = -1, ['helmet_2'] = 0});
                                    end
                                end)
                            end)
                        end
                    end)

                    RageUI.Button("Masque", nil, {RightBadge = RageUI.BadgeStyle.Mask}, true, function(Hovered,Active,Selected) 
                        if Selected then
                            Citizen.Wait(1000);
                            ClearPedTasks(PlayerPedId());
                            ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin1)
                                TriggerEvent('skinchanger:getSkin', function(skin2)
                                    if skin1.mask_1 ~= skin2.mask_1 then
                                        TriggerEvent('skinchanger:loadClothes', skin2, {['mask_1'] = skin1.mask_1, ['mask_2'] = skin1.mask_2});
                                    else
                                        TriggerEvent('skinchanger:loadClothes', skin2, {['mask_1'] = 0, ['mask_2'] = 0});
                                    end
                                end)
                            end)
                        end
                    end)

                    RageUI.Button("Boucle d'oreilles", nil, {RightBadge = RageUI.BadgeStyle.Clothes}, true, function(Hovered,Active,Selected) 
                        if Selected then
                            Citizen.Wait(1000);
                            ClearPedTasks(PlayerPedId());
                            ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin1)
                                TriggerEvent('skinchanger:getSkin', function(skin2)
                                    if skin1.ears_1 ~= skin2.ears_1 then
                                        TriggerEvent('skinchanger:loadClothes', skin2, {['ears_1'] = skin1.ears_1, ['ears_2'] = skin1.ears_2});
                                    else
                                        TriggerEvent('skinchanger:loadClothes', skin2, {['ears_1'] = -1, ['ears_2'] = 0});
                                    end
                                end)
                            end)
                        end
                    end)

                    RageUI.Button("Lunette", nil, {RightBadge = RageUI.BadgeStyle.Clothes}, true, function(Hovered,Active,Selected) 
                        if Selected then
                            Citizen.Wait(1000);
                            ClearPedTasks(PlayerPedId());
                            ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin1)
                                TriggerEvent('skinchanger:getSkin', function(skin2)
                                    if skin1.glasses_1 ~= skin2.glasses_1 then
                                        TriggerEvent('skinchanger:loadClothes', skin2, {['glasses_1'] = skin1.glasses_1, ['glasses_2'] = skin1.glasses_2});
                                    else
                                        TriggerEvent('skinchanger:loadClothes', skin2, {['glasses_1'] = 0, ['glasses_2'] = 0});
                                    end
                                end)
                            end)
                        end
                    end)
                    end, function()
                end)

			RageUI.IsVisible(RMenu:Get('location', 'papier'), true, true, true, function()

-- 	carte identité
				RageUI.Button("			   ~b~↓ ~s~Carte identité ~b~↓", nil, {RightLabel = nil}, true, function(Hovered, Active, Selected)
					if (Selected) then

					end
				end)
				RageUI.Button("~b~Regarder sa ~g~carte identité", nil, {RightLabel = nil}, true, function(Hovered, Active, Selected)
					if (Selected) then
						TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(PlayerId()))
						
					end
				end)
				
				RageUI.Button('~b~Montrer sa ~g~carte d\'identité', nil, {}, true, function(Hovered, Active, Selected)
					if (Selected) then
						local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

						if closestDistance ~= -1 and closestDistance <= 3.0 then
							TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(closestPlayer))
						else
							ESX.ShowNotification('Aucun joueur à proximité')
						end
					end
				end)
-- 	Permis de conduire			
				RageUI.Button("	             ~b~↓ ~s~Permis de conduire ~b~↓", nil, {RightLabel = nil}, true, function(Hovered, Active, Selected)
					if (Selected) then

					end
				end)
				
				RageUI.Button('~b~Regarder son ~g~permis de conduire', nil, {}, true, function(Hovered, Active, Selected)
					if (Selected) then
						TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(PlayerId()), 'driver')
					end
				end)
				
				RageUI.Button('~b~Montrer son ~g~permis de conduire', nil, {}, true, function(Hovered, Active, Selected)
					if (Selected) then
						local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

						if closestDistance ~= -1 and closestDistance <= 3.0 then
							TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(closestPlayer), 'driver')
						else
							ESX.ShowNotification('Aucun joueur à proximité')
						end
					end
				end)
-- 	Permis moto		
			if Config.permismoto == true then
				RageUI.Button("			   ~b~↓ ~s~Permis moto ~b~↓", nil, {RightLabel = nil}, true, function(Hovered, Active, Selected)
					if (Selected) then

					end
				end)
				
				RageUI.Button('~b~Regarder son ~g~permis moto', nil, {}, true, function(Hovered, Active, Selected)
					if (Selected) then
						TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(PlayerId()), 'drive_bike')
					end
				end)
				
				RageUI.Button('~b~Montrer son ~g~permis moto', nil, {}, true, function(Hovered, Active, Selected)
					if (Selected) then
						local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

						if closestDistance ~= -1 and closestDistance <= 3.0 then
							TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(closestPlayer), 'drive_bike')
						else
							ESX.ShowNotification('Aucun joueur à proximité')
						end
					end
				end)
			end
-- 	Permis avion	
			if Config.permisavion == true then
				RageUI.Button("			   ~b~↓ ~s~Permis avion ~b~↓", nil, {RightLabel = nil}, true, function(Hovered, Active, Selected)
					if (Selected) then

					end
				end)
				
			end
-- 	Permis Bateau	
			if Config.permisbateau == true then
				RageUI.Button("			   ~b~↓ ~s~Permis Bateau ~b~↓", nil, {RightLabel = nil}, true, function(Hovered, Active, Selected)
					if (Selected) then

					end
				end)
				
			end
-- 	Permis camion	

			if Config.permiscamion == true then
				RageUI.Button("			 ~b~↓ ~s~Permis camion ~b~↓", nil, {RightLabel = nil}, true, function(Hovered, Active, Selected)
					if (Selected) then

					end
				end)
				
				RageUI.Button('~b~Regarder son ~g~permis camion', nil, {}, true, function(Hovered, Active, Selected)
					if (Selected) then
						TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(PlayerId()), 'drive_truck')
					end
				end)
				
				RageUI.Button('~b~Montrer son ~g~permis camion', nil, {}, true, function(Hovered, Active, Selected)
					if (Selected) then
						local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

						if closestDistance ~= -1 and closestDistance <= 3.0 then
							TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(closestPlayer), 'drive_truck')
						else
							ESX.ShowNotification('Aucun joueur à proximité')
						end
					end
				end)
			end
				
-- 	PPA
				
				RageUI.Button("			       ~b~↓ ~s~PPA ~b~↓", nil, {RightLabel = nil}, true, function(Hovered, Active, Selected)
					if (Selected) then

					end
				end)
				
				RageUI.Button('~b~Regarder son ~r~permis port d\'armes', nil, {}, true, function(Hovered, Active, Selected)
					if (Selected) then
						TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(PlayerId()), 'weapon')
					end
				end)
				
				RageUI.Button('~b~Montrer son ~r~permis port d\'armes', nil, {}, true, function(Hovered, Active, Selected)
					if (Selected) then
						local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

						if closestDistance ~= -1 and closestDistance <= 3.0 then
							TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(closestPlayer), 'weapon')
						else
							ESX.ShowNotification('Aucun joueur à proximité')
						end
					end
					
				end)

				 end, function()
			end)
		
			RageUI.IsVisible(RMenu:Get('location', 'Divers'), true, true, true, function()

					
                    RageUI.Checkbox("~g~Afficher~s~ / ~r~Désactiver~s~ la map", description, MDscript.map,{},function(Hovered,Ative,Selected,Checked)
                        if Selected then
                            MDscript.map = Checked
                            if Checked then
                                DisplayRadar(true)
								
                            else
                                DisplayRadar(false)
                            end
                        end
                    end)
					
					
					RageUI.Checkbox("~g~Activer~s~ / ~r~Désactiver~s~ le mode Cinématique", description, MDscript.cinema,{},function(Hovered,Ative,Selected,Checked)
                        if Selected then
                            MDscript.cinema = Checked
                            if Checked then
                                hasCinematic = true
								DisplayRadar(false)
								
                             else
                                 hasCinematic = false
								 DisplayRadar(true)
								 
                            end
                        end
                    end)
					
					
                    local ragdolling = false
                    RageUI.Button('~g~Dormir~s~ / ~r~Se Reveiller', description, {RightLabel = ""}, true, function(Hovered, Active, Selected) 
                        if (Selected) then
                            ragdolling = not ragdolling
                            while ragdolling do
                             Wait(0)
                            local myPed = GetPlayerPed(-1)
                            SetPedToRagdoll(myPed, 1000, 1000, 0, 0, 0, 0)
                            ResetPedRagdollTimer(myPed)
                            AddTextEntry(GetCurrentResourceName(), ('Appuyez sur ~INPUT_JUMP~ pour vous ~b~Réveillé'))
                            DisplayHelpTextThisFrame(GetCurrentResourceName(), false)
                            ResetPedRagdollTimer(myPed)
                            if IsControlJustPressed(0, 22) then 
								break
							end
						end	
					end
					end)
				if Config.PrendreOtage == true then
					RageUI.Button("Prendre en ~r~Otage", description, {RightLabel = ""}, true, function(Hovered, Active, Selected) 
						if (Selected) then 
							ExecuteCommand(Config.commandeotage)
						end 
					end)
				end
				if Config.PrendreDos == true then
					RageUI.Button("Prendre sur le ~b~Dos", description, {RightLabel = ""}, true, function(Hovered, Active, Selected) 
						if (Selected) then 
							ExecuteCommand(Config.commandedos)
						end 
					end)
				end
				RageUI.Button("				   ~b~↓ ~s~Crédit ~b~↓", description, {RightLabel = ""}, true, function(Hovered, Active, Selected) 
					if (Selected) then 
						
					end 
				end)
				RageUI.Button("				  ~b~Mathéo#2802~b~", description, {RightLabel = ""}, true, function(Hovered, Active, Selected) 
					if (Selected) then 
						
					end 
				end)
				
				
			end, function()
			end)
			
-- PORTEFEUUILLE          
			RageUI.IsVisible(RMenu:Get('location', 'portefeuille'), true, true, true, function()

				RageUI.Button("				  ~b~↓ ~s~Métiers ~b~↓", nil, {RightLabel = nil}, true, function(Hovered, Active, Selected)
					if (Selected) then

					end
				end)
				
				RageUI.Button("~b~Emplois", nil, {RightLabel = "~s~[ "..ESX.PlayerData.job.label .. " : "..ESX.PlayerData.job.grade_label .." ~s~]"}, true, function(Hovered, Active, Selected)
                        if Selected then
                        end
                    end)
					
				if Config.DoubleJob then
					RageUI.Button("~b~Organisation", nil, {RightLabel = "~s~[ "..ESX.PlayerData.job2.label .. " : "..ESX.PlayerData.job2.grade_label .." ~s~]"}, true, function(Hovered, Active, Selected)
                        if Selected then
                        end
                    end)
				end
				
				RageUI.Button("			     ~b~↓ ~s~Portefeuille ~b~↓", nil, {RightLabel = nil}, true, function(Hovered, Active, Selected)
					if (Selected) then

					end
				end)
				
				RageUI.Button("~g~Liquide", nil, {RightLabel = "~g~"..ESX.Math.GroupDigits(ESX.PlayerData.money.." $ ~s~ →")}, true, function(Hovered, Active, Selected)
					if (Selected) then
						
					end
				end, RMenu:Get('location', 'portefeuille_money'))
		
			for i = 1, #ESX.PlayerData.accounts, 1 do
				if Config.menubanque == true then
					if ESX.PlayerData.accounts[i].name == 'bank' then
						RageUI.Button("~b~Argent en banque", nil, {RightLabel = "~b~"..ESX.Math.GroupDigits(ESX.PlayerData.accounts[i].money.." $")}, true, function(Hovered, Active, Selected)
							if (Selected) then
								
							end
						end)
					end
				end
			end

				for i = 1, #ESX.PlayerData.accounts, 1 do
					if ESX.PlayerData.accounts[i].name == 'black_money'  then
						MDscript.sale = RageUI.Button("~r~Argent Non déclaré", nil, {RightLabel = "~r~"..ESX.Math.GroupDigits(ESX.PlayerData.accounts[i].money.. " $ ~s~ →")}, true, function(Hovered, Active, Selected)
							if (Selected) then
								
							end
						end, RMenu:Get('location', 'portefeuille_use'))
					end
				end
			
			if Config.menufacture == true then
					RageUI.Button("		     ~b~↓ ~s~Vos factures impayer(s) ~b~↓", nil, {RightLabel = nil}, true, function(Hovered, Active, Selected)
						if (Selected) then
						
						end
					end)
				ESX.TriggerServerCallback('VInventory:billing', function(bills) MDscript.billing = bills end)
			
			
				if #MDscript.billing == 0 then
					RageUI.Button("		              ~g~~h~Aucune facture", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
								
						end
					end)
				end
				
				for i = 1, #MDscript.billing, 1 do
					RageUI.Button(MDscript.billing[i].label, nil, {RightLabel = '[~b~$' .. ESX.Math.GroupDigits(MDscript.billing[i].amount.."~s~] →")}, true, function(Hovered,Active,Selected)
							if (Selected) then
								ESX.TriggerServerCallback('esx_billing:payBill', function()
									ESX.TriggerServerCallback('MD-MenuF5:Bill_getBills', function(bills)
										MDscript.BillData = bills
									end)
								end, MDscript.billing[i].id)
							end
                        end)
                end
				RageUI.Button("		     ~b~↑ ~s~Vos factures impayer(s) ~b~ ↑", nil, {RightLabel = nil}, true, function(Hovered, Active, Selected)
						if (Selected) then
						
						end
					end)
			end
				
			end, function()
		    end)
			
			
			RageUI.IsVisible(RMenu:Get('location', 'Gestion_car'), true, true, true, function()
        
                     local pPed = PlayerPedId()
                     local pVeh = GetVehiclePedIsUsing(pPed)
                     local MDscriptodel = GetEntityModel(pVeh)
                     local vName = GetDisplayNameFromVehicleModel(MDscriptodel)

                     local plyVeh = GetVehiclePedIsIn(pPed, false)

                     GetSourcevehicle = GetVehiclePedIsIn(GetPlayerPed(-1), false)
                     Vengine = GetVehicleEngineHealth(GetSourcevehicle)/10
                     local Vengine2 = math.floor(Vengine)
					 
			
                    RageUI.Button("Nom véhicule :", nil, {RightLabel = "~b~[ ~w~"..vName.. " ~b~]"}, true, function(Hovered,Active,Selected)
                        if Selected then
                        end
                    end)

                     RageUI.Button("Etat du moteur :", nil, {RightLabel = "~b~[ ~w~"..Vengine2.."% ~b~]"}, true, function(Hovered,Active,Selected)
                         if Selected then
                         end
                     end)

                    RageUI.Button("Allumer/Eteindre votre moteur", nil, {RightBadge = RageUI.BadgeStyle.Car}, true, function(Hovered,Active,Selected) 
                        if Selected then
                            if GetIsVehicleEngineRunning(GetSourcevehicle) then
                                SetVehicleEngineOn(GetSourcevehicle, false, false, true)
                                SetVehicleUndriveable(GetSourcevehicle, true)
                            elseif not GetIsVehicleEngineRunning(GetSourcevehicle) then
                                SetVehicleEngineOn(GetSourcevehicle, true, false, true)
                                SetVehicleUndriveable(GetSourcevehicle, false)
                            end
                        end
                    end)

					RageUI.List("Limitateur", MDscript.voiture_limite, MDscript.LimitateurIndex, nil, {}, true, function(Hovered, Active, Selected, Index)
						if (Selected) then
                            if Index == 1 then
							
                                SetEntityMaxSpeed(GetVehiclePedIsIn(PlayerPedId(), false), 30.0/3.6)
								ESX.ShowNotification("Limitateur de vitesse défini sur ~b~30 km/h")
							elseif Index == 2 then
								SetEntityMaxSpeed(GetVehiclePedIsIn(PlayerPedId(), false), 50.0/3.6)
								ESX.ShowNotification("Limitateur de vitesse défini sur ~b~50 km/h")
                                
                            elseif Index == 3 then
                               SetEntityMaxSpeed(GetVehiclePedIsIn(PlayerPedId(), false), 80.0/3.6)
								ESX.ShowNotification("Limitateur de vitesse défini sur ~b~80 km/h")
                            elseif Index == 4 then
                                SetEntityMaxSpeed(GetVehiclePedIsIn(PlayerPedId(), false), 100.0/3.6)
								ESX.ShowNotification("Limitateur de vitesse défini sur ~b~100 km/h")
                            elseif Index == 5 then
                                SetEntityMaxSpeed(GetVehiclePedIsIn(PlayerPedId(), false), 120.0/3.6)
								ESX.ShowNotification("Limitateur de vitesse défini sur ~b~120 km/h")
							elseif Index == 6 then
                                SetEntityMaxSpeed(GetVehiclePedIsIn(PlayerPedId(), false), 150.0/3.6)
								ESX.ShowNotification("Limitateur de vitesse défini sur ~b~150 km/h")
							elseif Index == 7 then
                                SetEntityMaxSpeed(GetVehiclePedIsIn(PlayerPedId(), false), 10000.0/3.6)    
								ESX.ShowNotification("Limitateur de vitesse désactivé")
                            end
                        end
            
                        MDscript.LimitateurIndex = Index
                    end)

                    RageUI.List("Gestion des portes", MDscript.vehList, MDscript.vehIndex, nil, {}, true, function(Hovered, Active, Selected, Index)
                        if (Selected) then        
                            if Index == 1 then
                                if not MDscript.DoorState.FrontLeft then
                                    MDscript.DoorState.FrontLeft = true
                                    SetVehicleDoorOpen(plyVeh, 0, false, false)
                                elseif MDscript.DoorState.FrontLeft then
                                    MDscript.DoorState.FrontLeft = false
                                    SetVehicleDoorShut(plyVeh, 0, false, false)
                                end
                            elseif Index == 2 then
                                if not MDscript.DoorState.FrontRight then
                                    MDscript.DoorState.FrontRight = true
                                    SetVehicleDoorOpen(plyVeh, 1, false, false)
                                elseif MDscript.DoorState.FrontRight then
                                    MDscript.DoorState.FrontRight = false
                                    SetVehicleDoorShut(plyVeh, 1, false, false)
                                end
                            elseif Index == 3 then
                                if not MDscript.DoorState.BackLeft then
                                    MDscript.DoorState.BackLeft = true
                                    SetVehicleDoorOpen(plyVeh, 2, false, false)
                                elseif MDscript.DoorState.BackLeft then
                                    MDscript.DoorState.BackLeft = false
                                    SetVehicleDoorShut(plyVeh, 2, false, false)
                                end
                            elseif Index == 4 then
                                if not MDscript.DoorState.BackRight then
                                    MDscript.DoorState.BackRight = true
                                    SetVehicleDoorOpen(plyVeh, 3, false, false)
                                elseif MDscript.DoorState.BackRight then
                                    MDscript.DoorState.BackRight = false
                                    SetVehicleDoorShut(plyVeh, 3, false, false)
                                end
                            end		 
                        end
                        MDscript.vehIndex = Index
                    end)

                    RageUI.List("Gestion des fenêtres", MDscript.vehList2, MDscript.vehIndex2, nil, {}, true, function(Hovered, Active, Selected, Index)
                        if (Selected) then
                            if Index == 1 then
                                if not MDscript.WindowState.FrontLeft then
                                    MDscript.WindowState.FrontLeft = true
                                    RollUpWindow(plyVeh, 1)
                                elseif MDscript.WindowState.FrontLeft then
                                    MDscript.WindowState.FrontLeft = false
                                    RollDownWindow(plyVeh, 1)
                                 end
                            elseif Index == 2 then
                                if not MDscript.WindowState.FrontRight then
                                    MDscript.WindowState.FrontRight = true
                                    RollUpWindow(plyVeh, 2)
                                elseif MDscript.WindowState.FrontRight then
                                    MDscript.WindowState.FrontRight = false
                                    RollDownWindow(plyVeh, 2)
                                end
                            elseif Index == 3 then
                                if not MDscript.WindowState.BackLeft then
                                    MDscript.WindowState.BackLeft = true
                                    RollUpWindow(plyVeh, 3)
                                elseif MDscript.WindowState.BackLeft then
                                    MDscript.WindowState.BackLeft = false
                                    RollDownWindow(plyVeh, 3)
                                end
                            elseif Index == 4 then
                                if not MDscript.WindowState.BackRight then
                                    MDscript.WindowState.BackRight = true
                                    RollUpWindow(plyVeh, 4)
                                elseif MDscript.WindowState.BackRight then
                                    MDscript.WindowState.BackRight = false
                                    RollDownWindow(plyVeh, 4)
                                end
                            end
                        end
            
                        MDscript.vehIndex2 = Index
                    end)
                    RageUI.Button("Ouvrir/Fermer le capot", nil, {RightBadge = RageUI.BadgeStyle.Car}, true, function(Hovered,Active,Selected) 
                        if Selected then
					        if not MDscript.DoorState.Hood then
					        	MDscript.DoorState.Hood = true
					        	SetVehicleDoorOpen(plyVeh, 4, false, false)
					        elseif MDscript.DoorState.Hood then
					        	MDscript.DoorState.Hood = false
					        	SetVehicleDoorShut(plyVeh, 4, false, false)
					        end
                        end
                    end)
                    RageUI.Button("Ouvrir/Fermer le coffre", nil, {RightBadge = RageUI.BadgeStyle.Car}, true, function(Hovered,Active,Selected) 
                        if Selected then
                            if not MDscript.DoorState.Trunk then
                                MDscript.DoorState.Trunk = true
                                SetVehicleDoorOpen(plyVeh, 5, false, false)
                            elseif MDscript.DoorState.Trunk then
                                MDscript.DoorState.Trunk = false
                                SetVehicleDoorShut(plyVeh, 5, false, false)
                            end
                        end
                    end)

					
           
			end, function()
			end)

-- GESTION ARGENT PORTEFEUILLE
			RageUI.IsVisible(RMenu:Get('location', 'portefeuille_money'), true, true, true, function()

                    RageUI.Button("~b~Donner~s~ de l'argent ~b~liquide", nil, {RightBadge = RageUI.BadgeStyle.Lock}, true, function(Hovered,Active,Selected)
                        if Selected then
                            local black, quantity = CheckQuantity(KeyboardInput("", 'Somme d\'argent que vous voulez donner', '', 9))
                                if black then
                                    local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

									if closestDistance ~= -1 and closestDistance <= 3 then
										local closestPed = GetPlayerPed(closestPlayer)

									
										if not IsPedSittingInAnyVehicle(closestPed) then
											TriggerServerEvent('esx:giveInventoryItem', GetPlayerServerId(closestPlayer), 'item_money', ESX.PlayerData.money, quantity)
											--RageUI.CloseAll()
										else
										   ShowAboveRadarMessage(_U('Vous ne pouvez pas donner ', 'de l\'argent dans un véhicles'))
										end
									else
									   ShowAboveRadarMessage('Aucun joueur proche !')
									end
								else
								   ShowAboveRadarMessage('Somme invalid')
								end
						end
					end)
			
			
				RageUI.Button("~b~Jeter~s~ de l'argent ~b~liquide", nil, {RightBadge = RageUI.BadgeStyle.Tick}, true, function(Hovered, Active, Selected)
                    if Selected then
                        local black, quantity = CheckQuantity(KeyboardInput("", 'Somme d\'argent que vous voulez jeter', '', 9))
                        if black then
                            if not IsPedSittingInAnyVehicle(PlayerPed) then
                                TriggerServerEvent('esx:removeInventoryItem', 'item_money', ESX.PlayerData.money, quantity)
                                --RageUI.CloseAll()
                            else
                                ShowAboveRadarMessage('Vous pouvez pas jeter', 'de l\'argent')
                            end
                        else
                            ShowAboveRadarMessage('Somme Invalid')
                        end
                    end
                end)
				
				
			end, function()
			end)
			
			RageUI.IsVisible(RMenu:Get('location', 'portefeuille_use'), true, true, true, function() 

                    for i = 1, #ESX.PlayerData.accounts, 1 do
                        if ESX.PlayerData.accounts[i].name == 'black_money' then
                            RageUI.Button("~b~Donner~s~ de l'argent ~r~non-déclaré", nil, {RightBadge = RageUI.BadgeStyle.Lock}, true, function(Hovered,Active,Selected)
                                if Selected then
                                    local black, quantity = CheckQuantity(KeyboardInput("Somme d'argent que vous voulez donner", '', '', 9))
                                        if black then
                                            local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
    
                                    if closestDistance ~= -1 and closestDistance <= 3 then
                                        local closestPed = GetPlayerPed(closestPlayer)
    
                                        if not IsPedSittingInAnyVehicle(closestPed) then
                                            TriggerServerEvent('esx:giveInventoryItem', GetPlayerServerId(closestPlayer), 'item_account', ESX.PlayerData.accounts[i].name, quantity)
                                            --RageUI.CloseAll()
                                        else
                                           ShowAboveRadarMessage(_U('Vous ne pouvez pas donner ', 'de l\'argent dans un véhicles'))
                                        end
                                    else
                                       ShowAboveRadarMessage('Aucun joueur proche !')
                                    end
                                else
                                   ShowAboveRadarMessage('Somme invalid')
                                end
                            end
                        end)
    
                        RageUI.Button("~b~Jeter~s~ de l'argent ~r~non declaré", nil, {RightBadge = RageUI.BadgeStyle.Tick}, true, function(Hovered, Active, Selected)
                            if Selected then
                                local black, quantity = CheckQuantity(KeyboardInput("Somme d'argent que vous voulez jeter", '', '', 9))
                                if black then
                                    if not IsPedSittingInAnyVehicle(PlayerPed) then
                                        TriggerServerEvent('esx:removeInventoryItem', 'item_account', ESX.PlayerData.accounts[i].name, quantity)
                                       -- RageUI.CloseAll()
									else
									   ShowAboveRadarMessage('Vous pouvez pas jeter', 'de l\'argent')
										end
									else
									   ShowAboveRadarMessage('Somme Invalid')
									end
								end
							end)
						end
					end
				end)
			
			
	
-- GESTION ENTREPRISE 			
			RageUI.IsVisible(RMenu:Get('location', 'Gestionentreprise'), true, true, true, function()
				
				
				RageUI.Button('Recruter', nil, {}, true, function(Hovered, Active, Selected)
					if (Selected) then
						if ESX.PlayerData.job.grade_name == 'boss' then
						local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

							if closestPlayer == -1 or closestDistance > 3.0 then
								ESX.ShowNotification('Aucun joueur à proximité')
							else
								TriggerServerEvent('MD-MenuF5:Boss_recruterplayer', GetPlayerServerId(closestPlayer), ESX.PlayerData.job.name, 0)
							end
						else
							ESX.ShowNotification('Vous n\'avez pas les ~r~droits~w~')
						end
					end
				end)

				RageUI.Button('Promouvoir', nil, {}, true, function(Hovered, Active, Selected)
					if (Selected) then
						if ESX.PlayerData.job.grade_name == 'boss' then
						local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

							if closestPlayer == -1 or closestDistance > 3.0 then
								ESX.ShowNotification('Aucun joueur à proximité')
							else
								TriggerServerEvent('MD-MenuF5:promouvoirplayer', GetPlayerServerId(closestPlayer))
								print('test')
							end
						else
							ESX.ShowNotification('Vous n\'avez pas les ~r~droits~w~')
						end
					end
				end)

				RageUI.Button('Destituer', nil, {}, true, function(Hovered, Active, Selected)
					if (Selected) then
						if ESX.PlayerData.job.grade_name == 'boss' then
							local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

							if closestPlayer == -1 or closestDistance > 3.0 then
								ESX.ShowNotification('Aucun joueur à proximité')
							else
								TriggerServerEvent('MD-MenuF5:Boss_destituerplayer', GetPlayerServerId(closestPlayer))
							end
						else
							ESX.ShowNotification('Vous n\'avez pas les ~r~droits~w~')
						end
					end
				end)
				
				RageUI.Button('Viré', nil, {}, true, function(Hovered, Active, Selected)
					if (Selected) then
						if ESX.PlayerData.job.grade_name == 'boss' then
							local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

							if closestPlayer == -1 or closestDistance > 3.0 then
								ESX.ShowNotification('Aucun joueur à proximité')
							else
								TriggerServerEvent('MD-MenuF5:Boss_virerplayer', GetPlayerServerId(closestPlayer))
							end
						else
							ESX.ShowNotification('Vous n\'avez pas les ~r~droits~w~')
						end
					end
				end)
			end, function()
			end)
-- ORGA 
			RageUI.IsVisible(RMenu:Get('location', 'Gestionorga'), true, true, true, function()
				
				
				RageUI.Button('Recruter', nil, {}, true, function(Hovered, Active, Selected)
					if (Selected) then
						if ESX.PlayerData.job2.grade_name == 'boss' then
						local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

							if closestPlayer == -1 or closestDistance > 3.0 then
								ESX.ShowNotification('Aucun joueur à proximité')
							else
								TriggerServerEvent('MD-MenuF5:Boss_recruterplayer2', GetPlayerServerId(closestPlayer), ESX.PlayerData.job2.name, 0)
							end
						else
							ESX.ShowNotification('Vous n\'avez pas les ~r~droits~w~')
						end
					end
				end)

				RageUI.Button('Promouvoir', nil, {}, true, function(Hovered, Active, Selected)
					if (Selected) then
						if ESX.PlayerData.job2.grade_name == 'boss' then
						local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

							if closestPlayer == -1 or closestDistance > 3.0 then
								ESX.ShowNotification('Aucun joueur à proximité')
							else
								TriggerServerEvent('MD-MenuF5:Boss_promouvoirplayer2', GetPlayerServerId(closestPlayer))
							end
						else
							ESX.ShowNotification('Vous n\'avez pas les ~r~droits~w~')
						end
					end
				end)

				RageUI.Button('Destituer', nil, {}, true, function(Hovered, Active, Selected)
					if (Selected) then
						if ESX.PlayerData.job2.grade_name == 'boss' then
							local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

							if closestPlayer == -1 or closestDistance > 3.0 then
								ESX.ShowNotification('Aucun joueur à proximité')
							else
								TriggerServerEvent('MD-MenuF5:Boss_destituerplayer2', GetPlayerServerId(closestPlayer))
							end
						else
							ESX.ShowNotification('Vous n\'avez pas les ~r~droits~w~')
						end
					end
				end)
				
				RageUI.Button('Viré', nil, {}, true, function(Hovered, Active, Selected)
					if (Selected) then
						if ESX.PlayerData.job2.grade_name == 'boss' then
							local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

							if closestPlayer == -1 or closestDistance > 3.0 then
								ESX.ShowNotification('Aucun joueur à proximité')
							else
								TriggerServerEvent('MD-MenuF5:Boss_virerplayer2', GetPlayerServerId(closestPlayer))
							end
						else
							ESX.ShowNotification('Vous n\'avez pas les ~r~droits~w~')
						end
					end
				end)


			
        end, function()
        end, 1)	
            Citizen.Wait(0)
        end
    end)







