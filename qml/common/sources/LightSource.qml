import QtQuick 1.1
import QtMobility.sensors 1.2

Item {
    id: source
    property string title: "Light"
    property string subtitle: "Continuous illuminance"
    property bool active: true

    property real lux: 0
    property bool hasReading: false
    property int sampleCount: 0

    LightSensor {
        active: source.active
        onReadingChanged: {
            // LightReading property is `lux`, not `illuminance`.
            var v = reading.lux;
            if (v !== undefined && v !== null && !isNaN(v)) {
                source.lux = v;
                source.hasReading = true;
            }
            source.sampleCount += 1;
        }
    }
}
