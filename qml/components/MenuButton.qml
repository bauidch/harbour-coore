import QtQuick 2.5
import Sailfish.Silica 1.0

BackgroundItem {
    id: menuButton
    property alias text: label.text
    property alias price: priceLabel.text
    property alias textAlignment: label.horizontalAlignment
    property int depth: 0
    readonly property color _color: enabled ? highlighted ? Theme.highlightColor : Theme.primaryColor : Theme.secondaryColor

    height: Theme.itemSizeSmall

    Rectangle {
        anchors.fill: parent
        gradient: Gradient {
            GradientStop {
                position: 0.0
                color: Theme.rgba(menuButton.palette.highlightBackgroundColor, 0.1)
            }
            GradientStop {
                position: 1.0
                color: "transparent"
            }
        }
    }

    Label {
        id: label
        anchors {
            left: parent.left
            verticalCenter: parent.verticalCenter
            leftMargin: Theme.horizontalPageMargin
            rightMargin: Theme.paddingMedium
        }
        horizontalAlignment: Text.AlignRight
        truncationMode: TruncationMode.Fade
        color: _color
    }

    Label {
        id: priceLabel
        anchors {
            left: label.left
            right: image.left
            verticalCenter: parent.verticalCenter
            leftMargin: Theme.horizontalPageMargin + depth * Theme.paddingLarge
            rightMargin: Theme.paddingMedium
        }
        horizontalAlignment: Text.AlignRight
        truncationMode: TruncationMode.Fade
        color:Theme.highlightColor
    }

    Image {
        id: image
        anchors {
            right: parent.right
            verticalCenter: parent.verticalCenter
            rightMargin: Theme.horizontalPageMargin
        }
        source: "image://theme/icon-m-right?" + _color
    }
}
