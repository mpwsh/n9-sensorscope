import QtQuick 1.1
import QtMobility.sensors 1.2

Item {
    id: source
    property string title: "Gyroscope"
    property string subtitle: "Angular velocity around each axis (°/s)"
    property bool active: true

    property real xValue: 0
    property real yValue: 0
    property real zValue: 0
    property int sampleCount: 0

    Gyroscope {
        active: source.active
        onReadingChanged: {
            source.xValue = reading.x;
            source.yValue = reading.y;
            source.zValue = reading.z;
            source.sampleCount += 1;
        }
    }
}
