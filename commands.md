## 服务器管理
* `TheNet:SetAllowIncomingConnections(true|false)` -- true允许他人加入；false阻止任何人加入。

## 管理员角色修改
* `​ThePlayer.components.health:SetMaxHealth(value)` -- 设置生命值上限
* `ThePlayer.components.sanity:SetMax(value)` -- 设置理智值上限
* `ThePlayer.components.hunger:SetMax(value)` -- 设置饥饿值上限
* `ThePlayer.components.hunger:Pause(true)` -- 暂停饥饿
* `ThePlayer.components.combat.damagemultiplier = value` -- 设置伤害倍数
* `ThePlayer.components.beaverness:SetPercent(.01)` -- .01 海狸 <-> 1 伍迪

## 玩家管理
* `TheNet:Kick(userid)` -- 踢出用户ID为“userid”的玩家
* `TheNet:Ban(userid)` -- 禁止用户ID为“userid”的玩家加入
* `c_listallplayers()` -- 列出玩家用户名和编号
* `AllPlayers[number]` -- 选取一个玩家

## 游戏管理
* `c_regenerateworld()` -- 重置世界
* `c_reset()` -- 重新加载世界
* `c_reset(true|false)` -- true保存并重新加载世界；false不保存直接重新加载当前世界
* `c_save()` -- 立即保存当前世界（一般会在每天早上自动保存）
* `c_rollback(1)` -- n位之前第n个存档
* `c_shutdown(true|false)` -- true保存并关闭当前世界；false不保存直接关闭当前世界

## 作弊
* `c_give("prefab",amount)` -- 获取一定数量预设物品(只适用于可以被储存在物品栏的背包 和物品)
* `c_sethea​lth(percent)` -- 根据百分比设置生命值 0.90 = 90%
* `c_setsanit​y(percent)` -- 根据百分比设置理智值 0.90 = 90%
* `c_sethunger(pe​rcent)` -- 根据百分比设置饥饿值 0.90 = 90%
* `c_setmoisture(pe​rcent)` -- 根据百分比设置湿度值 0.90 = 90%
* `c_settemperature(degrees)` -- 根据百分比设置温度值 0.90 = 90%
* `c_godmode()` -- 玩家的理智值、饥饿值和被攻击时生命值不再下降

* `c_move(AllPlayers[number])` -- 移动一个玩家到鼠标位置
* `AllPlayers[number]:PushEvent('death')` -- 杀死一个玩家
* `AllPlayers[number]:PushEvent('respawnfromghost')` -- 复活一个玩家
* `c_goto(AllPlayers[number])` -- 传送到一个玩家

## 其他

#### 创建连接的虫洞

```lua
worm1 = c_spawn("wormhole") -- 生成虫洞1
worm2 = c_spawn("wormhole") -- 生成虫洞2
worm1.components.teleporter.targetTeleporter = worm2 -- 虫洞1连接至虫洞2
worm2.components.teleporter.targetTeleporter = worm1 -- 虫洞2连接至虫洞1
```


#### 生成一只被驯服的牛

```lua
local beef = c_spawn("beefalo");
beef.components.hunger:DoDelta(400);
beef.components.domesticatable:DeltaTendency("DEFAULT", 1);
beef:SetTendency();
beef.components.domesticatable.domestication = 1;
beef.components.domesticatable:BecomeDomesticated();
```