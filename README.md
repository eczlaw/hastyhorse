# hastyhorse
Scripts that implement MBT's [Hasty Horse](https://ygoprodeck.com/cube/view-cube/35397)
Format to play it in EDOPro.

The game rule card "Hasty Horse Rules" will remove itself from the Deck at the start of a duel
and ask both players to accept the rules. It will also check whether the decklist is correct
and whether the Extra Decks are empty.
All cards from the decklist that interact with the Main Deck or GY have been rescripted
to work with a single Main Deck and GY.

Add the ``hastyhorse`` folder to your ``ProjectIgnis\expansions`` directory.
You should then be able to play the format locally by using the decklist ``HastyHorse.ydk``.
Only one deck is needed, the other player's deck is irrelevant.

Yu-Gi-Oh! is a trademark of Shueisha and Konami.
This project is not affiliated with or endorsed by Shueisha or Konami.
