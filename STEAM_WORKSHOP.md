# Steam Workshop Page

## Title

Spider Fuel

## Description

[h1]Spider Fuel[/h1]

Turn common spider drops into useful fire fuel. Silk and Spider Glands can be
added to compatible burnable-fuel consumers such as campfires and fire pits.

[h2]Features[/h2]

[list]
[*]Silk becomes burnable fuel.
[*]Spider Glands become burnable fuel without changing their healing use.
[*]Each item has its own Tiny, Small, or Medium fuel setting.
[*]Defaults preserve the intended balance: Spider Glands use Tiny fuel and Silk uses Small fuel.
[/list]

[h2]Configuration[/h2]

[table]
[tr][th]Option[/th][th]Choices[/th][th]Default[/th][/tr]
[tr][td]Spider Gland Fuel Value[/td][td]Tiny / Small / Medium[/td][td]Tiny[/td][/tr]
[tr][td]Silk Fuel Value[/td][td]Tiny / Small / Medium[/td][td]Small[/td][/tr]
[tr][td]Debug Logging[/td][td]Disabled / Enabled[/td][td]Disabled[/td][/tr]
[/table]

[h2]Multiplayer[/h2]

This is a server-side gameplay mod. Joining clients do not need to install it
separately. Configuration is controlled by the host/world.

For troubleshooting, enable Debug Logging and run
[code]SPIDER_FUEL_DEBUG()[/code] in the host/server console. It reports the
configured values and whether spawned Silk and Spider Glands were patched.

Version: 1.1.2

Source code and bug reports:
https://github.com/dbilici/dst-spider-fuel
