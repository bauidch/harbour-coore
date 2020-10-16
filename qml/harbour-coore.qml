import QtQuick 2.0
import Sailfish.Silica 1.0
import QtPositioning 5.0
import "pages"
import "components"

ApplicationWindow
{
    initialPage: Component { SearchRestaurantPage { } }
    cover: Qt.resolvedUrl("cover/CoverPage.qml")
    allowedOrientations: defaultAllowedOrientations

    FavoritesBank {
        id: favoritesBank
    }

    PositionSource {
        id: globalPositionSource
        updateInterval: 5000
        property Position oldPosition: QtPositioning.coordinate(46.947922, 7.440390)
        preferredPositioningMethods: PositionSource.AllPositioningMethods
    }
}
