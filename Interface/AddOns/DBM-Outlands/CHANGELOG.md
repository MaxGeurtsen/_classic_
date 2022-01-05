# <DBM> Outlands

## [2.5.22-15-gf003b0c](https://github.com/DeadlyBossMods/DBM-TBC-Classic/tree/f003b0c5804b83149ee96b92cbd45ad2fb4d5c27) (2022-01-05)
[Full Changelog](https://github.com/DeadlyBossMods/DBM-TBC-Classic/compare/2.5.22...f003b0c5804b83149ee96b92cbd45ad2fb4d5c27) [Previous Releases](https://github.com/DeadlyBossMods/DBM-TBC-Classic/releases)

- Fixed some bugs in last, now it's rock solid  
- Respect the simple/BW bar behavior on small bars too, if enlarged ones are disabled  
- Update zhTW (#34)  
- Update koKR (#33)  
- Improve stage debug further  
- Update localization.ru.lua (#32)  
    Added two missing phrases.  
- Update localization.ru.lua (#31)  
    Several phrases were not translated into Russian localization. I added. Perhaps they need to be properly distributed in the file somehow.  
- Sync Musel'ek spam bug fix to TBC classic as well  
- Deprecated and blacklisted DBM-RaidLeadTools;  
    Its far beyond broken, and likely to never be supported again, there's far superior alternatives.  
    - Also removed the AddSliderOption, AddEditboxOption, AddButton features as they were only used by RaidLeadTools, and the main feature that's totally broken.  
- small tiny improvement in /dbm whereami  
- UpdateTable should also support batching for cpu saving.  
- Picky  
- Fix dbm core treating 9.2 raid as trivial content  
- Fixed a bug that may cause classic era DBM to be too aggressive with force disable do to fact I forgot to update the min interface (which is used as reference for the force disable)  
- Set alpha revisions  
