# mch2022 badge special: game part select menu

To install everything on the badge, follow these steps:

1. Make sure to add the gamedata to the `GAMEDATA` folder, [see here](../../README.md#wheres-all-the-data).
1. Build a5k for the badge: from a prompt in the repo root, type `make BOARD=mch2022`
1. Install the menu: from a prompt in this directory, `./install_game.sh`

That's it! To play, on the badge go to *apps* and then *another_world*. Select the
level with the joystick and click on the stick to start it.

> The game can be uninstalled from the badge using `./uninstall_game.sh`

## Credits

Thanks to Henri Manson for making this possible!
