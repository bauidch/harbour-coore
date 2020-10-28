import QtQuick 2.5
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
                favoritesBank.deleteItem(index, model.name);
            }

            onClicked: {
                pageStack.push(Qt.resolvedUrl('LocationPage.qml'), {locationTitle: model.name, locationID: model.id})
            }

            Label {
                id: typeLabel
                text: model.name
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
