/**
 * DeviceInfoSource.qml
 *
 * Hardware ID + a few useful runtime states.
 * IMEI/IMSI omitted (require ReadDeviceData capability).
 */

import QtQuick 1.1
import QtMobility.systeminfo 1.1

Item {
    id: source
    property string title: "Device Info"
    property string subtitle: "Hardware identification and runtime state"
    property bool active: true

    property string manufacturer: di.manufacturer
    property string model: di.model
    property string productName: di.productName

    property int currentProfile: di.currentProfile
    property string profileName: nameForProfile(di.currentProfile)
    property int thermalState: di.currentThermalState
    property string thermalName: nameForThermal(di.currentThermalState)

    function nameForProfile(p) {
        switch (p) {
        case 0: return "Unknown";
        case 1: return "Silent";
        case 2: return "Normal";
        case 3: return "Loud";
        case 4: return "Vibration";
        case 5: return "Offline";
        case 6: return "Power save";
        case 7: return "Custom";
        case 8: return "Beep";
        case 9: return "Meeting";
        }
        return "Code " + p;
    }
    function nameForThermal(t) {
        switch (t) {
        case 0: return "Unknown";
        case 1: return "Normal";
        case 2: return "Warning";
        case 3: return "Alert";
        case 4: return "Error";
        }
        return "Code " + t;
    }

    DeviceInfo {
        id: di
        monitorCurrentProfileChanges: source.active
        monitorThermalStateChanges: source.active
    }
}
