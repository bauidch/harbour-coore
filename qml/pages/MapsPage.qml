import QtQuick 2.5
import Sailfish.Silica 1.0
import QtLocation 5.0
import QtPositioning 5.0
import QtGraphicalEffects 1.0
import "../components"
import "../js/locations.js" as Locations
import ".."

Page {

    id: mapPage

    property var model
    property var positionSource
    //property alias name : mapPage.title
    property alias map : map

    PageHeader {
        id: header
        y: 0
        title: "Maps"
        width: parent.width
        z: 5
    }

    Rectangle {
        id: rectangle
        anchors.fill: header
        color: Theme.highlightDimmerColor
        opacity: 0.6
        z: 4
    }

    ViewPlaceholder {
        id: errorLocations
        text: qsTr("No Locations")
        hintText: qsTr("no connection or no locations available")
        enabled: mapPage.model = 0
    }

    property var currentPosition: MapQuickItem {
        id: currentPosition

        coordinate: QtPositioning.coordinate(8, 47)

        anchorPoint.x: currentPosImage.width / 2
        anchorPoint.y: currentPosImage.height / 2

        sourceItem: IconButton {
            id: currentPosImage
            icon.scale: 1
            icon.source: "image://theme/icon-cover-location"
            icon.color: Theme.ownLocationColor
        }
    }

    FastBlur {
        anchors.fill: header
        source: ShaderEffectSource {
            sourceItem: map
            sourceRect: Qt.rect(0, 0, header.width, header.height)
        }

        radius: 40
        transparentBorder: true
        z: 3
    }

    Map {
        id: map
        anchors.fill: parent
        // Work around QTBUG-47366;
        // remove once SFOS is on QtLocation > 5.6
        property bool dirty: false

        gesture {
            enabled: true
        }

        // Work around QTBUG-47366;
        // remove once SFOS is on QtLocation > 5.6
        function repopulateMap() {
            // triggers a map repopulation
            mapItemView.model = 'undefined';
            mapItemView.model = mapPage.model;
            map.dirty = false;
        }

        // Work around QTBUG-47366;
        // remove once SFOS is on QtLocation > 5.6
        Connections {
            target: mapItemView.model
            onRowsRemoved: map.dirty = true
        }

        MapItemView {
            id: mapItemView
            model: mapPage.model

            delegate: MapQuickItem {

                anchorPoint.x: markerImage.width / 2
                anchorPoint.y: markerImage.height

                coordinate: QtPositioning.coordinate(model.latCoord, model.longCoord)

                sourceItem: IconButton {
                    id: markerImage
                    icon.scale: 1
                    icon.source:  "image://theme/icon-m-location"
                    anchors.verticalCenter: parent.verticalCenter

                    onClicked: {
                        pageStack.push(Qt.resolvedUrl("LocationmapPage.qml"),
                                       {
                                           locationTitle: mapItemView.model.item(index),
                                           locationID: mapItemView.model.id,
                                       });
                    }
                }
            }
        }
        Component.onCompleted: {
            addMapItem(currentPosition);
            if (map.dirty) map.repopulateMap()
            centerAndZoom()
        }

        function centerAndZoom(){
            center = currentPosition.coordinate;
            zoomLevel = maximumZoomLevel - (9);
        }

        IconButton {
            // SFOS map has no 'userPositionAvailable'
            enabled: positionSource.position.coordinate.isValid

            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.rightMargin: Theme.paddingLarge
            anchors.bottomMargin: Theme.paddingLarge

            onClicked: map.centerAndZoom()

            z: 6
            icon.color: Theme.highlightBackgroundColor
            opacity: 0.75
            icon.source: "image://theme/icon-cover-location"
        }
    }
}