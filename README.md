# hastyhorse
Scripts that implement the alternative Yu-Gi-Oh! format [Hasty Horse](https://ygoprodeck.com/cube/view-cube/35397)
by MBT to play it in EDOPro.

## In-game functionality

The game rule card "Hasty Horse Rules" will remove itself from the Deck at the start of a duel
and ask both players to accept the rules. It will also check whether the decklist is correct
and whether the Extra Decks are empty.
All cards from the decklist that interact with the Main Deck or GY have been rescripted
to work with a single Main Deck and GY.

The decklist to play the format is provided as ``HastyHorse.ydk``.
You have to enable *Dont't check Deck contents* and *Dont't check Deck size*, as the decklist
has more than 3 copies of some cards and contains more than 60 cards.
Only one deck is needed. The other player's deck is irrelevant, but it has to
contain cards that make up the starting hand.

## Usage

There are multiple ways to add the cards to your EDOPro installation.

1. Manually add the ``.cdb`` file and the files in the ``pics`` and ``script`` folders
to the ``expansions``, ``expansions/pics`` and ``expansions/script`` subdirectories of ``ProjectIgnis``,
respectively.
This is outlined in the [ProjectIgnis scrapi-book](https://projectignis.github.io/scrapi-book/getting-started/setup.html#where-to-place-the-files).

2. Add this repository to your game's repositories. This will automatically update the cards in
your client if they are modified in the future, e.g. to fix bugs.
To do this, add the following in the file ``ProjectIgnis/config/user_configs.json``
(create it if it does not exist):

````json
{
	"repos": [
		{
		"url": "https://github.com/eczlaw/hastyhorse",
		"repo_name": "Hasty Horse Format",
		"repo_path": "./repositories/hastyhorse",
		"should_update": true,
		"should_read": true
		}
	]
}
````

You should then be able to play the format in LAN mode,
as described in the [ProjectIgnis FAQ](https://projectignis.github.io/faq.html) Q11.



---
The graphics used in this project are copyright 4K Media Inc, a subsidiary of Konami Digital Entertainment, Inc.
Yu-Gi-Oh! is a trademark of Shueisha and Konami.
This project is not affiliated with or endorsed by Shueisha or Konami.
