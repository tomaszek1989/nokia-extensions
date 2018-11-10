
##########################################################################################
# Configs
##########################################################################################

# Set to true if you need to enable Magic Mount
# Most mods would like it to be enabled
AUTOMOUNT=true

# Set to true if you need to load system.prop
PROPFILE=false

# Set to true if you need post-fs-data script
POSTFSDATA=false

# Set to true if you need late_start service script
LATESTARTSERVICE=false

##########################################################################################
# Installation Message
##########################################################################################

# Set what you want to show when installing your mod

print_modname() {
 ui_print "-------------------"
 ui_print " Module by Akilesh "
 ui_print "  Only for Oreo!   "
 ui_print "-------------------"
}

##########################################################################################
# Replace list
##########################################################################################

# List all directories you want to directly replace in the system
# Check the documentations for more info about how Magic Mount works, and why you need this

# This is an example
REPLACE="
/system/app/Youtube
/system/priv-app/SystemUI
/system/priv-app/Settings
/system/framework
"

# Construct your own list here, it will override the example above
# !DO NOT! remove this if you don't need to replace anything, leave it empty as it is now
REPLACE="
"

##########################################################################################
# Permissions
##########################################################################################

set_permissions() {
  

  # The following is default permissions, DO NOT remove
  set_perm_recursive  $MODPATH  0  0  0755  0644
}

##########################################################################################
# Custom Functions
##########################################################################################

# This file (config.sh) will be sourced by the main flash script after util_functions.sh
# If you need custom logic, please add them here as functions, and call these functions in
# update-binary. Refrain from adding code directly into update-binary, as it will make it
# difficult for you to migrate your modules to newer template versions.
# Make update-binary as clean as possible, try to only do function calls in it.

install_module() {

	ui_print "_____________________________________"
	ui_print " "
	ui_print "Trying to install Nokia Extensions..."
	
	DEVICE=`getprop ro.product.device`
	RELEASE=`getprop ro.build.version.release`
	BRAND=`getprop ro.product.brand`
	ui_print " "

	
	ui_print "Performing compatibility check..."
	ui_print " "
        ui_print "  Brand           : "$BRAND
	ui_print "  Device          : "$DEVICE
	ui_print "  Android version : "$RELEASE
	ui_print " "
	
	if [ $BRAND != "Nokia" ] && [ $BRAND != "FIH" ]; then
		abort "   => Brand '"$BRAND"' is not supported"
	fi
	
	if [ $RELEASE != "8.1.0" ]; then
		abort "   => Android version '"$RELEASE"' is not supported"
	fi
	
	ui_print "   Your device is compatible   "
	ui_print " "
	ui_print "*******************************"
        ui_print "      Extended your Nokia!     "
        ui_print "*******************************"
        ui_print " "

    
}
