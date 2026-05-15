/**
 * AccelerometerSource.qml
 *
 * Note: Item already has x, y as FINAL properties (position). We use
 * xValue/yValue/zValue here, and similarly in Gyroscope/Magnetometer/Rotation.
 */

import QtQuick 1.1
import QtMobility.sensors 1.2

Item {
    id: source

    property string title: "Accelerometer"
    property string subtitle: "Linear acceleration including gravity"
    property bool active: true

    property real xValue: 0
    property real yValue: 0
    property real zValue: 0
    property real magnitude: 0
    property variant timestamp: null
    property int sampleCount: 0

    Accelerometer {
        active: source.active
        onReadingChanged: {
            source.xValue = reading.x;
            source.yValue = reading.y;
            source.zValue = reading.z;
            source.magnitude = Math.sqrt(reading.x * reading.x
                                       + reading.y * reading.y
                                       + reading.z * reading.z);
            source.timestamp = new Date();
            source.sampleCount += 1;
        }
    }
}
