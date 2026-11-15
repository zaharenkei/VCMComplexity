local function captureInjuredBodyParts(character)
    local injuredParts = {}
    local bodyParts = character:getBodyDamage():getBodyParts()
    for index = 0, bodyParts:size() - 1 do
        if bodyParts:get(index):HasInjury() then
            injuredParts[index] = true
        end
    end

    return injuredParts
end

local function initializeInjuredBodyParts(_, character)
    if isClient() and not isServer() then
        return
    end

    if not character then
        return
    end

    character:getModData().VCMComplexityInjuredBodyParts = captureInjuredBodyParts(character)
end

local difficultyProfiles = {
    { trait = VCMComplexityRegistries.easiest, option = "EasiestModifierPercent", default = 30, direction = -1 },
    { trait = VCMComplexityRegistries.easier, option = "EasierModifierPercent", default = 20, direction = -1 },
    { trait = VCMComplexityRegistries.easy, option = "EasyModifierPercent", default = 10, direction = -1 },
    { trait = VCMComplexityRegistries.hard, option = "HardModifierPercent", default = 10, direction = 1 },
    { trait = VCMComplexityRegistries.harder, option = "HarderModifierPercent", default = 20, direction = 1 },
    { trait = VCMComplexityRegistries.hardest, option = "HardestModifierPercent", default = 30, direction = 1 },
}

local function getDifficultyModifier(profile)
    local settings = SandboxVars and SandboxVars.VCMComplexity
    local percent = settings and settings[profile.option]
    if type(percent) ~= "number" then
        percent = profile.default
    end

    return profile.direction * percent / 100
end

local function getDifficultyProfile(character)
    for _, profile in ipairs(difficultyProfiles) do
        if character:hasTrait(profile.trait) then
            return profile, getDifficultyModifier(profile)
        end
    end
end

local function isImpactDamage(damageType)
    return damageType == "WEAPONHIT"
        or damageType == "CARHITDAMAGE"
        or damageType == "CARCRASHDAMAGE"
        or damageType == "FALLDOWN"
end

local function VCMComplexityModifyDamage(character, damageType, damage)
    if isClient() and not isServer() then
        return
    end

    if not character or character:isDead() or character:isZombie() then
        return
    end

    local profile, modifier = getDifficultyProfile(character)
    if not profile then
        return
    end

    local bodyDamage = character:getBodyDamage()
    local modData = character:getModData()
    local injuredParts = modData.VCMComplexityInjuredBodyParts
    if not injuredParts then
        injuredParts = captureInjuredBodyParts(character)
        modData.VCMComplexityInjuredBodyParts = injuredParts
    end

    local bodyParts = bodyDamage:getBodyParts()
    local hasNewInjury = false
    for index = 0, bodyParts:size() - 1 do
        local bodyPart = bodyParts:get(index)
        if not bodyPart:HasInjury() then
            injuredParts[index] = nil
        elseif not injuredParts[index] then
            hasNewInjury = true
            injuredParts[index] = true
            if modifier < 0 and ZombRand(100) < -modifier * 100 then
                bodyPart:RestoreToFullHealth()
                injuredParts[index] = bodyPart:HasInjury() and true or nil
            end
        end
    end

    if damage and damage > 0 then
        if modifier < 0 then
            bodyDamage:AddGeneralHealth(damage * -modifier)
        elseif modifier > 0 then
            bodyDamage:ReduceGeneralHealth(damage * modifier)
        end
    end

    if modifier > 0 and damage and damage > 0 and not hasNewInjury and isImpactDamage(damageType) then
        local uninjuredParts = {}
        for index = 0, bodyParts:size() - 1 do
            if not bodyParts:get(index):HasInjury() then
                table.insert(uninjuredParts, index)
            end
        end

        if #uninjuredParts > 0 and ZombRand(100) < modifier * 100 then
            local index = uninjuredParts[ZombRand(#uninjuredParts) + 1]
            bodyParts:get(index):setScratched(true, true)
            injuredParts[index] = true
        end
    end
end

Events.OnCreatePlayer.Add(initializeInjuredBodyParts)
Events.OnPlayerGetDamage.Add(VCMComplexityModifyDamage)