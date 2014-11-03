include theos/makefiles/common.mk

BUNDLE_NAME = StatusBarPrettifierPrefs
StatusBarPrettifierPrefs_FILES = StatusBarPrettifierPrefs.mm
StatusBarPrettifierPrefs_INSTALL_PATH = /Library/PreferenceBundles
StatusBarPrettifierPrefs_FRAMEWORKS = UIKit
StatusBarPrettifierPrefs_PRIVATE_FRAMEWORKS = Preferences

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/StatusBarPrettifierPrefs.plist$(ECHO_END)
