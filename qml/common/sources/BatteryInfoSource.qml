/**
 * BatteryInfoSource.qml
 *
 * The standalone BatteryInfo QML element is documented but not actually
 * registered in the QtMobility.systeminfo plugin on this N9 (PR1.3).
 * Falling back to DeviceInfo's battery fields, which are confirmed to
 * work on-device.
 */

import QtQuick 1.1
import QtMobility.systeminfo 1.1

Item {
    id: source
    property string title: "Battery"
    property string subtitle: "Charge level and power state"
    property bool active: true

    property int batteryLevel: di.batteryLevel
    property string powerState: nameForPower(di.currentPowerState)

    function nameForPower(p) {
        switch (p) {
        case 0: return "Unknown";
        case 1: return "Battery";
        case 2: return "Wall (charging)";
        case 3: return "Wall (charged)";
        }
        return "Code " + p;
    }

    DeviceInfo {
        id: di
        monitorBatteryLevelChanges: source.active
        monitorPowerStateChanges: source.active
    }
}
