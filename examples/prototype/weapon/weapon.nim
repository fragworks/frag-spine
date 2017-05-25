type
  WeaponType* = enum
    PISTOL, SHOTGUN, SNIPER, LAUNCHER

  Weapon* = object
    weaponType*: WeaponType

proc init*(weapon: Weapon) =
  discard