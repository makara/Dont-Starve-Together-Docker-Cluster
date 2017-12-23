_G.ChinesePlus.SetConfigTranslation(mod_to_c,
  "副業是殺人的醫生。",
  {

  },
  {
    {
      name = "medkitrecipes",
      label = "醫療包配方難度",
      options =
      {
        {description = "非常簡單", data = 1},
        {description = "簡單", data = 2},
        {description = "預設", data = 3},
        {description = "中等", data = 4},
        {description = "困難", data = 5},
        {description = "艱難", data = 6},
        {description = "地獄", data = 7},
      },
      default = 3,
    },

    {
      name = "bonesawdmg",
      label = "鋸子基本傷害",
      options =
      {
        {description = "27", data = 27},
        {description = "34", data = 34},
        {description = "42.5(預設)", data = 42.5},
        {description = "51", data = 51},
        {description = "59.5", data = 59.5},
        {description = "60", data = 60},
      },
      default = 42.5,
    },

    {
      name = "bonesawuses",
      label = "鋸子使用次數",
      hover = "耐久。",
      options =
      {
        {description = "33", data = 33},
        {description = "50", data = 50},
        {description = "75", data = 75},
        {description = "100(預設)", data = 100},
        {description = "150", data = 150},
        {description = "175", data = 175},
        {description = "190", data = 190},
        {description = "200", data = 200},
        {description = "250", data = 250},
      },
      default = 100,
    },

    {
      name = "ubersawdmg",
      label = "超能骨鋸基本傷害",
      options =
      {
        {description = "15", data = 15},
        {description = "20", data = 20},
        {description = "27.2", data = 27.2},
        {description = "34(預設)", data = 34},
        {description = "42.5", data = 42.5},
        {description = "50", data = 50},
        {description = "51", data = 51},
        {description = "55", data = 55},
        {description = "60", data = 60},
      },
      default = 34,
    },

    {
      name = "ubersawuses",
      label = "超能骨鋸使用次數",
      options =
      {
        {description = "30", data = 30},
        {description = "50", data = 50},
        {description = "75", data = 75},
        {description = "100", data = 100},
        {description = "150(預設)", data = 150},
        {description = "175", data = 175},
        {description = "200", data = 200},
        {description = "250", data = 250},
      },
      default = 150,
    },

    {
      name = "uberhealth",
      label = "超能骨鋸生命回覆",
      options =
      {
        {description = "1", data = 1},
        {description = "2", data = 2},
        {description = "5", data = 5},
        {description = "8", data = 8},
        {description = "10(預設)", data = 10},
        {description = "15", data = 15},
        {description = "20", data = 20},
        {description = "25", data = 25},
        {description = "27", data = 27},
        {description = "30", data = 30},
        {description = "35", data = 35},
        {description = "40", data = 40},
        {description = "50", data = 50},
      },
      default = 10,
    },

    {
      name = "ampudmg",
      label = "截肢鋸基本傷害",
      options =
      {
        {description = "13.6", data = 13.6},
        {description = "17", data = 17},
        {description = "27.2(預設)", data = 27.2},
        {description = "30", data = 30},
        {description = "34", data = 34},
        {description = "39", data = 39},
      },
      default = 27.2,
    },

    {
      name = "ampuuses",
      label = "截肢鋸使用次數",
      hover = "在戰鬥中",
      options =
      {
        {description = "33", data = 33},
        {description = "50", data = 50},
        {description = "75", data = 75},
        {description = "100(預設)", data = 100},
        {description = "150", data = 150},
        {description = "175", data = 175},
        {description = "190", data = 190},
        {description = "200", data = 200},
      },
      default = 100,
    },

    {
      name = "ampuhealth",
      label = "截肢鋸生命回覆",
      options =
      {
        {description = "5", data = 5},
        {description = "10", data = 10},
        {description = "15", data = 15},
        {description = "20", data = 20},
        {description = "25", data = 25},
        {description = "30(預設)", data = 30},
        {description = "35", data = 35},
        {description = "40", data = 40},
        {description = "50", data = 50},
        {description = "60", data = 60},
        {description = "70", data = 70},
        {description = "80", data = 80},
        {description = "90", data = 90},
        {description = "95", data = 95},
        {description = "100", data = 100},
      },
      default = 30,
    },

    {
      name = "vitadmg",
      label = "還魂鋸基本傷害",
      options =
      {
        {description = "10", data = 10},
        {description = "15", data = 15},
        {description = "20", data = 20},
        {description = "27.2", data = 27.2},
        {description = "29(預設)", data = 29},
        {description = "30", data = 30},
        {description = "34", data = 34},
        {description = "40", data = 40},
        {description = "45", data = 45},
        {description = "50", data = 50},
      },
      default = 29,
    },

    {
      name = "vitauses",
      label = "還魂鋸使用次數",
      options =
      {
        {description = "33", data = 33},
        {description = "50", data = 50},
        {description = "75", data = 75},
        {description = "100(預設)", data = 100},
        {description = "150", data = 150},
        {description = "175", data = 175},
        {description = "190", data = 190},
        {description = "200", data = 200},
      },
      default = 100,
    },

    {
      name = "smedkithealth",
      label = "小醫療包",
      hover = "小醫療包回血多少？",
      options =
      {
        {description = "5", data = 5},
        {description = "7", data = 7},
        {description = "10", data = 10},
        {description = "15", data = 15},
        {description = "20(預設)", data = 20},
        {description = "25", data = 25},
        {description = "29", data = 29},
      },
      default = 20,
    },

    {
      name = "medmedkithealth",
      label = "中醫療包",
      hover = "中醫療包回血多少？",
      options =
      {
        {description = "30", data = 30},
        {description = "33", data = 33},
        {description = "35", data = 10},
        {description = "40", data = 15},
        {description = "45(預設)", data = 45},
        {description = "50", data = 50},
        {description = "55", data = 55},
        {description = "60", data = 60},
        {description = "65", data = 65},
      },
      default = 45,
    },

    {
      name = "lmedkithealth",
      label = "大醫療包",
      hover = "大醫療包回血多少？",
      options =
      {
        {description = "67", data = 67},
        {description = "70", data = 70},
        {description = "75", data = 75},
        {description = "80", data = 80},
        {description = "85", data = 85},
        {description = "90", data = 90},
        {description = "95", data = 95},
        {description = "100(預設)", data = 100},
        {description = "105", data = 105},
        {description = "110", data = 110},
        {description = "115", data = 115},
        {description = "120", data = 120},
        {description = "125", data = 125},
        {description = "130", data = 130},
        {description = "135", data = 135},
        {description = "140", data = 140},
        {description = "145", data = 145},
        {description = "150", data = 150},
      },
      default = 100,
    },

  }
)
