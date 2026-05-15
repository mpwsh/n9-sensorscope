/**
 * NetworkInfoSource.qml
 *
 * networkStatus is a string per docs. Monitor properties exist as
 * monitorNameChanges, monitorSignalStrengthChanges, monitorStatusChanges,
 * monitorModeChanges (with the *Changes suffix). cellId / LAC are not
 * exposed by the QML element; the monitoring*Changes booleans are.
 */

import QtQuick 1.1
import QtMobility.systeminfo 1.1

Item {
    id: source
    property string title: "Network"
    property string subtitle: "Cellular signal, operator, status"
    property bool active: true

    property int signalStrength: ni.networkSignalStrength
    property string operatorName: ni.networkName
    property string countryCode: ni.currentMobileCountryCode
    property string networkCode: ni.currentMobileNetworkCode
    property string status: ni.networkStatus
    property string macAddress: ni.macAddress

    NetworkInfo {
        id: ni
        mode: NetworkInfo.GsmMode
        monitorNameChanges: source.active
        monitorSignalStrengthChanges: source.active
        monitorStatusChanges: source.active
        monitorModeChanges: source.active
        monitorCurrentMobileNetworkCodeChanges: source.active
    }
}
