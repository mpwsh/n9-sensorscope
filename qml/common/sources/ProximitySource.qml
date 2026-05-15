import QtQuick 1.1
import QtMobility.sensors 1.2

Item {
    id: source
    property string title: "Proximity"
    property string subtitle: "Near/far boolean (the in-call screen-off sensor)"
    property bool active: true

    property bool isClose: false
    property bool hasReading: false
    property int sampleCount: 0

    ProximitySensor {
        active: source.active
        onReadingChanged: {
            // ProximityReading property is `close`, not `near`.
            var v = reading.close;
            if (v !== undefined && v !== null) {
                source.isClose = v;
                source.hasReading = true;
            }
            source.sampleCount += 1;
        }
    }
}
