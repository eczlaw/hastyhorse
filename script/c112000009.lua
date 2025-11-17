--Kingyo Sukui (Hasty Horse)

local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--Excavate the top card of your Deck
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TODECK+CATEGORY_DECKDES+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_SZONE)
	e2:SetHintTiming(0,TIMING_TOGRAVE|TIMING_END_PHASE)
	e2:SetCountLimit(1,id)
	e2:SetTarget(s.tdtg)
	e2:SetOperation(s.tdop)
	c:RegisterEffect(e2)
end
function s.tdfilter(c)
	return c:IsMonster() and c:IsAbleToDeck() and c:GetAttribute()>0
end
function s.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    local dp=Duel.GetFlagEffectLabel(0,112000000)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and s.tdfilter(chkc) end
	if chk==0 then return dp and Duel.GetFieldGroupCount(dp,LOCATION_DECK,0)>0
        and Duel.IsExistingTarget(s.tdfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,s.tdfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil)
	Duel.SetPossibleOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetPossibleOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
	Duel.SetPossibleOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,1)
	Duel.SetPossibleOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,tp,0)
end
function s.tdop(e,tp,eg,ep,ev,re,r,rp)
    local dp=Duel.GetFlagEffectLabel(0,112000000)
	if not dp or Duel.GetFieldGroupCount(dp,LOCATION_DECK,0)==0 then return end
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) or tc:IsFacedown() then return end
	Duel.ConfirmDecktop(dp,1)
	local dc=Duel.GetDecktopGroup(dp,1):GetFirst()
	if not dc then return end
	Duel.DisableShuffleCheck()
	if dc:IsMonster() and dc:IsAttribute(tc:GetAttribute()) and Duel.SendtoHand(dc,tp,REASON_EFFECT)>0 then
		Duel.ConfirmCards(1-tp,dc)
		Duel.DisableShuffleCheck(false)
		Duel.SendtoDeck(tc,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	elseif Duel.SendtoGrave(dc,REASON_EFFECT)>0 then
		Duel.Destroy(e:GetHandler(),REASON_EFFECT)
	end
end