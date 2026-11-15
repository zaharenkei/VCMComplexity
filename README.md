# VCM Complexity

VCM Complexity is a Project Zomboid Build 42 mod designed primarily for
multiplayer. It adds traits that adjust several difficulty-related effects so
players with different levels of experience can have a more balanced and fair
experience together.

## What it changes

The mod adds six mutually exclusive traits:

| Trait | Character points | Default modifier |
| --- | ---: | ---: |
| Easy | +3 | 10% decrease |
| Easier | +6 | 20% decrease |
| Easiest | +9 | 30% decrease |
| Hard | -3 | 10% increase |
| Harder | -6 | 20% increase |
| Hardest | -9 | 30% increase |

The modifiers affect damage taken, body-part injury chance, hunger, thirst,
and endurance drain. Each trait has its own sandbox percentage setting, so
server owners can tune the strengths independently.

## Installation

1. Copy the VCMComplexity root folder into `%USERPROFILE%\Zomboid\mods\`. 
2. Start Project Zomboid and enable **VCM Complexity** from the Mods menu.
3. Restart or reload as prompted by the game.

For multiplayer, install and enable the same mod on the server and on each connecting client. Configure the mod in the server settings if required.

## Compatibility and saves

- The mod targets Project Zomboid Build 42.22 and later.
- No incompatible mods have been identified so far.
- The mod can be added to an existing save and removed from a save safely.
  As with any change to a mod list, keeping a backup is recommended.

## Project status

Most of this mod was created through AI-assisted iteration.
The code is intended to be manually reviewed and refactored over time, with
continued testing and support as the game and mod evolve.

## Contributions and discussion

Contributions and discussion are welcome. Feel free to open an issue or pull
request with bug reports, compatibility notes, suggestions, or ideas for
additional features. When reporting an issue, include the game version and
relevant mod list if possible.
