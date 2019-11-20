import QtQuick 2.0
import Sailfish.Silica 1.0
import io.thp.pyotherside 1.3


Page {
    id: oneFood

    property string foodTitle
    property string locationTitle
    property double foodPrice
    property string locationID

    onStatusChanged: {
      if (oneFood.status == PageStatus.Active) {
        oneFood.onlyFood(oneFood.foodTitle, oneFood.foodPrice, oneFood.locationID);
      }
    }

    function onlyFood (food, price, location) {
        python.call("getdata.oneFood",[food, price, location], {})
      }

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
                    //text: qsTr("Menu")
                    wrapMode: Text.Wrap
                    color: Theme.secondaryHighlightColor
                    font.pixelSize: Theme.fontSizeExtraLarge
                }
                Label {
                    x: Theme.paddingLarge
                    id: priceLabel
                    //text: qsTr("Price")
                    wrapMode: Text.Wrap
                    color: Theme.primaryColor
                    font.pixelSize: Theme.fontSizeExtraLarge
                }
            }
            ViewPlaceholder {
                enabled: priceLabel.text == ""

                BusyIndicator {
                    running: true
                    size: BusyIndicatorSize.Large
                    anchors {
                         horizontalCenter: parent.horizontalCenter
                    }
               }
            }
            Label {
                x: Theme.paddingLarge
                id: menuLabel
                //text: qsTr("Food")
                color: Theme.secondaryHighlightColor
                font.pixelSize: Theme.fontSizeLarge
            }
            Label {
                   text: qsTr("Coop Restaurant ") + oneFood.locationID//oneFood.locationTitle
                   x: Theme.paddingLarge
            }


        }

        Python {
            id: python

            Component.onCompleted: {
                addImportPath(Qt.resolvedUrl('.'));

                setHandler('oneFood-title', function(newvalue) {
                    mainLabel.text = newvalue;
                });
                setHandler('oneFood-price', function(price) {
                    priceLabel.text = price;
                });
                setHandler('oneFood-menu', function(menu) {
                    menuLabel.text = menu;
                });

                importModule('getdata', function () {});
            }

            onError: {
                console.log('python error: ' + traceback);
            }

        }
    }
}
