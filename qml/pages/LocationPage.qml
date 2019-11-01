import QtQuick 2.0
import Sailfish.Silica 1.0
import io.thp.pyotherside 1.3
import ".."

Page {
    id: oneLocation

    property string locationTitle
    property string loadingCircle
    property string noData: "False"
    property string locationID

    onStatusChanged: {
      if (oneLocation.status == PageStatus.Active) {
        oneLocation.oneMenu(oneLocation.locationID);
      }
    }

    function oneMenu (location) {
        python.call("getdata.allFood",[location], {})
      }

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
                    pageStack.push(Qt.resolvedUrl('FoodPage.qml'), {foodTitle: model.title, locationTitle: oneLocation.locationTitle, foodPrice: model.price, locationID: oneLocation.locationID})
                }

                Label {
                    anchors.verticalCenter: parent.verticalCenter
                    id: menuLabel
                    text: title
                    color: Theme.primaryColor
                    font.pixelSize: Theme.fontSizeLarge
                    x: Theme.paddingLarge
                }

              }
             ViewPlaceholder {
                 id: loaderPlace
                 enabled: oneLocation.loadingCircle != "gelodet"

                 BusyIndicator {
                     running: true
                     size: BusyIndicatorSize.Large
                     anchors {
                          horizontalCenter: parent.horizontalCenter
                     }
                }
             }
             ViewPlaceholder {
                 id: errorPlace
                 text: qsTr("No Menus")
                 hintText: qsTr("no connection or no menu available")
                 enabled: oneLocation.noData == "True"
             }

        }



        Python {
            id: python

            Component.onCompleted: {
                addImportPath(Qt.resolvedUrl('.'));

                setHandler('loadingCircle', function(newvalue) {
                    oneLocation.loadingCircle = newvalue;

                });
                setHandler('setLocationID', function(newvalue) {
                    oneLocation.locationID = newvalue;
                });

                importModule('getdata', function () {});
                // Import the main module and load the data
                                importModule('getdata', function () {
                                    python.call('getdata.allFood', [oneLocation.locationID], function(result) {
                                        // Load the received data into the list model
                                        if (result.length <= 0) {
                                            oneLocation.noData = "True";
                                        }

                                        for (var i=0; i<result.length; i++) {
                                            listModel.append(result[i]);
                                        }
                                    });
                                })
            }


            onError: {
                console.log('python error: ' + traceback);
            }


        }

}



