import QtQuick 1.1
import QtMobility.sensors 1.2

Item {
    id: source
    property string title: "Rotation"
    property string subtitle: "Pitch / roll / yaw from sensor fusion (°)"
    property bool active: true

    property real xValue: 0    // pitch
    property real yValue: 0    // roll
    property real zValue: 0    // yaw
    property int sampleCount: 0

    RotationSensor {
        active: source.active
        onReadingChanged: {
            source.xValue = reading.x;
            source.yValue = reading.y;
            source.zValue = reading.z;
            source.sampleCount += 1;
        }
    }
}
