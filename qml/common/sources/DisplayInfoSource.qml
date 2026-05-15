/**
 * DisplayInfoSource.qml
 *
 * Properties per docs: backlightStatus, colorDepth, contrast,
 * displayBrightness, dpiHeight, dpiWidth, orientation, physicalHeight,
 * physicalWidth, screen.
 */

import QtQuick 1.1
import QtMobility.systeminfo 1.1

Item {
    id: source
    property string title: "Display"
    property string subtitle: "Screen brightness, color depth, DPI, size"
    property bool active: true

    property int brightness: di.displayBrightness
    property int colorDepth: di.colorDepth
    property int contrast: di.contrast
    property int dpiWidth: di.dpiWidth
    property int dpiHeight: di.dpiHeight
    property int physicalWidth: di.physicalWidth
    property int physicalHeight: di.physicalHeight
    property int orientation: di.orientation
    property int backlightStatus: di.backlightStatus
    property string backlightName: nameForBacklight(di.backlightStatus)

    function nameForBacklight(b) {
        switch (b) {
        case 0: return "Unknown";
        case 1: return "Off";
        case 2: return "Dimmed";
        case 3: return "On";
        }
        return "Code " + b;
    }

    DisplayInfo { id: di }
}
