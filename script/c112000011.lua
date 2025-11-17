--Spellbook Organization (Hasty Horse)

local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
    local dp=Duel.GetFlagEffectLabel(0,112000000)
	if chk==0 then return dp and Duel.GetFieldGroupCount(dp,LOCATION_DECK,0)>2 end
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
    local dp=Duel.GetFlagEffectLabel(0,112000000)
	Duel.SortDecktop(tp,dp,3)
end