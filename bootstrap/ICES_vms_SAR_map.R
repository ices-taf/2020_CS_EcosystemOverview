
taf.library("icesVMS")

# icesVMS::update_token("colin")
vms_sar <- icesVMS::get_sar_map("Celtic Seas")

# convert to sf
vms_sar$wkt <- sf::st_as_sfc(vms_sar$wkt)
vms_sar <- sf::st_sf(vms_sar, sf_column_name = "wkt", crs = 4326)

sf::st_write(vms_sar, "vms_sar.csv", layer_options = "GEOMETRY=AS_WKT")
