local difficultyProfiles = {
    { trait = VCMComplexityRegistries.easiest, option = "EasiestModifierPercent", default = 30, direction = -1 },
    { trait = VCMComplexityRegistries.easier, option = "EasierModifierPercent", default = 20, direction = -1 },
    { trait = VCMComplexityRegistries.easy, option = "EasyModifierPercent", default = 10, direction = -1 },
    { trait = VCMComplexityRegistries.hard, option = "HardModifierPercent", default = 10, direction = 1 },
    { trait = VCMComplexityRegistries.harder, option = "HarderModifierPercent", default = 20, direction = 1 },
    { trait = VCMComplexityRegistries.hardest, option = "HardestModifierPercent", default = 30, direction = 1 },
}

local previousStats = {}

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

local function adjustDrain(previousValue, currentValue, rate, drainsWhenIncreasing)
    local change = currentValue - previousValue
    if (drainsWhenIncreasing and change > 0) or (not drainsWhenIncreasing and change < 0) then
        return previousValue + change * rate
    end

    return currentValue
end

local function updatePlayerStats(character)
    if isClient() and not isServer() then
        return
    end

    if not character then
        return
    end

    local stats = character:getStats()
    local hunger = stats:get(CharacterStat.HUNGER)
    local thirst = stats:get(CharacterStat.THIRST)
    local endurance = stats:get(CharacterStat.ENDURANCE)
    local previous = previousStats[character]
    if not previous then
        previousStats[character] = { hunger = hunger, thirst = thirst, endurance = endurance }
        return
    end

    local profile, modifier = getDifficultyProfile(character)
    if profile then
        local rate = 1 + modifier
        hunger = adjustDrain(previous.hunger, hunger, rate, true)
        thirst = adjustDrain(previous.thirst, thirst, rate, true)
        endurance = adjustDrain(previous.endurance, endurance, rate, false)

        stats:set(CharacterStat.HUNGER, hunger)
        stats:set(CharacterStat.THIRST, thirst)
        stats:set(CharacterStat.ENDURANCE, endurance)
    end

    previousStats[character] = { hunger = hunger, thirst = thirst, endurance = endurance }
end

Events.OnPlayerUpdate.Add(updatePlayerStats)