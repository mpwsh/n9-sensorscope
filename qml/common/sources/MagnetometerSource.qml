import QtQuick 1.1
import QtMobility.sensors 1.2

Item {
    id: source
    property string title: "Magnetometer"
    property string subtitle: "Raw magnetic field, 3-axis"
    property bool active: true

    property real xValue: 0
    property real yValue: 0
    property real zValue: 0
    property real magnitude: 0
    property real calibrationLevel: 0
    property int sampleCount: 0

    Magnetometer {
        active: source.active
        onReadingChanged: {
            source.xValue = reading.x;
            source.yValue = reading.y;
            source.zValue = reading.z;
            source.magnitude = Math.sqrt(reading.x * reading.x
                                       + reading.y * reading.y
                                       + reading.z * reading.z);
            if (reading.calibrationLevel !== undefined)
                source.calibrationLevel = reading.calibrationLevel;
            source.sampleCount += 1;
        }
    }
}
