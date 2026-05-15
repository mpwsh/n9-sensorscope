/**
 * PositionSource.qml
 *
 * Wraps QtMobility.location's PositionSource. The PositionSource element's
 * positioning-method property is `positioningMethod` (not `sourceType`).
 * The Position element exposes explicit valid flags per field.
 */

import QtQuick 1.1
import QtMobility.location 1.2

Item {
    id: source
    property string title: "Position"
    property string subtitle: "Fused location via QGeoPositionInfoSource"
    property bool active: true

    property real latitude: 0
    property real longitude: 0
    property bool latitudeValid: false
    property bool longitudeValid: false
    property real altitude: 0
    property bool altitudeValid: false
    property real horizontalAccuracy: 0
    property bool horizontalAccuracyValid: false
    property real verticalAccuracy: 0
    property bool verticalAccuracyValid: false
    property real speed: 0
    property bool speedValid: false
    property variant timestamp: null
    property int positioningMethod: 0
    property string positioningMethodName: "Unknown"
    property int sampleCount: 0

    function methodName(m) {
        // From PositionSource.PositioningMethod enum
        if (m === PositionSource.SatellitePositioningMethod)    return "Satellite (GPS)";
        if (m === PositionSource.NonSatellitePositioningMethod) return "Non-satellite (cell/Wi-Fi)";
        if (m === PositionSource.AllPositioningMethods)         return "All / fused";
        if (m === PositionSource.NoPositioningMethod)           return "None available";
        return "Code " + m;
    }

    PositionSource {
        id: positionSource
        active: source.active
        updateInterval: 2000

        onPositionChanged: {
            // Coordinate fields
            if (position.coordinate) {
                if (position.coordinate.latitude !== undefined)
                    source.latitude = position.coordinate.latitude;
                if (position.coordinate.longitude !== undefined)
                    source.longitude = position.coordinate.longitude;
                if (position.coordinate.altitude !== undefined)
                    source.altitude = position.coordinate.altitude;
            }

            // Explicit valid flags
            source.latitudeValid             = position.latitudeValid === true;
            source.longitudeValid            = position.longitudeValid === true;
            source.altitudeValid             = position.altitudeValid === true;
            source.horizontalAccuracyValid   = position.horizontalAccuracyValid === true;
            source.verticalAccuracyValid     = position.verticalAccuracyValid === true;
            source.speedValid                = position.speedValid === true;

            if (position.horizontalAccuracy !== undefined)
                source.horizontalAccuracy = position.horizontalAccuracy;
            if (position.verticalAccuracy !== undefined)
                source.verticalAccuracy = position.verticalAccuracy;
            if (position.speed !== undefined)
                source.speed = position.speed;
            if (position.timestamp !== undefined)
                source.timestamp = position.timestamp;

            source.sampleCount += 1;
        }
    }

    Component.onCompleted: {
        var m = positionSource.positioningMethod;
        if (m !== undefined) {
            source.positioningMethod = m;
            source.positioningMethodName = methodName(m);
        }
    }
}
