local difficultyProfiles = {
    { trait = VCMComplexityRegistries.easiest, option = "EasiestModifierPercent", default = 30, description = "UI_trait_vcmcomplexity_easiestdesc" },
    { trait = VCMComplexityRegistries.easier, option = "EasierModifierPercent", default = 20, description = "UI_trait_vcmcomplexity_easierdesc" },
    { trait = VCMComplexityRegistries.easy, option = "EasyModifierPercent", default = 10, description = "UI_trait_vcmcomplexity_easydesc" },
    { trait = VCMComplexityRegistries.hard, option = "HardModifierPercent", default = 10, description = "UI_trait_vcmcomplexity_harddesc" },
    { trait = VCMComplexityRegistries.harder, option = "HarderModifierPercent", default = 20, description = "UI_trait_vcmcomplexity_harderdesc" },
    { trait = VCMComplexityRegistries.hardest, option = "HardestModifierPercent", default = 30, description = "UI_trait_vcmcomplexity_hardestdesc" },
}

local function getTraitTooltip(trait)
    if not trait then
        return
    end

    local traitType = trait:getType()
    for _, profile in ipairs(difficultyProfiles) do
        if traitType == profile.trait then
            local settings = SandboxVars and SandboxVars.VCMComplexity
            local percent = settings and settings[profile.option]
            if type(percent) ~= "number" then
                percent = profile.default
            end

            return getText(profile.description, percent)
        end
    end
end

local function updateTraitTooltips(list)
    if not list or not list.items then
        return
    end

    for _, item in ipairs(list.items) do
        local tooltip = getTraitTooltip(item.item)
        if tooltip then
            item.tooltip = tooltip
        end
    end
end

local function patchCharacterCreationUI()
    if not CharacterCreationProfession then
        error("CharacterCreationProfession is not available")
    end

    for _, methodName in ipairs({ "populateTraitList", "populateBadTraitList" }) do
        local originalMethod = CharacterCreationProfession[methodName]
        if type(originalMethod) ~= "function" then
            error("CharacterCreationProfession." .. methodName .. " is not available")
        end

        CharacterCreationProfession[methodName] = function(self, list)
            originalMethod(self, list)
            updateTraitTooltips(list)
        end
    end

    local originalAddTrait = CharacterCreationProfession.addTrait
    if type(originalAddTrait) ~= "function" then
        error("CharacterCreationProfession.addTrait is not available")
    end

    CharacterCreationProfession.addTrait = function(self, trait)
        originalAddTrait(self, trait)
        updateTraitTooltips(self.listboxTraitSelected)
    end

    local originalUpdate = CharacterCreationProfession.update
    if type(originalUpdate) ~= "function" then
        error("CharacterCreationProfession.update is not available")
    end

    CharacterCreationProfession.update = function(self)
        originalUpdate(self)
        updateTraitTooltips(self.listboxTrait)
        updateTraitTooltips(self.listboxBadTrait)
        updateTraitTooltips(self.listboxTraitSelected)
    end
end

Events.OnGameBoot.Add(patchCharacterCreationUI)
