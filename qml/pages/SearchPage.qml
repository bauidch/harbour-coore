import QtQuick 2.0
import Sailfish.Silica 1.0
import io.thp.pyotherside 1.3

Page {
    id: searchPage
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

        width: searchPage.width

        PageHeader {
            title: qsTr("Location")
        }

        SearchField {
            id: searchField
            width: parent.width

            Binding {
                target: searchPage
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
                    python.call('getdata.getAllLocation',[model.text], function(location_in) {});
                    pageStack.push(Qt.resolvedUrl('LocationPage.qml'), {locationTitle: model.text, locationID: searchPage.locationID})
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
                    text: Theme.highlightText(model.text, searchString, Theme.highlightColor)
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

        property variant locations: ['Aarau',
            'Aarau Telli',
            'Aarberg',
            'Aclens Restaurant personnel',
            'Affoltern am Albis',
            'Allaman K.',
            'Allschwil Letten',
            'Altdorf',
            'Amriswil Bistro',
            'Appenzell Bistro',
            'Arbon Novaseta',
            'Au Centre Take it',
            'Baar Delfin',
            'Baar Gotthard',
            'Bachenbülach',
            'Baden',
            'Basel Am Marktplatz',
            'Basel City Pfauen Take it',
            'Basel Europe CaPuccini',
            'Basel Gundeli',
            'Basel Pfauen',
            'Basel Südpark Take it',
            'Basel Volta Zentrum',
            'Bassecourt',
            'Bellinzona Centro',
            'Belp',
            'Bern Bethlehem',
            'Bern Breitenrain',
            'Bern Bümpliz',
            'Bern Ryfflihof',
            'Bern Ryfflihof Take it',
            'Bern Wankdorf Center',
            'Biberist',
            'Biel Bahnhof',
            'Biel Boujean',
            'Biel Nidaugasse',
            'Biel Nidaugasse Take it',
            'Bottmingen Bistro',
            'Bubendorf',
            'Bulle Le Caro',
            'Burgdorf Schützenmatte',
            'Canobbio Ipermercato Resega',
            'Carouge La Praille',
            'Chur Quader',
            'Chur West Restaurant',
            'City St. Annahof Take it',
            'Collombey',
            'Conthey Bassin',
            'Coop Personal Restaurant',
            'Crissier',
            'Crissier CremAmore',
            'Davos',
            'Dielsdorf',
            'Dietikon Silbern',
            'Dietlikon Center',
            'Ecublens',
            'Egerkingen Gäupark',
            'Egerkingen Gäupark',
            'Emmenbrücke',
            'Engelberg',
            'Eyholz Center',
            'Feldmeilen CaPuccini',
            'Feuerthalen Rhymarkt',
            'Frauenfeld Schlosspark',
            'Frenkendorf Bistro',
            'Fribourg',
            'Frick',
            'Genève Eaux-Vives',
            'Genève Fusterie',
            'Genève Montbrillant',
            'Genève Servette',
            'Gossau SG',
            'Granges-Paccot',
            'Grenchen',
            'Gstaad',
            'Gümligen Zentrum',
            'Heerbrugg',
            'Heimberg Center',
            'Herzogenbuchsee',
            'Hinwil Center Restaurant',
            'Ilanz Bistro',
            'Interlaken Ost',
            'Ittigen',
            'Jona Eisenhof',
            'Kaiseraugst',
            'Kirchberg',
            'Kreuzlingen CaPuccini',
            'Kreuzlingen Karussell',
            'Kriens Pilatusmarkt',
            'Kriens Schappe Bistro',
            'Köniz Stapfenmärit',
            'La Chaux-de-Fonds Entilles',
            'Landquart',
            'Langenthal Tell',
            'Langnau',
            'Langnau CaPuccini',
            'Lausanne Au Centre',
            'Lausanne Saint-François',
            'Lenzburg',
            'Liestal Stabhof',
            'Lugano',
            'Lyss Stigli',
            'Löwencenter LU',
            'Martigny Cristal',
            'Matran',
            'Matran CaPuccini',
            'Mels Pizolcenter',
            'Montagny-près-Yverdon',
            'Morges Charpentiers',
            'Moudon Bistro',
            'Muri AG',
            'Möhlin',
            'Münchenbuchsee',
            'Münchenstein Garten Take it',
            'Münchenstein Gartenstadt',
            'Netstal Wiggispark',
            'Neuchâtel',
            'Neuchâtel Maladière',
            'Neuchâtel Maladière CaPucci',
            'Oberwil',
            'Oberwil Mühlematt',
            'Olten',
            'Orbe',
            'Oron-La-Ville',
            'Ostermundigen Bahnhof',
            'Payerne Bistro',
            'Porrentruy',
            'Pratteln Bahnhof',
            'Prilly Centre',
            'Reinach AG',
            'Reinach BL',
            'Rheinfelden',
            'Rickenbach',
            'Romanshorn',
            'Rorschach',
            'Saignelégier Bistro',
            'Sarnen',
            'Schaffhausen',
            'Schafisheim',
            'Schenkon',
            'Schlieren Lilien',
            'Schwarzenburg',
            'Seewen Markt',
            'Serfontana',
            'Sierre',
            'Signy',
            'Sion',
            'St. Gallen Gallusmarkt',
            'St. Moritz Bellevue Bistro',
            'Stans',
            'Tenero',
            'Tenero CremAmore',
            'Thalwil',
            'Thun City Kyburg Take it',
            'Thun Kyburg',
            'Thun Strättligen Markt',
            'Unterentfelden CaPuccini',
            'Uznach Take it',
            'Uzwil',
            'Vernier',
            'Vich',
            'Villars-sur-Glâne',
            'Volketswil Volkiland Bistro',
            'Volketswil Volkiland Take it',
            'Volkiland',
            'Wattwil Bistro',
            'Weinfelden Thurmarkt Rest.',
            'Wettingen Tägipark',
            'Wil Stadtmarkt',
            'Willisau',
            'Winterthur City',
            'Winterthur Grüzemarkt',
            'Winterthur Lokwerk',
            'Winterthur Stadtgarten',
            'Winterthur Stadtgarten Take ',
            'Wohlen Bistro',
            'Worb',
            'Würenlingen Aarepark',
            'Yverdon Bel-Air',
            'Zofingen',
            'Zollikofen',
            'Zuchwil Bistro',
            'Zug',
            'Zug Neustadt',
            'Zürich A-Park CaPuccini',
            'Zürich Bellevue',
            'Zürich Eleven',
            'Zürich Letzipark CremAmore',
            'Zürich Letzipark Take it',
            'Zürich St. Annahof',
            'Zürich Wiedikon']

        function update() {
            var filteredCountries = locations.filter(function (location) { return location.toLowerCase().indexOf(searchString) !== -1 })
            while (count > filteredCountries.length) {
                remove(filteredCountries.length)
            }
            for (var index = 0; index < filteredCountries.length; index++) {
                if (index < count) {
                    setProperty(index, "text", filteredCountries[index])
                } else {
                    append({ "text": filteredCountries[index]})
                }
            }
        }
    }
    Python {
        id: python

        Component.onCompleted: {
            addImportPath(Qt.resolvedUrl('.'));

            setHandler('setLocationID', function(newvalue) {
                searchPage.locationID = newvalue;
            });
            importModule('getdata', function () {});
        }

        onError: {
            console.log('python error: ' + traceback);
        }
    }
}
