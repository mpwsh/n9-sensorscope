/**
 * SectionHeader.qml - small uppercase divider between groups of rows.
 */

import QtQuick 1.1

Item {
    id: header
    property string title: ""

    width: parent ? parent.width : 0
    height: titleText.height + 12

    Text {
        id: titleText
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        text: header.title
        font.pixelSize: 16
        font.bold: true
        font.letterSpacing: 2
        color: "#4fc3f7"
    }

    Rectangle {
        anchors.left: titleText.right
        anchors.leftMargin: 12
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        height: 1
        color: "#333333"
    }
}
