import QtQuick 2.0
import Sailfish.Silica 1.0

import "../js/locations.js" as Locations

Page {
    id: searchRestPage
    property string searchString
    property bool keepSearchFieldFocus
    property string activeView: "list"
    property string locationID

    onSearchStringChanged: listModel.update()
    Component.onCompleted: listModel.update()

    Loader {
        anchors.fill: parent
        sourceComponent: activeView == "list" ? listViewComponent : gridViewComponent
    }

    Column {
        id: headerContainer

        width: searchRestPage.width

        PageHeader {
            title: qsTr("Location")
        }

        SearchField {
            id: searchField
            width: parent.width

            Binding {
                target: searchRestPage
                property: "searchString"
                value: searchField.text.toLowerCase().trim()
            }
        }
    }

    Component {
        id: listViewComponent
        SilicaListView {
            model: listModel
            anchors.fill: parent
            currentIndex: -1 // otherwise currentItem will steal focus
            header:  Item {
                id: header
                width: headerContainer.width
                height: headerContainer.height
                Component.onCompleted: headerContainer.parent = header
            }
            PullDownMenu {
                MenuItem {
                    text: qsTr("About")
                    onClicked: pageStack.push(Qt.resolvedUrl("AboutPage.qml"))
                }
                MenuItem {
                    text: qsTr("Favorites")
                    onClicked: pageStack.push(Qt.resolvedUrl("FavoritePage.qml"))
                }
                MenuItem {
                    text: qsTr("Maps")
                    onClicked: pageStack.push(Qt.resolvedUrl("MapsPage.qml"))
                }
            }


            delegate: LocationListItem {
                id: backgroundItem
                onClicked: {
                    pageStack.push(Qt.resolvedUrl('LocationPage.qml'), {locationTitle: model.name, locationID: model.id})
                }

                ListView.onAdd: AddAnimation {
                    target: backgroundItem
                }
                ListView.onRemove: RemoveAnimation {
                    target: backgroundItem
                }
                locationText: Theme.highlightText(model.name, searchString, Theme.highlightColor)
                distanceText: "42m"
                }
            }

            VerticalScrollDecorator {}

            Component.onCompleted: {             
                if (keepSearchFieldFocus) {
                    searchField.forceActiveFocus()
                }
                keepSearchFieldFocus = false
            }
        }
    }

    ListModel {
        id: listModel

        property variant locations: Locations.get_all_locations()

        function update() {

            var filteredLocations = locations.filter(function (location) {
                var locationname = location.name
                return locationname.toLowerCase().indexOf(searchString) !== -1
            })
            while (count > filteredLocations.length) {
                remove(filteredLocations.length)
            }
            for (var index = 0; index < filteredLocations.length; index++) {
                if (index < count) {
                    setProperty(index, "name", filteredLocations[index].name)
                    setProperty(index, "id", filteredLocations[index].id)
                } else {
                    append({ "name": filteredLocations[index].name, "id": filteredLocations[index].id})
                }
            }
        }
    }
}
