# RepHelper

## [2.5.1-release](https://github.com/chawan/RepHelper_Classic/tree/2.5.1-release) (2021-05-23)
[Full Changelog](https://github.com/chawan/RepHelper_Classic/compare/1.13.5.1-release...2.5.1-release) [Previous Releases](https://github.com/chawan/RepHelper_Classic/releases)

- Updated toc file  
- Forgot to remove a test edit  
- Revert some changes to Darkmoon Faire to find another solution.  
- More tooltip cleanup  
- Fixed tooltips for non-repeatable quests  
- Fixed fixed options button using removed BrowserButtonTemplate  
- Merge pull request #3 from tvlfrosty/patch-1  
    UI fix and Reputation values  
- Steamwheedle Cartel rep cut-off  
    Changed the reputation cut off to exalted.  
- Steamwheedle Cartel rep values  
    Added mobs for all four Steamwheedle Cartel factions (handy for people that farmed Bloodail buccaneers rep as this whille not decrease bloodsail buccaneers rep).  
- Magram & Gelkis Clan Centaurs  
    Added mobs to kill for both Magram & Gelkis Clan Centaurs. The reason I didn't add them on 1 line is because it becomes unreadable.  
- Addded Non repeatable qeusts  
    Added some of the non repeatable quests and added the logic to an existing quest, which will now only show "To do: 1x".  
- zhTW translation for the questTipNonRepeatable  
    Added the zhTW translation for the questTipNonRepeatable label.  
- zhCN translation for the questTipNonRepeatable  
    Added the zhCN translation for the questTipNonRepeatable label.  
- ruRU translation for the questTipNonRepeatable  
    Added the ruRU translation for the questTipNonRepeatable label.  
- ptBR translation for the questTipNonRepeatable  
    Added the ptBR translation for the questTipNonRepeatable label.  
- koKR translation for the questTipNonRepeatable  
    Added the koKR translation for the questTipNonRepeatable label. (I am sorry if it's not correct, I kinda had to use google translate for this....)  
- itIT translation for the questTipNonRepeatable  
    Added the itIT translation for the questTipNonRepeatable label.  
- frFR translation for the questTipNonRepeatable  
    Added the frFR translation for the questTipNonRepeatable label.  
- esES translation for the questTipNonRepeatable  
    Added the esES translation for the questTipNonRepeatable label.  
- deDE translation for the questTipNonRepeatable  
    Added the deDE translation for the questTipNonRepeatable label.  
- enUS translation for questTipNonRepeatable  
    Added the enUS translation for the questTipNonRepeatable label.  
- Added some logic for non-repeatable quests  
    Added some logic for non-repeatable quests (standard setting will fallback on being repeatable).  
    I am not 100% sure about the effeciency of my edit on line 2053, I couldn't really figure out how to work with the "FUL\_I.suppress" value.  
    This allows you to add true/false at the end of the RPH\_AddQuest() function. (true being repeatable, and false being non-repeatable).  
    Also added an extra label (RPH\_TXT.questTipNonRepeatable) for the non-repeatable quests. Since they are not repeatable or daily quests.  
- Added an extra reputation cut off for DMF  
    Added an extra reputation cut off for Darkmoon Faire since most of the repeatable quests stop giving rep after 2001/6000.  
- Darkmoon Faire reputation values updated  
    Updated some of the quest names, added a new reputation cut-off since DMF stops giving rep from some of the quests at 2001/6000. Also added the "Your Fortune Awaits You..." quests that come from certain fortunes.  
- Updated the bloodsail buccaneers rep values.  
    Added personally known bloodsail buccaneers rep values to my best knowledge.  
- Fixes missing BackDropTemplate for options menu  
    Same as the reputation frame, the options frame was missing a BackDropTemplate.  
- Merge pull request #1 from tvlfrosty/patch-2  
    Updating pull request with some changes to bloodsail rep values.  
- Updated known Bloodsail reputation values  
    By the logic of the addon, hitting 11999/12000 falls under standing "6". The "Booty Bay Bruisers" stop giving rep at this point. Also only "Jazzrik" gives rep from the 2 mobs in the Badlands after hitting revered.  
    I can't say for sure at what point "Booty Bay Elite", "Baron Revilgaz" and "Blackwater Deckhand" stop giving rep, therefore I did not change the values.  
- Update RepHelper.xml  
    Fixes the buggy transparent background in classic, this fix was made for the retail version as well.  