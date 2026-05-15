import QtQuick 1.1
import QtMobility.sensors 1.2

Item {
    id: source
    property string title: "IR Proximity"
    property string subtitle: "Analog IR reflectance (0 = nothing, 1 = touching)"
    property bool active: true

    property real reflectance: 0
    property int sampleCount: 0

    IRProximitySensor {
        active: source.active
        onReadingChanged: {
            source.reflectance = reading.reflectance;
            source.sampleCount += 1;
        }
    }
}
