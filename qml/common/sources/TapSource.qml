/**
 * TapSource.qml
 *
 * TapReading exposes `doubleTap` and `tapDirection`. The Tap plugin may
 * not be active on the N9 — that's a hardware/plugin question, not a
 * code one. The wrapper itself is valid.
 */

import QtQuick 1.1
import QtMobility.sensors 1.2

Item {
    id: source
    property string title: "Tap"
    property string subtitle: "Tap detection (via accelerometer)"
    property bool active: true

    property bool isDoubleTap: false
    property int tapDirection: 0
    property string directionName: "—"
    property int tapCount: 0
    property variant lastTapTime: null
    property int sampleCount: 0

    function nameForDirection(d) {
        // TapDirection flag values (lowest 6 bits = ±X, ±Y, ±Z axes)
        if (d === 0) return "—";
        var parts = [];
        if (d & 0x0001) parts.push("X+");
        if (d & 0x0002) parts.push("X-");
        if (d & 0x0004) parts.push("Y+");
        if (d & 0x0008) parts.push("Y-");
        if (d & 0x0010) parts.push("Z+");
        if (d & 0x0020) parts.push("Z-");
        return parts.length ? parts.join(" ") : ("Code " + d);
    }

    TapSensor {
        active: source.active
        onReadingChanged: {
            source.isDoubleTap = reading.doubleTap === true;
            if (reading.tapDirection !== undefined) {
                source.tapDirection = reading.tapDirection;
                source.directionName = source.nameForDirection(reading.tapDirection);
            }
            source.tapCount += 1;
            source.lastTapTime = new Date();
            source.sampleCount += 1;
        }
    }
}
