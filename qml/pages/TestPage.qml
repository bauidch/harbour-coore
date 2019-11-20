import QtQuick 2.0
import Sailfish.Silica 1.0

import "../js/locations.js" as Locations

Page {
    id: testPage

   SilicaFlickable {
        id: pageFlickable
        anchors.fill: parent
        contentHeight: column.height

        Column {
            id: column
            width: testPage.width
            spacing: Theme.paddingLarge

            PageHeader {
                title: qsTr("About")
            }

            Button {
                 text: "Test"
                 anchors {
                      horizontalCenter: parent.horizontalCenter
                 }
                 onClicked: Locations.getLocation()
            }
            Label {
                text: Locations.getLocationLength()
                color: Theme.highlightColor
                font.pixelSize: Theme.fontSizeMedium
                anchors {
                        horizontalCenter: parent.horizontalCenter
                 }
            }

        }
    }
    VerticalScrollDecorator { flickable: pageFlickable }
}
