import QtQuick 1.1
import QtMobility.sensors 1.2

Item {
    id: source
    property string title: "Tilt"
    property string subtitle: "Tilt around X (front-back) and Y (left-right) axes"
    property bool active: true

    property real xRotation: 0
    property real yRotation: 0
    property int sampleCount: 0

    TiltSensor {
        active: source.active
        onReadingChanged: {
            source.xRotation = reading.xRotation;
            source.yRotation = reading.yRotation;
            source.sampleCount += 1;
        }
    }
}
