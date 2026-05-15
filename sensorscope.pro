# SensorScope - a Harmattan-targeted explorer for Qt Mobility sensors
# and system info. Based on the structure of Nokia's Compass example.

QT       += declarative xml
CONFIG   += qt-components
CONFIG   += mobility
MOBILITY += sensors systeminfo location

TARGET = sensorscope
TEMPLATE = app

VERSION = 1.0

HEADERS += qmlloader.h
SOURCES += main.cpp qmlloader.cpp

OTHER_FILES += \
    qml/harmattan/*.qml \
    qml/common/*.qml \
    qml/common/sources/*.qml \
    qtc_packaging/debian_harmattan/*

# Harmattan only (the N9). No Symbian variant for this project.
unix:!symbian:!maemo5 {
    message(SensorScope - Harmattan build)
    DEFINES += Q_WS_HARMATTAN

    CONFIG += qdeclarative-boostable

    target.path = /opt/sensorscope/bin

    qml.files = qml/common qml/harmattan
    qml.path = /opt/sensorscope/qml

    desktopfile.files = qtc_packaging/debian_harmattan/$${TARGET}.desktop
    desktopfile.path = /usr/share/applications

    icon.files = icons/sensorscope.png
    icon.path = /usr/share/icons/hicolor/80x80/apps

    INSTALLS += target qml desktopfile icon
}
