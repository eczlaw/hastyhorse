--Jar of Greed (Hasty Horse)

local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
    local dp=Duel.GetFlagEffectLabel(0,112000000)
	if chk==0 then return dp and Duel.IsPlayerCanDraw(tp,1) and Duel.GetFieldGroupCount(dp,LOCATION_DECK,0)>0 end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
    local dp=Duel.GetFlagEffectLabel(0,112000000)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
    Duel.DisableShuffleCheck()
    local tg=Duel.GetDecktopGroup(dp,d)
    Duel.SendtoHand(tg,p,REASON_EFFECT)
    Duel.ShuffleHand(p)
end