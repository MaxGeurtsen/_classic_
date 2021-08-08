# LockoutTracer test cases

> Run the following tests with 0 hourly lockouts present!

## 5 man dungeon tests
- Enter dungeon
  - Should say 1/5
- Leave dungeon
  - Run command "/it rl", should say 1/5
- Reload UI
  - Run command "/it rl", should say 1/5
- Enter same dungeon
  - Run command "/it rl", should say 1/5
- Leave dungeon
- Log off 
- Log in
- Enter dungeon
  - Should say 2/5 locks
- Leave dungeon
- Reset instance(s)
  - Should say instance has been reset
- Enter dungeon
  - Should say 3/5 locks
- Leave dungeon
- Reset instance(s)
  - Should say instance has been reset
- Enter dungeon
  - Should say 4/5 and give a time when next dungeon is available

## Raid dungeon tests
- Create a raid group, by grouping up with a character from another account AND with a character on the same account
- Enter raid
  - Should say 1/5
- Leave raid
- Log off
- Log in
- Enter raid
  - Should give a popup, asking if you have reset the instance with a different toon
    - Press NO on popup
  - Run command "/it rl", should say 1/5
- Leave raid
- Reset raid
- Enter raid
  - Should say 2/5
- Log off
- Reset raid with character on ANOTHER account
- Log in
  - Should give a popup, asking if you have reset the instance with a different toon
    - Press YES on popup
    - Should say 2/5
- Leave raid
- Log off
- Reset raid with character on SAME account
- Log in
- Enter raid
  - Should say 3/5