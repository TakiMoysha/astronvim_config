return {
  {
    "goolord/alpha-nvim",
    opts = function(_, opts)
      -- opts.section.header.val = {
      --   ":::::::::::     :::     :::    ::: :::::::::::",
      --   "    :+:       :+: :+:   :+:   :+:      :+:    ",
      --   "    +:+      +:+   +:+  +:+  +:+       +:+    ",
      --   "    +#+     +#++:++#++: +#++:++        +#+    ",
      --   "    +#+     +#+     +#+ +#+  +#+       +#+    ",
      --   "    #+#     #+#     #+# #+#   #+#      #+#    ",
      --   "    ###     ###     ### ###    ### ###########",
      -- }
    
      opts.section.header.val = {
        " .oooooo..o ooooo   ooooo       .o.       ooooo          .oooooo.   ooo        ooooo",
        "d8P'    `Y8 `888'   `888'      .888.      `888'         d8P'  `Y8b  `88.       .888'",
        "Y88bo.       888     888      .8'888.      888         888      888  888b     d'888 ",
        " `'Y8888o.   888ooooo888     .8' `888.     888         888      888  8 Y88. .P  888 ",
        "     `'Y88b  888     888    .88ooo8888.    888         888      888  8  `888'   888 ",
        "oo     .d8P  888     888   .8'     `888.   888       o `88b    d88'  8    Y     888 ",
        "8''88888P'  o888o   o888o o88o     o8888o o888ooooood8  `Y8bood8P'  o8o        o888o",
      }
      return opts
    end,
  },
  {
    "nvim-telescope/telescope.nvim",
    opts = function(_, opts)
      opts.defaults.file_ignore_patterns = {
        "node_modules",
        "package%-lock.json",
        "yarn.lock",
        ".git",
        ".cache",
      }
      return opts
    end
  }
}
