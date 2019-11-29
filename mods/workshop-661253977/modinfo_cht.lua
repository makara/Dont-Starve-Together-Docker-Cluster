description = 
"\n·新增！死亡將掉落身上全部救贖之心，其中也包括背包。另外即使配置成全不掉落也會必然掉壹格，原因妳懂的！"..
"\n·死亡後變成靈魂將不掉落全部物品，復活後基本不用特意去撿屍體了。"..
"\n·為PvP玩家考慮，如果玩家有穿戴背包，裏面物品也將會隨機掉落（可配置）！"..
"\n\n！！！註意：救贖之心復活人身上至少要空閑壹格，其中也包括背包空閑位置！"

h_a = "玩家死亡將"
h_b = "不"
h_c = "掉落"
h_d = "不超過 "
h_e = " 格的隨機格數的物品"
h_f = "任何物品"
h_g = "隨機掉落，我覺得沒這個必要！"
ho_a = h_a..h_b..h_c..h_f
ho_b = h_a..h_c..h_d

configuration_options = 
{
  {name="kong",label="項目\n\n",options={{description ="格數",data = 0,}},default=0,},
    {
        name = "rendiao",
        label = "人身最大掉落",
        hover = "下面壹排格子最大掉落的物品格數",
        options =
        {
            {description = "None", data = 0, hover = ho_a},
            {description = "1",  data = 1,  hover = ho_b.."1"..h_e},
            {description = "2",  data = 2,  hover = ho_b.."2"..h_e},
            {description = "3",  data = 3,  hover = ho_b.."3"..h_e},
            {description = "4",  data = 4,  hover = ho_b.."4"..h_e},
            {description = "5",  data = 5,  hover = ho_b.."5"..h_e},
            {description = "6",  data = 6,  hover = ho_b.."6"..h_e},
            {description = "7",  data = 7,  hover = ho_b.."7"..h_e},
            {description = "8",  data = 8,  hover = ho_b.."8"..h_e},
            {description = "9",  data = 9,  hover = ho_b.."9"..h_e}
        },
        default = 2,
    },
    {
        name = "baodiao",
        label = "背包最大掉落",
        hover = "背包的最大掉落的物品格數",
        options =
        {
            {description = "None", data = 0, hover = ho_a},
            {description = "1",  data = 1,  hover = ho_b.."1"..h_e},
            {description = "2",  data = 2,  hover = ho_b.."2"..h_e},
            {description = "3",  data = 3,  hover = ho_b.."3"..h_e},
            {description = "4",  data = 4,  hover = ho_b.."4"..h_e},
            {description = "5",  data = 5,  hover = ho_b.."5"..h_e},
            {description = "6",  data = 6,  hover = ho_b.."6"..h_e},
            {description = "7",  data = 7,  hover = ho_b.."7"..h_e},
            {description = "8",  data = 8,  hover = ho_b.."8"..h_e},
            {description = "9",  data = 9,  hover = ho_b.."9"..h_e}
        },
        default = 1,
    },
    {
        name = "zbdiao",
        label = "裝備掉落",
        hover = "死亡是否必然掉落裝備\n沒有肉身要如何裝備？\n防止靈魂狀態裝備掉耐久",
        options =
        {
            {description = "开", data = true, hover = "沒有肉身也能裝備這不科學，我選擇必然掉落"},
            {description = "关",  data = false,  hover = h_g}
        },
        default = true,
    },
    {
        name = "amudiao",
        label = "重生護符過濾器",
        hover = "死亡是否必然掉落壹只重生護身符\n避免有攜帶重生護符但死亡沒掉出來的悲劇\n默認開！",
        options =
        {
            {description = "开", data = true, hover = "必然掉落，我遇到過這種情況，我選擇掉落它！"},
            {description = "关",  data = false,  hover = h_g}
        },
        default = true,
    },
}