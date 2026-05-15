/**
 * SourceListView.qml
 *
 * The scrolling catalog of every available data source. Tap one to push
 * a SourceDetailView for it.
 */

import QtQuick 1.1
import com.nokia.meego 1.0
import "../common"

Page {
    id: page

    SourceRegistry { id: registry }

    Rectangle {
        anchors.fill: parent
        color: "#0a0a0a"
    }

    ListView {
        id: list
        anchors.fill: parent
        anchors.margins: 0
        clip: true
        spacing: 0

        model: registry.sources
        header: headerComponent
        delegate: rowDelegate
        section.property: "category"
        section.delegate: sectionDelegate
    }

    // --- Delegates ---------------------------------------------------------

    Component {
        id: headerComponent
        Item {
            width: list.width
            height: 80
            Column {
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                anchors.margins: 16
                spacing: 2
                Text {
                    text: "SensorScope"
                    font.pixelSize: 28
                    font.bold: true
                    color: "white"
                }
                Text {
                    text: "Tap a data source to inspect"
                    font.pixelSize: 16
                    color: "#888"
                }
            }
        }
    }

    Component {
        id: sectionDelegate
        Item {
            width: list.width
            height: 36
            Rectangle {
                anchors.fill: parent
                color: "#111"
            }
            Text {
                anchors.left: parent.left
                anchors.leftMargin: 16
                anchors.verticalCenter: parent.verticalCenter
                text: {
                    if (section === "sensor") return "SENSORS";
                    if (section === "systeminfo") return "SYSTEM INFO";
                    if (section === "location") return "LOCATION";
                    return section.toUpperCase();
                }
                font.pixelSize: 14
                font.bold: true
                font.letterSpacing: 2
                color: "#4fc3f7"
            }
        }
    }

    Component {
        id: rowDelegate
        Item {
            id: rowItem
            width: list.width
            height: 76

            Rectangle {
                anchors.fill: parent
                color: tapArea.pressed ? "#1a1a1a" : "transparent"
            }

            Column {
                anchors.left: parent.left
                anchors.right: chevron.left
                anchors.verticalCenter: parent.verticalCenter
                anchors.leftMargin: 16
                anchors.rightMargin: 8
                spacing: 2
                Text {
                    text: modelData.name
                    font.pixelSize: 20
                    color: "white"
                }
                Text {
                    text: modelData.blurb
                    font.pixelSize: 14
                    color: "#888"
                    elide: Text.ElideRight
                    width: parent.width
                }
            }

            Text {
                id: chevron
                anchors.right: parent.right
                anchors.rightMargin: 16
                anchors.verticalCenter: parent.verticalCenter
                text: "›"
                font.pixelSize: 30
                color: "#555"
            }

            Rectangle {
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                height: 1
                color: "#1a1a1a"
            }

            MouseArea {
                id: tapArea
                anchors.fill: parent
                onClicked: {
                    pageStack.push(Qt.resolvedUrl("SourceDetailView.qml"),
                                   { sourceId: modelData.id });
                }
            }
        }
    }
}
