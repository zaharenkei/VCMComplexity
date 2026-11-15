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

1. Copy the folder containing `mod.info`, `42.22`, and `common` into
   `%USERPROFILE%\Zomboid\mods\`. For example:
   `%USERPROFILE%\Zomboid\mods\VCMComplexity\mod.info`.
2. Start Project Zomboid and enable **VCM Complexity** from the Mods menu.
3. Restart or reload as prompted by the game.

For multiplayer, install and enable the same mod on the server and on each
connecting client. Configure the six percentages under the **VCM Complexity**
sandbox options on the server.

## Compatibility and saves

- The mod targets Project Zomboid Build 42.22 and later.
- No incompatible mods have been identified so far; compatibility with every
  possible mod combination has not been tested.
- The mod can be added to an existing save and removed from a save safely.
  As with any change to a mod list, keeping a backup is recommended.

## Project status

Most of this mod was created through vibe coding and AI-assisted iteration.
The code is intended to be manually reviewed and refactored over time, with
continued testing and support as the game and mod evolve.

## Contributions and discussion

Contributions and discussion are welcome. Feel free to open an issue or pull
request with bug reports, compatibility notes, suggestions, or ideas for
additional features. When reporting an issue, include the game version and
relevant mod list if possible.
