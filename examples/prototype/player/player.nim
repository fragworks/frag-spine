import
  ../weapon/weapon

type
  Player* = object
    aiming*: bool
    weapons*: array[4, Weapon]
    weaponIndex*, lastWeaponIndex*: int

proc arm*(player: var Player) =
  player.weapons = [
    Weapon(weaponType: PISTOL),
    Weapon(weaponType: PISTOL),
    Weapon(weaponType: PISTOL),
    Weapon(weaponType: PISTOL)
  ]

proc stopAiming*(player: var Player) =
  player.aiming = false

proc toggleAiming*(player: var Player) =
  player.aiming = not player.aiming

proc init*(player: var Player) =
  player.aiming = false
  
  player.arm()