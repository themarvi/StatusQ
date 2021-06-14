QT += quick svg

CONFIG += c++11 warn_on

DEFINES += QT_DEPRECATED_WARNINGS


# You can make your code fail to compile if it uses deprecated APIs.
# In order to do so, uncomment the following line.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

SOURCES += \
        handler.cpp \
        main.cpp \
        sandboxapp.cpp

!macx {
    SOURCES += statuswindow.cpp
}

TARGET = sandboxapp

macx {
    CONFIG -= app_bundle
    OBJECTIVE_SOURCES += \
        statuswindow_mac.mm
}

ios {
   LIBS += -framework UIKit

   QMAKE_TARGET_BUNDLE_PREFIX = "im.status"
   #QMAKE_XCODE_CODE_SIGN_IDENTITY = "iPhone Developer"
   MY_DEVELOPMENT_TEAM.name = "STATUS HOLDINGS PTE.LTD"
   MY_DEVELOPMENT_TEAM.value = "DTX7Z4U3YA"
   QMAKE_MAC_XCODE_SETTINGS += MY_DEVELOPMENT_TEAM

}

RESOURCES += qml.qrc \
            $$PWD/../statusq.qrc

DESTDIR = $$PWD/bin

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target
#OTHER_FILES += $$files($$PWD/../src/*, true)

HEADERS += \
    handler.h \
    sandboxapp.h \
    statuswindow.h

DISTFILES += \
    ../src/StatusQ/Components/StatusMacWindowButtons.qml \
    ../src/StatusQ/Controls/StatusBaseButton.qml \
    ../src/StatusQ/Controls/StatusButton.qml \
    ../src/StatusQ/Controls/StatusCheckBox.qml \
    ../src/StatusQ/Controls/StatusFlatRoundButton.qml \
    ../src/StatusQ/Controls/StatusRadioButton.qml \
    ../src/StatusQ/Controls/StatusSlider.qml \
    ../src/StatusQ/Controls/StatusSwitch.qml

android {

DISTFILES += \
    android/AndroidManifest.xml \
    android/build.gradle \
    android/gradle/wrapper/gradle-wrapper.jar \
    android/gradle/wrapper/gradle-wrapper.properties \
    android/gradlew \
    android/gradlew.bat \
    android/res/values/libs.xml

    contains(ANDROID_TARGET_ARCH,armeabi-v7a) {
        ANDROID_PACKAGE_SOURCE_DIR = \
            $$PWD/android
    }
}
