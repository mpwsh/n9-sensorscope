import QtQuick 1.1
import QtMobility.sensors 1.2

Item {
    id: source
    property string title: "Ambient Light"
    property string subtitle: "Discrete light level category"
    property bool active: true

    property int level: 0
    property string levelName: "Unknown"
    property int sampleCount: 0

    function nameFor(l) {
        // AmbientLightReading enum
        switch (l) {
        case 0: return "Undefined";
        case 1: return "Dark";
        case 2: return "Twilight";
        case 3: return "Light";
        case 4: return "Bright";
        case 5: return "Sunny";
        }
        return "Unknown (" + l + ")";
    }

    AmbientLightSensor {
        active: source.active
        onReadingChanged: {
            source.level = reading.lightLevel;
            source.levelName = source.nameFor(reading.lightLevel);
            source.sampleCount += 1;
        }
    }
}
