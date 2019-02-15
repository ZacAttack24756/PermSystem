# PermSystem
A script I made for Roblox, now on github aswell. This script allows for setting permissable groups to be given to certian individuals, which grants them access to things in game.
Product made by: mystery3525 (Roblox), ZacAttack24756 (github)

## Extended Description
This script is meant to be a control module that can be applicable to almost any game. A basic example is this: Any server script sends a request to the module, asking if player "Bob" has the permission `.interact.door.house1`. The script will reference every group that the player "Bob" is in to see if any group has that permission or a better one. If he does or doesn't, the script responds back.

A "Permission" is the most basic control object in this system. Each permission is made up of different layers of a dot, followed by a descriptor. The more layers inside a permission, the more specific a permission is. Also: Ending a permission with a `.*` would give all permissions on that layer, and following layers. For Example: Giving a `.interact.door.*` would also give ".interact.door.house1" and ".interact.door.house2", etc. Giving someone a `.*` permission would allow that player to have every permission accepted, since it is the highest layer, and the least specific (Make sure its only one asterisk, because more than one means it is it's own permission). Permissions CAN be negative, but this doesn't work when dealing with `.*`.

"Groups" are the main object of this system. Each group has a set of permissions which are granted to players of a group. Note: Players can only be within **one** group usually. This is where Rank Ladders come in. Group names cannot have any spaces, or be the same.

A "Rank Ladder" is another way to say a group of groups. One player may only be in one rank ladder at a time. This is useful in roleplaying groups where there are different "Divisions". If you don't change the rank ladder, it is "Default" by Default.

One Powerful use of groups is inheritance, which saves you time in making groups. A group that is on another group's "inheritance" list 'inherits' any permissions from that group, and for any group that inherits from it as well.. Meaning if Group B inherits from Group A, and Group A has the permission `.interact.door.house1`, Group B also has that permission, and adding it specifically to it's permission would be a waste of time. Group C which inherits from Group B would also have that permission. Any group can inherit from any other group, and there are preventative measures to prevent loops from lagging servers.

This script is also a, **one-time-configuration** type of script, meaning that it's configuration typically cannot be editing during a game, A strength and weakness.

**Disclaimer:** This script takes preventative precautions in order to secure your game from exploitation. That being said, this script will not accept any messages or commands from any 'Local' or client script, but securing any server scripts is your responsibility. If a hacker somehow got access to a backdoor server script, and uses that server script to gain access to all permissions, its not my responsibility.

**Developer Access:** This script uses BindableFunctions for security, and global use/ease of access. Currently, only checking if a player has a permission is supported; Arguments: ["CheckPerm"] [PlayerObject] [PermissionToCheck <str>]  ; Returns: [HasAccess <bool>]

## Addons

Along with the base feature for the script, there is also specialty scripts built into this one that works really well with PermSystem. *Addons __have not been added yet__*

- **SimpleTitles:** Previously uncreatively considered "AboveHeadRanks", this addon is a simple, yet effective User Group Display system. See Configuration Documentation for the full description, and configuration.

- **ToolGiver:** Another uncreatively named script, ToolGiver allows you to configure it to give players tools on a Per-Group-Basis. Note: You cannot have the same tool given out twice by default, see Configuration Documentation for more information.

## Planned Features
- Initial Release
- The Ability to save users' groups via DataStores
- Fully Finished SimpleTitles Addon
- More Addons

## Usage
You may distribute and modify this script, but any works must be under the same license, you must disclose the source of the script, and state the changes made. You may not edit the Copyright and License notices. For more detailed, and the actual license, refer to the LICENSE document.
