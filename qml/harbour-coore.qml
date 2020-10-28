import QtQuick 2.5
import Sailfish.Silica 1.0
import QtPositioning 5.2
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
        property Position oldPosition: QtPositioning.coordinate(0, 0)
        preferredPositioningMethods: PositionSource.AllPositioningMethods
    }
}
