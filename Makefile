export TARGET=iphone:clang:latest:8.0
export ARCHS=armv7 arm64
include theos/makefiles/common.mk

TWEAK_NAME = StatusBarPrettifier
StatusBarPrettifier_FILES = Tweak.xm

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 backboardd"

SUBPROJECTS = prefs
include $(THEOS_MAKE_PATH)/aggregate.mk
