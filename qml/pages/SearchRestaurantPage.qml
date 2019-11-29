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
            }


            delegate: BackgroundItem {
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

                Label {
                    x: searchField.textLeftMargin
                    anchors.verticalCenter: parent.verticalCenter
                    color: searchString.length > 0 ? (highlighted ? Theme.secondaryHighlightColor : Theme.secondaryColor)
                                                   : (highlighted ? Theme.highlightColor : Theme.primaryColor)
                    textFormat: Text.StyledText
                    text: Theme.highlightText(model.name, searchString, Theme.highlightColor)
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

            var filteredCountries = locations.filter(function (location) {
                var locationname = location.name
                return locationname.toLowerCase().indexOf(searchString) !== -1
            })
            while (count > filteredCountries.length) {
                remove(filteredCountries.length)
            }
            for (var index = 0; index < filteredCountries.length; index++) {
                if (index < count) {
                    setProperty(index, "name", filteredCountries[index].name)
                } else {
                    append({ "name": filteredCountries[index].name, "id": filteredCountries[index].id})
                }
            }
        }
    }
}
