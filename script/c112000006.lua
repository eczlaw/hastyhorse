--Good Goblin Housekeeping (Hasty Horse)

local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
    local dp=Duel.GetFlagEffectLabel(0,112000000)
    if chk==0 and not dp then return false end
    local ct=Duel.GetMatchingGroupCount(Card.IsCode,dp,LOCATION_GRAVE,0,nil,id)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) and Duel.GetFieldGroupCount(dp,LOCATION_DECK,0)>ct end
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,ct+1)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_HAND)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
    local dp=Duel.GetFlagEffectLabel(0,112000000)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local d=Duel.GetMatchingGroupCount(Card.IsCode,dp,LOCATION_GRAVE,0,nil,id)+1
    local tg=Duel.GetDecktopGroup(dp,d)
	Duel.DisableShuffleCheck()
	Duel.SendtoHand(tg,p,REASON_EFFECT)
    Duel.ShuffleHand(p)
	Duel.BreakEffect()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(p,aux.TRUE,p,LOCATION_HAND,0,1,1,nil)
	Duel.SendtoDeck(g,dp,SEQ_DECKBOTTOM,REASON_EFFECT)
end