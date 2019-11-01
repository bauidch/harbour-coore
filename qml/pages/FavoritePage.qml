import QtQuick 2.0
import Sailfish.Silica 1.0
import ".."

Page {
    id: favoriteList
    allowedOrientations: Orientation.Portrait

    SilicaListView {
        id: favoritesView
        model: favoritesBank
        delegate: ListItem {
            id: delegateItem
            width: parent.width
            menu: contextMenu
            ListView.onRemove: animateRemoval()
            function deleteItem() {
                console.log("Deleting (" + index +") " + location)
                favoritesBank.deleteItem(index, location);
            }

            onClicked: {
                pageStack.push(Qt.resolvedUrl('LocationPage.qml'), {locationTitle: location})
            }

            Label {
                id: typeLabel
                text: location
                anchors.verticalCenter: parent.verticalCenter
                color: delegateItem.highlighted ? Theme.highlightColor : Theme.primaryColor
                x: Theme.paddingLarge
            }

            Component {
                id: contextMenu
                ContextMenu {
                    MenuItem {
                        text: qsTr("Remove")
                        onClicked: remorseAction(qsTr("Removing"), delegateItem.deleteItem )
                    }
                }
            }
        }
        anchors.fill: parent

        VerticalScrollDecorator {}


        ViewPlaceholder {
                     enabled: favoritesView.count === 0
                     text: qsTr("No Entry")
        }

        header: PageHeader {
            title: "Favorites"
        }
    }
}
