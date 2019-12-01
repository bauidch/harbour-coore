import QtQuick 2.0
import Sailfish.Silica 1.0
import "../js/locations.js" as Locations

Page {
    id: oneFood

    property string foodTitle
    property string locationTitle
    property double foodPrice
    property string locationID
    property variant locationInfos

    SilicaFlickable {
        anchors.fill: parent
        contentHeight: column.height


        Column {
            id: column

            width: oneFood.width
            spacing: Theme.paddingLarge
            PageHeader {
                title: oneFood.locationTitle
            }

            Row {
                id: titleMenu
                spacing: Theme.paddingLarge
                anchors.horizontalCenter: parent.horizontalCenter

                Label {
                    x: Theme.paddingLarge
                    id: mainLabel
                    text: oneFood.foodTitle
                    wrapMode: Text.Wrap
                    color: Theme.secondaryHighlightColor
                    font.pixelSize: Theme.fontSizeExtraLarge
                }
                Label {
                    x: Theme.paddingLarge
                    id: priceLabel
                    text: oneFood.foodPrice
                    wrapMode: Text.Wrap
                    color: Theme.primaryColor
                    font.pixelSize: Theme.fontSizeExtraLarge
                }
            }

            Repeater {
                model: [
                    Locations.get_one_menu(oneFood.locationID, oneFood.foodTitle)
                ]
                    Label {
                        text: modelData
                        color: Theme.primaryColor
                        font.pixelSize: Theme.fontSizeMedium
                        wrapMode: Text.Wrap
                        width: parent.width
                        x: Theme.paddingLarge
                    }
           }
            Label {
                   id: footerText
                   color: Theme.secondaryHighlightColor
                   x: Theme.paddingLarge
            }

        }
    }
    Component.onCompleted: {
        oneFood.locationInfos =  Locations.get_one_location(oneFood.locationID)
        footerText.text =  qsTr("Coop Restaurant ") + oneFood.locationInfos[0].city
    }
}
