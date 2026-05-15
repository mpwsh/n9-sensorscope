/**
 * Row2.qml - label/value row, sans-serif label on left, value on right.
 */

import QtQuick 1.1

Item {
    id: row
    property string label: ""
    property string value: ""
    property color valueColor: "white"

    width: parent ? parent.width : 0
    height: Math.max(labelText.height, valueText.height) + 4

    Text {
        id: labelText
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        text: row.label
        font.pixelSize: 20
        color: "#cccccc"
    }

    Text {
        id: valueText
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        text: row.value
        font.pixelSize: 20
        color: row.valueColor
        horizontalAlignment: Text.AlignRight
        elide: Text.ElideMiddle
        width: parent.width - labelText.width - 12
    }
}
