--Hand Destruction (Hasty Horse)

local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_HANDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
    local dp=Duel.GetFlagEffectLabel(0,112000000)
	if chk==0 then
        if not dp then return false end
		local h1=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
		if e:GetHandler():IsLocation(LOCATION_HAND) then h1=h1-1 end
		local h2=Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)
		return h1>1 and h2>1 and Duel.IsPlayerCanDraw(tp,1) and Duel.IsPlayerCanDraw(1-tp,1)
            and Duel.GetFieldGroupCount(dp,LOCATION_DECK,0)>=4
	end
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,PLAYER_ALL,2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,PLAYER_ALL,2)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
    local dp=Duel.GetFlagEffectLabel(0,112000000)
    if not dp then return end
	local h1=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
	local h2=Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)
	if h1<2 or h2<2 then return end
	local turnp=Duel.GetTurnPlayer()
	Duel.Hint(HINT_SELECTMSG,turnp,HINTMSG_TOGRAVE)
	local g1=Duel.SelectMatchingCard(turnp,nil,turnp,LOCATION_HAND,0,2,2,nil)
	Duel.ConfirmCards(1-turnp,g1)
	Duel.Hint(HINT_SELECTMSG,1-turnp,HINTMSG_TOGRAVE)
	local g2=Duel.SelectMatchingCard(1-turnp,nil,1-turnp,LOCATION_HAND,0,2,2,nil)
	g1:Merge(g2)
	if #g1>0 and Duel.SendtoGrave(g1,REASON_EFFECT)>0 then
		local og=Duel.GetOperatedGroup()
		if not og:IsExists(Card.IsLocation,1,nil,LOCATION_GRAVE) or Duel.GetFieldGroupCount(dp,LOCATION_DECK,0)<4 then return end
		Duel.BreakEffect()
        Duel.DisableShuffleCheck()
        local tg1=Duel.GetDecktopGroup(dp,2)
        Duel.SendtoHand(tg1,turnp,REASON_EFFECT)
        Duel.ShuffleHand(turnp)
        local tg2=Duel.GetDecktopGroup(dp,2)
        Duel.SendtoHand(tg2,1-turnp,REASON_EFFECT)
        Duel.ShuffleHand(1-turnp)
	end
end