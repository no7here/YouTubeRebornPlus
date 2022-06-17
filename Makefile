TARGET = iphone:clang:latest:12.0
CercubePlusLegacy_USE_FLEX = 0
ARCHS = arm64
MODULES = jailed
FINALPACKAGE = 1
CODESIGN_IPA = 0

TWEAK_NAME = CercubePlusLegacy
DISPLAY_NAME = YouTube
BUNDLE_ID = com.google.ios.youtube

CercubePlusLegacy_INJECT_DYLIBS = Tweaks/Cercube/Library/MobileSubstrate/DynamicLibraries/Cercube.dylib .theos/obj/libcolorpicker.dylib .theos/obj/iSponsorBlock.dylib .theos/obj/YouTubeDislikesReturn.dylib 
CercubePlusLegacy_FILES = CercubePlusLegacy.xm Settings.xm
CercubePlusLegacy_IPA = /System/Volumes/Data/Volumes/Data_Macintosh/Sideloads/IPAs/YouTube_17.20.3.ipa
CercubePlusLegacy_FRAMEWORKS = UIKit
### Important: edit the path to your decrypted YouTube IPA!!! 

include $(THEOS)/makefiles/common.mk
include $(THEOS_MAKE_PATH)/tweak.mk
SUBPROJECTS += Tweaks/Alderis Tweaks/iSponsorBlockLegacy Tweaks/Return-YouTube-Dislikes
include $(THEOS_MAKE_PATH)/aggregate.mk

before-package::
	@echo -e "==> \033[1mMoving tweak's bundle to Resources/...\033[0m"
	@mkdir -p Resources/Frameworks/Alderis.framework && find .theos/obj/install/Library/Frameworks/Alderis.framework -maxdepth 1 -type f -exec cp {} Resources/Frameworks/Alderis.framework/ \;
	@cp -R Tweaks/iSponsorBlockLegacy/layout/Library/Application\ Support/iSponsorBlockLegacy.bundle Resources/
	@cp -R Tweaks/Cercube/Library/Application\ Support/Cercube/Cercube.bundle Resources/
	@cp -R lang/CercubePlusLegacy.bundle Resources/
	@echo -e "==> \033[1mChanging the installation path of dylibs...\033[0m"
	@codesign --remove-signature .theos/obj/iSponsorBlock.dylib && install_name_tool -change /usr/lib/libcolorpicker.dylib @rpath/libcolorpicker.dylib .theos/obj/iSponsorBlock.dylib
	@codesign --remove-signature .theos/obj/libcolorpicker.dylib && install_name_tool -change /Library/Frameworks/Alderis.framework/Alderis @rpath/Alderis.framework/Alderis .theos/obj/libcolorpicker.dylib	
