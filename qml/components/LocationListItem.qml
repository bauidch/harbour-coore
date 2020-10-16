import QtQuick 2.0
import Sailfish.Silica 1.0

ListItem {
    id: delegate
    property alias distanceText: distanceLabel.text
    property alias locationText: locationLabel.text

    contentHeight: placeLabel.y + placeLabel.height + placeLabel.anchors.bottomMargin

    Label {
        id: locationLabel
        color: delegate.highlighted ? Theme.highlightColor :
                                      Platform.isSailfish ? Theme.primaryColor : Theme.secondaryColor

        width: Math.min(locationLabel.contentWidth,
                        // space that is left after substracting all the other elements from the available width
                        delegate.width
                        - (locationLabel.anchors.leftMargin + distanceLabel.anchors.rightMargin))

        font.pixelSize: Theme.fontSizeMedium
        #truncationMode: TruncationMode.Fade
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
        text: model.location

        font.pixelSize: Theme.fontSizeExtraSmall
        color: Theme.secondaryColor

        truncationMode: TruncationMode.Fade
        anchors {
            left: parent.left
            right: distanceLabel.left

            top: locationLabel.y + locationLabel.height > closing.y + closing.height ?
                     locationLabel.bottom
                   : closing.bottom

            leftMargin: Theme.horizontalPageMargin
            rightMargin: Theme.horizontalPageMargin

            topMargin: Theme.paddingSmall
            bottomMargin: locationLabel.anchors.topMargin
        }
    }

    Label {
        id: distanceLabel

        color: Theme.highlightColor
        font.pixelSize: Theme.fontSizeExtraSmall
        horizontalAlignment: Text.AlignRight
        anchors {
            right: parent.right
            rightMargin: Theme.horizontalPageMargin

            baseline: streetLabel.baseline
        }
    }

}
