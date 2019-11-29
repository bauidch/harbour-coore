import QtQuick 2.0
import Sailfish.Silica 1.0
import ".."
import "../js/locations.js" as Locations
Page {
    id: oneLocation

    property string locationTitle
    property string loadingCircle
    property string noData: "False"
    property string locationID
    property variant menus

        SilicaListView {
             id: listView
             anchors.fill: parent
             header: PageHeader {
                 id: titleLabel
                 title: oneLocation.locationTitle
             }
             PullDownMenu {
                 MenuItem {
                     text: qsTr("Add to Favorites")
                     onClicked: favoritesBank.addItem(oneLocation.locationTitle)
                 }
             }

             model: ListModel {
                id: listModel
             }

             delegate: BackgroundItem {
                id: delegate

                onClicked: {
                    pageStack.push(Qt.resolvedUrl('MenuPage.qml'), {foodTitle: model.title, locationTitle: oneLocation.locationTitle, foodPrice: model.price, locationID: oneLocation.locationID})
                }

                Label {
                    anchors.verticalCenter: parent.verticalCenter
                    id: menuLabel
                    text: model.title
                    color: Theme.primaryColor
                    font.pixelSize: Theme.fontSizeLarge
                    x: Theme.paddingLarge
                }

              }
             ViewPlaceholder {
                 id: errorPlace
                 text: qsTr("No Menus")
                 hintText: qsTr("no connection or no menu available")
                 enabled: oneLocation.noData == "True"
             }

        }
        Component.onCompleted: {
            oneLocation.menus =  Locations.get_all_menus(oneLocation.locationID)
            for (var i=0; i<oneLocation.menus.length; i++) {
                listModel.append({"title": oneLocation.menus[i].title, "price": oneLocation.menus[i].price});
            }

        }
}
