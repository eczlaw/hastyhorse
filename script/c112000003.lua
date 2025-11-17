--Conscription (Hasty Horse)

local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
    local dp=Duel.GetFlagEffectLabel(0,112000000)
	if chk==0 then return dp and Duel.GetFieldGroupCount(dp,LOCATION_DECK,0)~=0 end
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
    local dp=Duel.GetFlagEffectLabel(0,112000000)
    if not dp then return end
	Duel.ConfirmDecktop(dp,1)
	local g=Duel.GetDecktopGroup(dp,1)
	local tc=g:GetFirst()
	if not tc then return end
	if tc:IsSummonableCard() and tc:IsCanBeSpecialSummoned(e,0,tp,false,false) then
		Duel.DisableShuffleCheck()
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	elseif tc:IsAbleToHand() then
		Duel.DisableShuffleCheck()
		Duel.SendtoHand(tc,1-tp,REASON_EFFECT)
		Duel.ShuffleHand(1-tp)
	else
		Duel.DisableShuffleCheck()
		Duel.SendtoGrave(tc,REASON_RULE)
	end
end