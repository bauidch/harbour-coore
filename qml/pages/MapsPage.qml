import QtQuick 2.0
import Sailfish.Silica 1.0
import QtLocation 5.0
import QtPositioning 5.0
import QtGraphicalEffects 1.0
Page {

    id: mapPAge

    property var model
    property var positionSource
    property alias name : page.title
    property alias map : map

    PageHeader {
        id: header
        y: 0
        title: name
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

    property var currentPosition: MapQuickItem {
        id: currentPosition

        coordinate: positionSource.position.coordinate

        anchorPoint.x: currentPosImage.width / 2
        anchorPoint.y: currentPosImage.height / 2

        sourceItem: IconButton {
            id: currentPosImage
            type: "cover-location"
            color: Theme.ownLocationColor
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

    onActivated: if (map.dirty) map.repopulateMap()

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
            mapItemView.model = page.model;
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
            model: page.model

            delegate: MapQuickItem {

                anchorPoint.x: MarkerImage.width / 2
                anchorPoint.y: MarkerImage.height

                coordinate: QtPositioning.coordinate(model.latCoord, model.longCoord)

                sourceItem: IconButton {
                    id: MarkerImage
                    type: "location"

                    color:
                    verticalAlignment: Text.AlignBottom

                    onClicked: {
                        pageStack.push(Qt.resolvedUrl("LocationPage.qml"),
                                       {
                                           locationTitle: mapItemView.model.item(index),
                                           locationID: model.id,
                                       });
                    }
                }
            }
        }
    }
}
