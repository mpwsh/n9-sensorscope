/**
 * Stat.qml - a numeric field row that also remembers min/max over the session.
 *
 * Usage:
 *   Stat { label: "X"; value: source.x; unit: "m/s²" }
 *
 * Bind `value` to a live numeric property; min/max update automatically.
 * Set `tracking: false` to freeze min/max (useful for static fields).
 */

import QtQuick 1.1

Item {
    id: stat
    property string label: ""
    property real value: 0
    property string unit: ""
    property int digits: 2
    property bool tracking: true

    property real minValue: Number.POSITIVE_INFINITY
    property real maxValue: Number.NEGATIVE_INFINITY
    property bool hasSample: false

    function reset() {
        minValue = Number.POSITIVE_INFINITY;
        maxValue = Number.NEGATIVE_INFINITY;
        hasSample = false;
    }

    onValueChanged: {
        if (!tracking) return;
        if (typeof value !== "number" || isNaN(value)) return;
        if (!hasSample || value < minValue) minValue = value;
        if (!hasSample || value > maxValue) maxValue = value;
        hasSample = true;
    }

    width: parent ? parent.width : 0
    height: column.height + 6

    Column {
        id: column
        width: parent.width
        spacing: 2

        Item {
            width: parent.width
            height: Math.max(labelText.height, valueText.height) + 2

            Text {
                id: labelText
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                text: stat.label
                font.pixelSize: 20
                color: "#cccccc"
            }
            Text {
                id: valueText
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                text: stat.value.toFixed(stat.digits) + (stat.unit ? " " + stat.unit : "")
                font.pixelSize: 20
                color: "white"
            }
        }

        Text {
            anchors.right: parent.right
            text: hasSample
                  ? "min " + minValue.toFixed(digits) + "  ·  max " + maxValue.toFixed(digits)
                  : ""
            font.pixelSize: 13
            color: "#777"
            visible: stat.tracking && hasSample
        }
    }
}
