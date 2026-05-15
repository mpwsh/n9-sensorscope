/**
 * SourceDetailView.qml
 *
 * Loads sources/<sourceId>Source.qml via a Loader, then renders fields
 * specific to that source.
 *
 * Two notes on the patterns used here:
 *
 *   1. `src` falls back to an empty object `({})` when the loader has no
 *      item yet. That way `src.foo` evaluates to `undefined` instead of
 *      raising a TypeError, which keeps the log clean while the page is
 *      loading. The visible: bindings still gate the whole block so users
 *      don't see stale values from a previous source.
 *
 *   2. `visible:` uses helper functions that return real `bool` — not
 *      a `src && cond` expression, which can evaluate to `null` and trip
 *      QML's "cannot assign null to bool" guard.
 */

import QtQuick 1.1
import com.nokia.meego 1.0
import "../common"

Page {
    id: page
    property string sourceId: ""

    // The loaded source wrapper, or an empty placeholder. ALWAYS truthy.
    property variant src: loader.item ? loader.item : emptySrc
    QtObject { id: emptySrc }     // sentinel for "no item loaded"

    function isSource(id) { return loader.item !== null && sourceId === id; }
    function isAnySource(ids) {
        if (loader.item === null) return false;
        for (var i = 0; i < ids.length; ++i) if (sourceId === ids[i]) return true;
        return false;
    }

    Rectangle {
        anchors.fill: parent
        color: "#0a0a0a"
    }

    Loader {
        id: loader
        source: sourceId === ""
                ? ""
                : "../common/sources/" + sourceId + "Source.qml"
        onStatusChanged: {
            if (status === Loader.Error) {
                errorText.text = "Failed to load: " + sourceId;
            } else if (status === Loader.Ready) {
                errorText.text = "";
                // Start a "no data after 3 s" check for live sensors.
                noDataCheck.restart();
            }
        }
    }

    // Many N9 QtMobility sensor types exist but have no backing hardware
    // (gyroscope, light, proximity, tap). After 3 seconds with no samples,
    // we show a hint explaining the silence.
    Timer {
        id: noDataCheck
        interval: 3000
        repeat: false
        onTriggered: {
            // Tap is excluded: it only emits when the user actually taps the
            // device, so 0 samples doesn't mean the sensor is dead.
            if (sourceId === "Tap") return;
            if (loader.item !== null && loader.item.sampleCount !== undefined
                    && loader.item.sampleCount === 0) {
                noDataHint.visible = true;
            }
        }
    }

    Flickable {
        id: flick
        anchors.fill: parent
        contentHeight: content.height + 32
        clip: true

        Column {
            id: content
            x: 16
            y: 16
            width: parent.width - 32
            spacing: 4

            Text {
                text: src.title !== undefined ? src.title : sourceId
                font.pixelSize: 30
                font.bold: true
                color: "white"
            }
            Text {
                text: src.subtitle !== undefined ? src.subtitle : ""
                font.pixelSize: 16
                color: "#aaa"
                wrapMode: Text.WordWrap
                width: parent.width
            }
            Item { width: 1; height: 16 }
            Text {
                id: errorText
                color: "#e57373"
                font.pixelSize: 16
                visible: text !== ""
                wrapMode: Text.WordWrap
                width: parent.width
            }

            // No-data hint banner for sensors with no hardware backing.
            Rectangle {
                id: noDataHint
                visible: false
                width: parent.width
                height: hintText.height + 16
                color: "#2a1f10"
                border.color: "#7a5a25"
                border.width: 1
                radius: 4
                Text {
                    id: hintText
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.margins: 10
                    wrapMode: Text.WordWrap
                    color: "#e0c080"
                    font.pixelSize: 14
                    text: "No samples received. The QML sensor type exists, but "
                        + "this N9 may not have the backing hardware or plugin "
                        + "for it. The page is working — the sensor just isn't "
                        + "emitting readings."
                }
            }

            // --- Axis sensors: Accelerometer / Gyroscope / Magnetometer / Rotation
            Column {
                width: parent.width
                spacing: 4
                visible: isAnySource(["Accelerometer", "Gyroscope", "Magnetometer", "Rotation"])

                SectionHeader { title: "VALUES" }
                Stat {
                    label: "X"
                    value: src.xValue !== undefined ? src.xValue : 0
                    unit: unitForXYZ(sourceId)
                    digits: digitsForXYZ(sourceId)
                }
                Stat {
                    label: "Y"
                    value: src.yValue !== undefined ? src.yValue : 0
                    unit: unitForXYZ(sourceId)
                    digits: digitsForXYZ(sourceId)
                }
                Stat {
                    label: "Z"
                    value: src.zValue !== undefined ? src.zValue : 0
                    unit: unitForXYZ(sourceId)
                    digits: digitsForXYZ(sourceId)
                }
                Stat {
                    visible: isAnySource(["Accelerometer", "Magnetometer"])
                    label: "Magnitude"
                    value: src.magnitude !== undefined ? src.magnitude : 0
                    unit: unitForXYZ(sourceId)
                    digits: digitsForXYZ(sourceId)
                }
                Stat {
                    visible: isSource("Magnetometer")
                    label: "Calibration"
                    value: src.calibrationLevel !== undefined ? src.calibrationLevel * 100 : 0
                    unit: "%"; digits: 0
                }
            }

            // --- Compass
            Column {
                width: parent.width
                spacing: 4
                visible: isSource("Compass")
                SectionHeader { title: "VALUES" }
                Stat {
                    label: "Azimuth"
                    value: src.azimuth !== undefined ? src.azimuth : 0
                    unit: "°"; digits: 1
                }
                Stat {
                    label: "Calibration"
                    value: src.calibrationLevel !== undefined ? src.calibrationLevel * 100 : 0
                    unit: "%"; digits: 0
                }
            }

            // --- Orientation
            Column {
                width: parent.width
                spacing: 4
                visible: isSource("Orientation")
                SectionHeader { title: "VALUES" }
                Row2 {
                    label: "Orientation"
                    value: src.orientationName !== undefined
                           ? (src.orientationName + " (" + src.orientation + ")")
                           : "—"
                }
            }

            // --- AmbientLight
            Column {
                width: parent.width
                spacing: 4
                visible: isSource("AmbientLight")
                SectionHeader { title: "VALUES" }
                Row2 {
                    label: "Level"
                    value: src.levelName !== undefined
                           ? (src.levelName + " (" + src.level + ")")
                           : "—"
                }
            }

            // --- Light
            Column {
                width: parent.width
                spacing: 4
                visible: isSource("Light")
                SectionHeader { title: "VALUES" }
                Stat {
                    label: "Illuminance"
                    value: src.lux !== undefined ? src.lux : 0
                    unit: "lx"; digits: 1
                    tracking: src.hasReading === true
                }
                Row2 {
                    label: "Sensor reporting"
                    value: src.hasReading === true ? "yes" : "no data"
                }
            }

            // --- Proximity
            Column {
                width: parent.width
                spacing: 4
                visible: isSource("Proximity")
                SectionHeader { title: "VALUES" }
                Row2 {
                    label: "Object close"
                    value: src.isClose === true ? "CLOSE" : "far"
                    valueColor: src.isClose === true ? "#4fc3f7" : "white"
                }
                Row2 {
                    label: "Sensor reporting"
                    value: src.hasReading === true ? "yes" : "no data"
                }
            }

            // --- Tap
            Column {
                width: parent.width
                spacing: 4
                visible: isSource("Tap")
                SectionHeader { title: "VALUES" }
                Row2 {
                    label: "Total taps"
                    value: src.tapCount !== undefined ? src.tapCount + "" : "0"
                }
                Row2 {
                    label: "Last was double"
                    value: src.isDoubleTap === true ? "yes" : "no"
                }
                Row2 {
                    label: "Last direction"
                    value: src.directionName !== undefined ? src.directionName : "—"
                }
                Row2 {
                    label: "Last tap time"
                    value: (src.lastTapTime !== null && src.lastTapTime !== undefined)
                           ? Qt.formatDateTime(src.lastTapTime, "hh:mm:ss")
                           : "—"
                }
            }

            // --- Position
            Column {
                width: parent.width
                spacing: 4
                visible: isSource("Position")
                SectionHeader { title: "COORDINATES" }
                Row2 {
                    label: "Latitude"
                    value: src.latitudeValid === true
                           ? src.latitude.toFixed(7) + "°" : "—"
                }
                Row2 {
                    label: "Longitude"
                    value: src.longitudeValid === true
                           ? src.longitude.toFixed(7) + "°" : "—"
                }
                Row2 {
                    label: "Altitude"
                    value: src.altitudeValid === true
                           ? src.altitude.toFixed(1) + " m" : "—"
                }
                Row2 {
                    label: "Speed"
                    value: src.speedValid === true ? src.speed.toFixed(2) + " m/s" : "—"
                }

                Item { width: 1; height: 12 }
                SectionHeader { title: "ACCURACY" }
                Row2 {
                    label: "Horizontal"
                    value: src.horizontalAccuracyValid === true
                           ? src.horizontalAccuracy.toFixed(1) + " m" : "—"
                }
                Row2 {
                    label: "Vertical"
                    value: src.verticalAccuracyValid === true
                           ? src.verticalAccuracy.toFixed(1) + " m" : "—"
                }

                Item { width: 1; height: 12 }
                SectionHeader { title: "SOURCE" }
                Row2 {
                    label: "Positioning method"
                    value: src.positioningMethodName !== undefined
                           ? src.positioningMethodName : "—"
                }

                Item { width: 1; height: 12 }
                SectionHeader { title: "TIMING" }
                Row2 {
                    label: "Fix timestamp"
                    value: (src.timestamp !== null && src.timestamp !== undefined)
                           ? Qt.formatDateTime(src.timestamp, "yyyy-MM-dd hh:mm:ss")
                           : "—"
                }
            }

            // --- DeviceInfo
            Column {
                width: parent.width
                spacing: 4
                visible: isSource("DeviceInfo")
                SectionHeader { title: "HARDWARE" }
                Row2 { label: "Manufacturer"; value: src.manufacturer ? src.manufacturer : "—" }
                Row2 { label: "Model";        value: src.model ? src.model : "—" }
                Row2 { label: "Product";      value: src.productName ? src.productName : "—" }

                Item { width: 1; height: 12 }
                SectionHeader { title: "STATE" }
                Row2 { label: "Current profile"; value: src.profileName !== undefined ? src.profileName : "—" }
                Row2 { label: "Thermal state";   value: src.thermalName !== undefined ? src.thermalName : "—" }
            }

            // --- BatteryInfo
            Column {
                width: parent.width
                spacing: 4
                visible: isSource("BatteryInfo")
                SectionHeader { title: "POWER" }
                Stat {
                    label: "Charge"
                    value: src.batteryLevel !== undefined ? src.batteryLevel : 0
                    unit: "%"; digits: 0
                }
                Row2 {
                    label: "Power state"
                    value: src.powerState !== undefined ? src.powerState : "—"
                }
            }

            // --- NetworkInfo
            Column {
                width: parent.width
                spacing: 4
                visible: isSource("NetworkInfo")
                SectionHeader { title: "CELLULAR (GSM)" }
                Row2 { label: "Status";   value: src.status ? src.status : "—" }
                Stat {
                    label: "Signal"
                    value: src.signalStrength !== undefined ? src.signalStrength : 0
                    unit: "%"; digits: 0
                }
                Row2 { label: "Operator"; value: src.operatorName ? src.operatorName : "—" }
                Row2 { label: "MCC";      value: src.countryCode ? src.countryCode : "—" }
                Row2 { label: "MNC";      value: src.networkCode ? src.networkCode : "—" }
                Row2 { label: "MAC";      value: src.macAddress ? src.macAddress : "—" }
            }

            // --- GeneralInfo
            Column {
                width: parent.width
                spacing: 4
                visible: isSource("GeneralInfo")
                SectionHeader { title: "LOCALE" }
                Row2 { label: "Language"; value: src.language ? src.language : "—" }
                Row2 { label: "Country";  value: src.countryCode ? src.countryCode : "—" }
            }

            // --- DisplayInfo
            Column {
                width: parent.width
                spacing: 4
                visible: isSource("DisplayInfo")
                SectionHeader { title: "SCREEN" }
                Stat {
                    label: "Brightness"
                    value: src.brightness !== undefined ? src.brightness : 0
                    unit: ""; digits: 0
                }
                Row2 { label: "Color depth"; value: src.colorDepth !== undefined ? src.colorDepth + " bpp" : "—" }
                Row2 { label: "Contrast";    value: src.contrast !== undefined ? src.contrast + "" : "—" }
                Row2 { label: "Backlight";   value: src.backlightName !== undefined ? src.backlightName : "—" }

                Item { width: 1; height: 12 }
                SectionHeader { title: "RESOLUTION" }
                Row2 { label: "DPI width";    value: src.dpiWidth !== undefined ? src.dpiWidth + " dpi" : "—" }
                Row2 { label: "DPI height";   value: src.dpiHeight !== undefined ? src.dpiHeight + " dpi" : "—" }
                Row2 { label: "Physical W";   value: src.physicalWidth !== undefined ? src.physicalWidth + " mm" : "—" }
                Row2 { label: "Physical H";   value: src.physicalHeight !== undefined ? src.physicalHeight + " mm" : "—" }
            }

            // --- StorageInfo
            Column {
                width: parent.width
                spacing: 4
                visible: isSource("StorageInfo")
                SectionHeader { title: "VOLUME 1" }
                Row2 { label: "Path";      value: src.volume1Path ? src.volume1Path : "—" }
                Row2 { label: "Type";      value: src.volume1Path ? src.volume1Type : "—" }
                Row2 {
                    label: "Total"
                    value: src.volume1Path ? src.volume1TotalMB.toFixed(0) + " MB" : "—"
                }
                Row2 {
                    label: "Available"
                    value: src.volume1Path ? src.volume1AvailMB.toFixed(0) + " MB" : "—"
                }

                Item { width: 1; height: 12 }
                SectionHeader { title: "VOLUME 2" }
                Row2 { label: "Path";      value: src.volume2Path ? src.volume2Path : "—" }
                Row2 { label: "Type";      value: src.volume2Path ? src.volume2Type : "—" }
                Row2 {
                    label: "Total"
                    value: src.volume2Path ? src.volume2TotalMB.toFixed(0) + " MB" : "—"
                }
                Row2 {
                    label: "Available"
                    value: src.volume2Path ? src.volume2AvailMB.toFixed(0) + " MB" : "—"
                }
            }

            // --- Sample counter footer for live sources
            Column {
                width: parent.width
                spacing: 4
                visible: src.sampleCount !== undefined
                Item { width: 1; height: 16 }
                SectionHeader { title: "STATS" }
                Row2 {
                    label: "Samples this session"
                    value: src.sampleCount !== undefined ? src.sampleCount + "" : "0"
                }
            }
        }
    }

    function unitForXYZ(id) {
        if (id === "Accelerometer") return "m/s²";
        if (id === "Gyroscope")     return "°/s";
        if (id === "Magnetometer")  return "T";
        if (id === "Rotation")      return "°";
        return "";
    }
    function digitsForXYZ(id) {
        return id === "Magnetometer" ? 6 : 2;
    }

    tools: ToolBarLayout {
        ToolIcon {
            iconId: "toolbar-back"
            onClicked: pageStack.pop()
        }
    }
}
