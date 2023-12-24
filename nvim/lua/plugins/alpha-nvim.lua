local alpha = require("alpha")
local dashboard = require("alpha.themes.dashboard")

dashboard.section.header.val = {
    "                                                    ",
    " ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ",
    " ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ",
    " ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ",
    " ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ",
    " ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ",
    " ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ",
    "                                                    ",
}

dashboard.section.buttons.val = {
    dashboard.button("n", "  New File", "<cmd>ene<CR>"),
    dashboard.button("SPC q l", "  Restore Last Session", [[<cmd>lua require("persistence").load()<CR>]]),
    dashboard.button("SPC f r", "  Recent Files", "<cmd>Telescope oldfiles<CR>"),
    dashboard.button("SPC f f", "  Find File", "<cmd>Telescope find_files<CR>"),
    dashboard.button("SPC f g", "  Find Word", "<cmd>Telescope live_grep<CR>"),
    dashboard.button("l", "󰒲  Lazy", "<cmd>Lazy<CR>"),
    dashboard.button("m", "󱌣  Mason", "<cmd>Mason<CR>"),
    dashboard.button("q", "  Quit", "<cmd>qa<CR>"),
}

alpha.setup(dashboard.opts)
