import QtQuick 2.5
import Sailfish.Silica 1.0

ListItem {
    id: delegate
    property alias locationText: locationLabel.text
    property alias addressText: placeLabel.text

    contentHeight: placeLabel.y + placeLabel.height + placeLabel.anchors.bottomMargin

    Label {
        id: locationLabel
        //color: Theme.secondaryColor

        width: Math.min(locationLabel.contentWidth,
                        // space that is left after substracting all the other elements from the available width
                        delegate.width
                        - (locationLabel.anchors.leftMargin))

        font.pixelSize: Theme.fontSizeMedium
        truncationMode: TruncationMode.Fade
        textFormat: Text.StyledText
        anchors {
            top: parent.top
            left: parent.left

            topMargin: Theme.paddingMedium
            leftMargin: Theme.horizontalPageMargin
        }
    }

    Label {
        id: placeLabel

        font.pixelSize: Theme.fontSizeExtraSmall
        color: Theme.secondaryColor

        truncationMode: TruncationMode.Fade
        anchors {
            left: parent.left

            top: locationLabel.bottom
            leftMargin: Theme.horizontalPageMargin
            rightMargin: Theme.horizontalPageMargin

            topMargin: Theme.paddingSmall
            bottomMargin: locationLabel.anchors.topMargin
        }
    }
}
