import QtQuick 1.1
import QtMobility.sensors 1.2

Item {
    id: source
    property string title: "Compass"
    property string subtitle: "Magnetic heading from sensor fusion"
    property bool active: true

    property real azimuth: 0
    property real calibrationLevel: 0
    property int sampleCount: 0

    Compass {
        active: source.active
        onReadingChanged: {
            source.azimuth = reading.azimuth;
            source.calibrationLevel = reading.calibrationLevel;
            source.sampleCount += 1;
        }
    }
}
