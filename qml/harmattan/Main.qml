/**
 * SensorScope - Main.qml
 *
 * Sets up the PageStack and pushes the source list as the root page.
 */

import QtQuick 1.1
import com.nokia.meego 1.0

Window {
    id: window

    PageStack {
        id: pageStack
        anchors {
            top: statusBar.bottom
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }
        toolBar: toolBar

        Component.onCompleted: {
            pageStack.push(Qt.resolvedUrl("SourceListView.qml"));
        }
    }

    StatusBar {
        id: statusBar
        anchors.top: parent.top
    }

    ToolBar {
        id: toolBar
        anchors {
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }
    }
}
