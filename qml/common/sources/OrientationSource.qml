import QtQuick 1.1
import QtMobility.sensors 1.2

Item {
    id: source
    property string title: "Orientation"
    property string subtitle: "Discrete face direction (TopUp, LeftUp, FaceUp, …)"
    property bool active: true

    property int orientation: 0
    property string orientationName: "Unknown"
    property int sampleCount: 0

    function nameFor(o) {
        // OrientationReading enum values from QtMobility.sensors 1.2
        switch (o) {
        case 0: return "Undefined";
        case 1: return "TopUp";
        case 2: return "TopDown";
        case 3: return "LeftUp";
        case 4: return "RightUp";
        case 5: return "FaceUp";
        case 6: return "FaceDown";
        }
        return "Unknown (" + o + ")";
    }

    OrientationSensor {
        active: source.active
        onReadingChanged: {
            source.orientation = reading.orientation;
            source.orientationName = source.nameFor(reading.orientation);
            source.sampleCount += 1;
        }
    }
}
