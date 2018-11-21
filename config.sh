
AUTOMOUNT=true

PROPFILE=false

POSTFSDATA=false

LATESTARTSERVICE=false



print_modname() {
  ui_print " "
  ui_print "    *******************************************"
  ui_print "    Nokia Extensions"
  ui_print "    *******************************************"
  ui_print "    v1.3"
  ui_print "    by Akilesh"
  ui_print "    *******************************************"
  ui_print " "

}


REPLACE="
/system/app/Youtube
/system/priv-app/SystemUI
/system/priv-app/Settings
/system/framework
"

REPLACE="
"


set_permissions() {
  

  # The following is default permissions, DO NOT remove
  set_perm_recursive  $MODPATH  0  0  0755  0644
}


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
	
	if [ $BRAND != "Nokia" ]; then
		abort "   => Brand '"$BRAND"' is not supported"
	fi
	
	if [ $RELEASE != "8.1.0" ] && [ $RELEASE != "9" ]; then
		abort "   => Android version '"$RELEASE"' is not supported"
	fi
	
	ui_print "   Your device is compatible    "
	ui_print "********************************"
    ui_print "       Extend your Nokia!       "
    ui_print "********************************"
    ui_print " "
    ui_print "  Use the Volume keys to select "
    ui_print "     what you want to install   "
    ui_print " "

    # Change this path to wherever the keycheck binary is located in your installer
    KEYCHECK=$INSTALLER/common/keycheck
    chmod 755 $KEYCHECK

    keytest() {
    ui_print "- Vol Key Test -"
    ui_print "   Press Vol Up:"
    (/system/bin/getevent -lc 1 2>&1 | /system/bin/grep VOLUME | /system/bin/grep " DOWN" > $INSTALLER/events) || return 1
    return 0
    }   

    choose() {
    #note from chainfire @xda-developers: getevent behaves weird when piped, and busybox grep likes that even less than toolbox/toybox grep
    while (true); do
       /system/bin/getevent -lc 1 2>&1 | /system/bin/grep VOLUME | /system/bin/grep " DOWN" > $INSTALLER/events
       if (`cat $INSTALLER/events 2>/dev/null | /system/bin/grep VOLUME >/dev/null`); then
         break
       fi
    done
    if (`cat $INSTALLER/events 2>/dev/null | /system/bin/grep VOLUMEUP >/dev/null`); then
       return 0
    else
       return 1
    fi
    }

    chooseold() {
    # Calling it first time detects previous input. Calling it second time will do what we want
    $KEYCHECK
    $KEYCHECK
    SEL=$?
    if [ "$1" == "UP" ]; then
       UP=$SEL
    elif [ "$1" == "DOWN" ]; then
       DOWN=$SEL
    elif [ $SEL -eq $UP ]; then
       return 0
    elif [ $SEL -eq $DOWN ]; then
       return 1
    else
       ui_print "   Vol key not detected!"
       abort "   Aborting Installation"
    fi
    }
    
    ui_print " "
    if [ -z $NEW ]; then
        if keytest; then
          FUNCTION=choose
        else
          FUNCTION=chooseold
    	  ui_print "   ! Legacy device detected! Using old keycheck method"
    	  ui_print " "
    	  ui_print "- Vol Key Programming -"
    	  ui_print "   Press Vol Up Again:"
    	  $FUNCTION "UP"
    	  ui_print "   Press Vol Down"
    	  $FUNCTION "DOWN"
  	    fi
        ui_print " "
        ui_print "- Select Options -"
        ui_print " Choose what you want to install!"
        ui_print " "
        
        ui_print " Do you want to install AI floating button?"
        ui_print " Vol up = Yes, Vol Down = No"
        ui_print " "
        if $FUNCTION; then 
           AI=true
        else 
           AI=false
        fi

        ui_print " Do you want to install Data Speed Indicator?"
        ui_print " Vol up = Yes, Vol Down = No"
        ui_print " "
        if $FUNCTION; then 
           DS=true
        else 
           DS=false
        fi

        ui_print " Do you want to install Screenshot plus?"
        ui_print " Vol up = Yes, Vol Down = No"
        ui_print " "
        if $FUNCTION; then 
           SS=true
        else 
           SS=false
        fi

        ui_print " Do you want to install Screen recorder?"
        ui_print " Vol up = Yes, Vol Down = No"
        ui_print " "
        if $FUNCTION; then 
           SR=true
        else 
           SR=false
        fi

        ui_print " Do you want to install Smart tuner?" 
        ui_print " includes Junk Cleaner, Task Manager, Smart Boost and Virus scan"
        ui_print " Vol up = Yes, Vol Down = No"
        ui_print " "
        if $FUNCTION; then 
           ST=true
        else 
           ST=false
        fi


        ui_print " Do you want to change the system font to NokiaPure?"
        ui_print " Vol up = Yes, Vol Down = No"
        ui_print " "
        if $FUNCTION; then 
           NP=true
        else 
           NP=false
        fi

    else
        ui_print "   Option specified in zipname!"
    fi
    
    ui_print " "
    ui_print " Extracting module files for '"$DEVICE"' running Android '"$RELEASE"'"
    ui_print " "
	unzip -o "$ZIP" $RELEASE'/*' -d $INSTALLER 2>/dev/null

    
    if [ $RELEASE == "8.1.0" ]; then    

        if $AI; then
            ui_print " "
            ui_print "* Installing AI floating button..."	
            AI_APK=$INSTALLER/$RELEASE/priv-app/AIFloatingTouch/AIFloatingTouch.apk
            mkdir -p $MODPATH/system/priv-app/AIFloatingTouch 2>/dev/null
            cp -af $AI_APK $MODPATH/system/priv-app/AIFloatingTouch/AIFloatingTouch.apk

            IS_APK=$INSTALLER/$RELEASE/priv-app/IntelligentSuggestion/IntelligentSuggestion.apk
            mkdir -p $MODPATH/system/priv-app/IntelligentSuggestion 2>/dev/null
            cp -af $IS_APK $MODPATH/system/priv-app/IntelligentSuggestion/IntelligentSuggestion.apk
            ui_print "  done!"
        else
            ui_print " "
            ui_print "AI floating touch not installed"
        fi

        if $DS; then
            ui_print " "
            ui_print "* Installing Data Speed Indicator..."	
            DS_APK=$INSTALLER/$RELEASE/priv-app/DataSpeedIndicator/DataSpeedIndicator.apk
            DS_APK_O=$INSTALLER/$RELEASE/vendor/cust/overlay/600WW/com.evenwell.dataspeedindicator.overlay.base.600WW.apk
            DS_APK_OD=$INSTALLER/$RELEASE/priv-app/DataSpeedIndicator/oat/arm64/DataSpeedIndicator.odex
            DS_APK_VD=$INSTALLER/$RELEASE/priv-app/DataSpeedIndicator/oat/arm64/DataSpeedIndicator.vdex
            mkdir -p $MODPATH/system/priv-app/DataSpeedIndicator/ 2>/dev/null
            mkdir -p $MODPATH/system.priv-app/DataSpeedIndicator/oat/arm64 2>/dev/null
            cp -af $DS_APK $MODPATH/system/priv-app/DataSpeedIndicator/DataSpeedIndicator.apk
            cp -af $DS_APK_O $MODPATH/system/vendor/cust/overlay/600WW/com.evenwell.dataspeedindicator.overlay.base.600WW.apk
            cp -af $DS_APK_OD $MODPATH/system/priv-app/DataSpeedIndicator/oat/arm64/DataSpeedIndicator.odex
            cp -af $DS_APK_VD $MODPATH/system/priv-app/DataSpeedIndicator/oat/arm64/DataSpeedIndicator.vdex
            ui_print "  done!"

        else
            ui_print " "
            ui_print "Data Speed Indicator not installed"
        fi

        if $SS; then
            ui_print " "
            ui_print "* Installing ScreenShot Plus..."	
            SS_APK=$INSTALLER/$RELEASE/app/ScreenShotPlus/ScreenShotPlus.apk
            SS_APK_O=$INSTALLER/$RELEASE/vendor/cust/overlay/600WW/com.nbc.screenshotplus.overlay.base.600WW.apk
            mkdir -p $MODPATH/system/app/ScreenShotPlus 2>/dev/null
            cp -af $SS_APK $MODPATH/system/app/ScreenShotPlus/ScreenShotPlus.apk
            cp -af $SS_APK_O $MODPATH/system/vendor/cust/overlay/600WW/com.nbc.screenshotplus.overlay.base.600WW.apk
            ui_print "  done!"

        else
            ui_print " "
            ui_print "ScreenShot Plus not installed"
        fi
    
        if $SR; then
            ui_print " "
        	ui_print "* Installing Screen Recorder..."
            SR_APK=$INSTALLER/$RELEASE/priv-app/ScreenRecorder/ScreenRecorder.apk
            SR_APK_O=$INSTALLER/$RELEASE/vendor/cust/overlay/600WW/com.nbc.android.screenrecord.overlay.base.600WW.apk
            SR_APK_OD=$INSTALLER/$RELEASE/priv-app/ScreenRecorder/oat/arm64/ScreenRecorder.odex
            SR_APK_VD=$INSTALLER/$RELEASE/priv-app/ScreenRecorder/oat/arm64/ScreenRecorder.vdex
            mkdir -p $MODPATH/system/app/ScreenRecorder 2>/dev/null
            mkdir -p $MODPATH/system/app/ScreenRecorder/oat/arm64 2>/dev/null
            cp -af $SR_APK $MODPATH/system/priv-app/ScreenRecorder/ScreenRecorder.apk
            cp -af $SR_APK_OD $MODPATH/system/priv-app/ScreenRecorder/oat/arm64/ScreenRecorder.odex
            cp -af $SR_APK_VD $MODPATH/system/priv-app/ScreenRecorder/oat/arm64/ScreenRecorder.vdex
            cp -af $SR_APK_O $MODPATH/system/vendor/cust/overlay/600WW/com.nbc.android.screenrecord.overlay.base.600WW.apk
            ui_print "  done!"

        else
            ui_print " "
            ui_print "Screen Recorder not installed"
        fi

        if $ST; then
            ui_print " "
        	ui_print "* Installing Smart tuner..."

            ui_print "  - Installing System Dashboard..."
            ST_APK=$INSTALLER/$RELEASE/priv-app/SystemDashboard/SystemDashboard.apk
            SS_APK_O=$INSTALLER/$RELEASE/vendor/cust/overlay/600WW/com.evenwell.systemdashboard.mobileassistant.overlay.base.600WW.apk
            mkdir -p $MODPATH/system/priv-app/SystemDashboard 2>/dev/null
            cp -af $SS_APK $MODPATH/system/priv-app/SystemDashboard/SystemDashboard.apk
            cp -af $SS_APK_O $MODPATH/system/vendor/cust/overlay/600WW/com.evenwell.systemdashboard.mobileassistant.overlay.base.600WW.apk
            ui_print "    done!"

            ui_print "  - Installing Junk Cleaner..."
            JC_APK=$INSTALLER/$RELEASE/priv-app/JunkCleaner/JunkCleaner.apk
            JC_APK_O=$INSTALLER/$RELEASE/vendor/cust/overlay/600WW/com.evenwell.memorycleaner.overlay.base.600WW.apk
            JC_APK_L1=$INSTALLER/$RELEASE/priv-app/JunkCleaner/lib/arm64/libdce-1.1.16-mfr.so
            JC_APK_L2=$INSTALLER/$RELEASE/priv-app/JunkCleaner/lib/arm64/libTmsdk-2.0.10-mfr.so
            mkdir -p $MODPATH/system/priv-app/JunkCleaner 2>/dev/null
            mkdir -p $MODPATH/system/priv-app/JunkCleaner/lib/arm64 2>/dev/null 
            cp -af $JC_APK $MODPATH/system/priv-app/JunkCleaner/JunkCleaner.apk
            cp -af $JC_APK_O $MODPATH/system/vendor/cust/overlay/600WW/com.evenwell.memorycleaner.overlay.base.600WW.apk
            cp -af $JC_APK_L1 $MODPATH/system/priv-app/JunkCleaner/lib/arm64/libdce-1.1.16-mfr.so
            cp -af $JC_APK_L2 $MODPATH/system/priv-app/JunkCleaner/lib/arm64/libTmsdk-2.0.10-mfr.so
            ui_print "    done!"
            
            ui_print "  - Installing Task Manager..."
            TM_APK=$INSTALLER/$RELEASE/priv-app/TaskManager/TaskManager.apk
            mkdir -p $MODPATH/system/priv-app/TaskManager 2>/dev/null
            cp -af $TM_APK $MODPATH/system/priv-app/TaskManager/TaskManager.apk
            ui_print "    done!"

            ui_print "  - Installing Virus Scanner..."
            VS_APK=$INSTALLER/$RELEASE/priv-app/VirusScan/VirusScan.apk
            VS_APK_L1=$INSTALLER/$RELEASE/priv-app/VirusScan/lib/arm64/libams-1.2.6-mfr.so
            VS_APK_L2=$INSTALLER/$RELEASE/priv-app/VirusScan/lib/arm64/libdce-1.1.16-mfr.so
            VS_APK_L3=$INSTALLER/$RELEASE/priv-app/VirusScan/lib/arm64/libTmsdk-2.0.10-mfr.so
            mkdir -p $MODPATH/system/priv-app/VirusScan 2>/dev/null
            mkdir -p $MODPATH/system/priv-app/VirusScan/lib/arm64 2>/dev/null
            cp -af $VS_APK $MODPATH/system/priv-app/VirusScan/VirusScan.apk
            cp -af $VS_APK_L1 $MODPATH/system/priv-app/VirusScan/lib/arm64/libams-1.2.6-mfr.so
            cp -af $VS_APK_L2 $MODPATH/system/priv-app/VirusScan/lib/arm64/libdce-1.1.16-mfr.so
            cp -af $VS_APK_L2 $MODPATH/system/priv-app/VirusScan/lib/arm64/libTmsdk-2.0.10-mfr.so
            ui_print "    done!"
        
            ui_print "  - Installing Smart Boost..."
            SM_APK=$INSTALLER/$RELEASE/priv-app/SmartBoost/SmartBoost.apk
            SB_PER=$INSTALLER/$RELEASE/etc/permissions/SmartBoostFramework.xml
            SB_CFG=$INSTALLER/$RELEASE/etc/SmartBoostCfg
            SB_FM=$INSTALLER/$RELEASE/framework/SmartBoostFramework.jar
            SB_OD1=$INSTALLER/$RELEASE/framework/oat/arm/SmartBoostFramework.odex
            SB_VD1=$INSTALLER/$RELEASE/framework/oat/arm/SmartBoostFramework.vdex
            SB_OD2=$INSTALLER/$RELEASE/framework/oat/arm64/SmartBoostFramework.odex
            SB_VD1=$INSTALLER/$RELEASE/framework/oat/arm64/SmartBoostFramework.vdex
            mkdir -p $MODPATH/system/priv-app/SmartBoost 2>/dev/null
            cp -af $SM_APK $MODPATH/system/priv-app/SmartBoost/SmartBoost.apk
            cp -af $SB_PER $MODPATH/system/etc/permissions/SmartBoostFramework.xml
            cp -af $SB_CFG $MODPATH/system/etc/SmartBoostCfg
            cp -af $SB_FM $MODPATH/system/framework/SmartBoostFramework.jar
            cp -af $SB_OD1 $MODPATH/system/framework/oat/arm/SmartBoostFramework.odex
            cp -af $SB_VD1 $MODPATH/system/framework/oat/arm/SmartBoostFramework.vdex
            cp -af $SB_OD2 $MODPATH/system/framework/oat/arm64/SmartBoostFramework.odex
            cp -af $SB_VD2 $MODPATH/system/framework/oat/arm64/SmartBoostFramework.vdex

            ui_print "    done!"

        else
            ui_print " "
            ui_print "Smart tuner not installed"
        fi        
    
        if $NP; then
            ui_print " "
        	ui_print "Changing system font to NokiaPure..."
            NP_B=$INSTALLER/$RELEASE/fonts/Roboto-Bold.ttf
            NP_I=$INSTALLER/$RELEASE/fonts/Roboto-Italic.ttf
            NP_BI=$INSTALLER/$RELEASE/fonts/Roboto-BoldItalic.ttf
            NP_R=$INSTALLER/$RELEASE/fonts/Roboto-Regular.ttf
            cp -af $NP_B $MODPATH/system/fonts/Roboto-Bold.ttf
            cp -af $NP_I $MODPATH/system/fonts/Roboto-Italic.ttf
            cp -af $NP_BI $MODPATH/system/fonts/Roboto-BoldItalic.ttf
            cp -af $NP_R $MODPATH/system/fonts/Roboto-Regular.ttf
            ui_print "  done!"

        else
            ui_print " "
            ui_print "NokiaPure fonts not installed"
        fi

    ui_print " "    
    ui_print "Installation complete!"
    ui_print " "

    fi


    

    if [ $RELEASE == "9" ]; then

        if $AI; then
            ui_print " "
            ui_print "* Installing AI floating button..."	
            AI_APK=$INSTALLER/$RELEASE/product/CDA/items/AIFloatingTouch/AIFloatingTouch.apk
            mkdir -p $MODPATH/system/product/CDA/items/AIFloatingTouch 2>/dev/null
            cp -af $AI_APK $MODPATH/system/priv-app/AIFloatingTouch/AIFloatingTouch.apk

            IS_APK=$INSTALLER/$RELEASE/product/CDA/items/IntelligentSuggestion/IntelligentSuggestion.apk
            mkdir -p $MODPATH/system/product/CDA/items/IntelligentSuggestion 2>/dev/null
            cp -af $IS_APK $MODPATH/system/priv-app/IntelligentSuggestion/IntelligentSuggestion.apk
            ui_print "  done!"
        else
            ui_print " "
            ui_print "AI floating touch not installed"
        fi

        if $DS; then
            ui_print " "
            ui_print "* Installing Data Speed Indicator..."	
            DS_APK=$INSTALLER/$RELEASE/priv-app/DataSpeedIndicator/DataSpeedIndicator.apk
            DS_APK_O=$INSTALLER/$RELEASE/product/overlay/com.evenwell.dataspeedindicator.overlay.base.600WW.apk
            mkdir -p $MODPATH/system/priv-app/DataSpeedIndicator/ 2>/dev/null
            cp -af $DS_APK $MODPATH/system/priv-app/DataSpeedIndicator/DataSpeedIndicator.apk
            cp -af $DS_APK_O $MODPATH/system/product/overlay/com.evenwell.dataspeedindicator.overlay.base.600WW.apk
            ui_print "  done!"
        else
            ui_print " " 
            ui_print "Data Speed Indicator not installed"
        fi
   	
        if $SS; then
            ui_print " "
            ui_print "* Installing ScreenShot Plus..."	
            SS_APK=$INSTALLER/$RELEASE/priv-app/ScreenShotPlus/ScreenShotPlus.apk
            mkdir -p $MODPATH/system/priv-app/ScreenShotPlus 2>/dev/null
            cp -af $SS_APK $MODPATH/system/priv-app/ScreenShotPlus/ScreenShotPlus.apk
            ui_print "  done!"

        else
            ui_print " "
            ui_print "ScreenShot Plus not installed"
        fi

        if $SR; then
            ui_print " "
        	ui_print "* Installing Screen Recorder..."
            SR_APK=$INSTALLER/$RELEASE/product/CDA/items/ScreenRecorder/ScreenRecorder.apk
            SR_APK_O=$INSTALLER/$RELEASE/product/overlay/com.nbc.android.screenrecord.overlay.base.600WW.apk
            mkdir -p $MODPATH/system/product/CDA/items/ScreenRecorder 2>/dev/null
            cp -af $SR_APK $MODPATH/system/priv-app/ScreenRecorder/ScreenRecorder.apk
            cp -af $SR_APK_O $MODPATH/system/product/overlay/com.nbc.android.screenrecord.overlay.base.600WW.apk
            ui_print "  done!"

        else
            ui_print " "
            ui_print "Screen Recorder not installed"
        fi

        if $ST; then
            ui_print " "
        	ui_print "* Installing Smart tuner..."

            ui_print "  - Installing System Dashboard..."
            ST_APK=$INSTALLER/$RELEASE/priv-app/SystemDashboard/SystemDashboard.apk
            SS_APK_O=$INSTALLER/$RELEASE/product/overlay/com.evenwell.systemdashboard.mobileassistant.overlay.base.600WW.apk
            mkdir -p $MODPATH/system/priv-app/SystemDashboard 2>/dev/null
            cp -af $SS_APK $MODPATH/system/priv-app/SystemDashboard/SystemDashboard.apk
            cp -af $SS_APK_O $MODPATH/system/product/overlay/com.evenwell.systemdashboard.mobileassistant.overlay.base.600WW.apk
            ui_print "    done!"

            ui_print "  - Installing Junk Cleaner..."
            JC_APK=$INSTALLER/$RELEASE/priv-app/JunkCleaner/JunkCleaner.apk
            JC_APK_O=$INSTALLER/$RELEASE/product/overlay/600WW/com.evenwell.memorycleaner.overlay.base.600WW.apk
            JC_APK_L1=$INSTALLER/$RELEASE/priv-app/JunkCleaner/lib/arm64/libdce-1.1.18-mfr.so
            JC_APK_L2=$INSTALLER/$RELEASE/priv-app/JunkCleaner/lib/arm64/libTmsdk-2.0.10-mfr.so
            mkdir -p $MODPATH/system/priv-app/JunkCleaner 2>/dev/null
            mkdir -p $MODPATH/system/priv-app/JunkCleaner/lib/arm64 2>/dev/null 
            cp -af $JC_APK $MODPATH/system/priv-app/JunkCleaner/JunkCleaner.apk
            cp -af $JC_APK_O $MODPATH/system/product/overlay/com.evenwell.memorycleaner.overlay.base.600WW.apk
            cp -af $JC_APK_L1 $MODPATH/system/priv-app/JunkCleaner/lib/arm64/libdce-1.1.18-mfr.so
            cp -af $JC_APK_L2 $MODPATH/system/priv-app/JunkCleaner/lib/arm64/libTmsdk-2.0.10-mfr.so
            ui_print "    done!"
            
            ui_print "  - Installing Task Manager..."
            TM_APK=$INSTALLER/$RELEASE/priv-app/TaskManager/TaskManager.apk
            mkdir -p $MODPATH/system/priv-app/TaskManager 2>/dev/null
            cp -af $TM_APK $MODPATH/system/priv-app/TaskManager/TaskManager.apk
            ui_print "    done!"

            ui_print "  - Installing Virus Scanner..."
            VS_APK=$INSTALLER/$RELEASE/priv-app/VirusScan/VirusScan.apk
            VS_APK_L1=$INSTALLER/$RELEASE/priv-app/VirusScan/lib/arm64/libams-1.2.6-mfr.so
            VS_APK_L2=$INSTALLER/$RELEASE/priv-app/VirusScan/lib/arm64/libdce-1.1.16-mfr.so
            VS_APK_L3=$INSTALLER/$RELEASE/priv-app/VirusScan/lib/arm64/libTmsdk-2.0.10-mfr.so
            mkdir -p $MODPATH/system/priv-app/VirusScan 2>/dev/null
            mkdir -p $MODPATH/system/priv-app/VirusScan/lib/arm64 2>/dev/null
            cp -af $VS_APK $MODPATH/system/priv-app/VirusScan/VirusScan.apk
            cp -af $VS_APK_L1 $MODPATH/system/priv-app/VirusScan/lib/arm64/libams-1.2.6-mfr.so
            cp -af $VS_APK_L2 $MODPATH/system/priv-app/VirusScan/lib/arm64/libdce-1.1.16-mfr.so
            cp -af $VS_APK_L2 $MODPATH/system/priv-app/VirusScan/lib/arm64/libTmsdk-2.0.10-mfr.so
            ui_print "    done!"
        
            ui_print "  - Installing Smart Boost..."
            SM_APK=$INSTALLER/$RELEASE/priv-app/SmartBoost/SmartBoost.apk
            SB_PER=$INSTALLER/$RELEASE/etc/permissions/SmartBoostFramework.xml
            SB_CFG=$INSTALLER/$RELEASE/etc/SmartBoostCfg
            SB_FM=$INSTALLER/$RELEASE/framework/SmartBoostFramework.jar
            SB_OD1=$INSTALLER/$RELEASE/framework/oat/arm/SmartBoostFramework.odex
            SB_VD1=$INSTALLER/$RELEASE/framework/oat/arm/SmartBoostFramework.vdex
            SB_OD2=$INSTALLER/$RELEASE/framework/oat/arm64/SmartBoostFramework.odex
            SB_VD1=$INSTALLER/$RELEASE/framework/oat/arm64/SmartBoostFramework.vdex
            mkdir -p $MODPATH/system/priv-app/SmartBoost 2>/dev/null
            cp -af $SM_APK $MODPATH/system/priv-app/SmartBoost/SmartBoost.apk
            cp -af $SB_PER $MODPATH/system/etc/permissions/SmartBoostFramework.xml
            cp -af $SB_CFG $MODPATH/system/etc/SmartBoostCfg
            cp -af $SB_FM $MODPATH/system/framework/SmartBoostFramework.jar
            cp -af $SB_OD1 $MODPATH/system/framework/oat/arm/SmartBoostFramework.odex
            cp -af $SB_VD1 $MODPATH/system/framework/oat/arm/SmartBoostFramework.vdex
            cp -af $SB_OD2 $MODPATH/system/framework/oat/arm64/SmartBoostFramework.odex
            cp -af $SB_VD2 $MODPATH/system/framework/oat/arm64/SmartBoostFramework.vdex

            ui_print "    done!"

        else
            ui_print " "
            ui_print "Smart tuner not installed"
        fi        

        if $NP; then
            ui_print " "
        	ui_print "Changing system font to NokiaPure..."
            NP_B=$INSTALLER/$RELEASE/fonts/Roboto-Bold.ttf
            NP_I=$INSTALLER/$RELEASE/fonts/Roboto-Italic.ttf
            NP_BI=$INSTALLER/$RELEASE/fonts/Roboto-BoldItalic.ttf
            NP_R=$INSTALLER/$RELEASE/fonts/Roboto-Regular.ttf
            cp -af $NP_B $MODPATH/system/fonts/Roboto-Bold.ttf
            cp -af $NP_I $MODPATH/system/fonts/Roboto-Italic.ttf
            cp -af $NP_BI $MODPATH/system/fonts/Roboto-BoldItalic.ttf
            cp -af $NP_R $MODPATH/system/fonts/Roboto-Regular.ttf
            ui_print "  done!"

        else
            ui_print " "
            ui_print "NokiaPure fonts not installed"
        fi

    ui_print " "    
    ui_print "Installation complete!"
    ui_print " "
        
    fi


}
