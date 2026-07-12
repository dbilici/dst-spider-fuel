name = "Spider Fuel"
description = "Allows Silk and Spider Glands to be used as burnable fuel."
author = "k0za1ak"
version = "1.1.1"

forumthread = ""
api_version = 10

dst_compatible = true
dont_starve_compatible = false
reign_of_giants_compatible = false
shipwrecked_compatible = false
hamlet_compatible = false

all_clients_require_mod = false
client_only_mod = false
server_filter_tags = { "fuel" }

icon_atlas = "modicon.xml"
icon = "modicon.tex"

configuration_options = {
    {
        name = "spidergland_fuel_value",
        label = "Spider Gland Fuel Value",
        hover = "Wet Goop style by default.",
        options = {
            {description = "Tiny", data = "tiny"},
            {description = "Small", data = "small"},
            {description = "Medium", data = "medium"},
        },
        default = "tiny",
    },
    {
        name = "silk_fuel_value",
        label = "Silk Fuel Value",
        hover = "Beard Hair style by default.",
        options = {
            {description = "Tiny", data = "tiny"},
            {description = "Small", data = "small"},
            {description = "Medium", data = "medium"},
        },
        default = "small",
    },
}
