function httpGet(url) {
    var xmlHttp = new XMLHttpRequest();
    xmlHttp.open("GET", url, false);
    xmlHttp.send(null);
    return xmlHttp;
}

function get_location_length() {
    var locationsRAW = httpGet("https://themachine.jeremystucki.com/coop/api/v2/locations")

    try {
        var locations = JSON.parse(locationsRAW.responseText);
    } catch (e) {
        console.log("error: failed to parse week overview json");
    }
    if (locationsRAW.status >= 200 && locationsRAW.status < 400) {
        return locations.results.length;
    } else {
        console.log('error or no locations')
    }
}

function get_all_locations() {
    var locationsRAW = httpGet("https://themachine.jeremystucki.com/coop/api/v2/locations")

    try {
        var locations = JSON.parse(locationsRAW.responseText);
    } catch (e) {
        console.log("error: failed to parse json");
    }
    if (locationsRAW.status >= 200 && locationsRAW.status < 400 && locations.results.length > 0) {

        var ret = [];
        for (var i = 0; i < locations.results.length; i++) {
            ret.push({"name":locations.results[i].name, "id":locations.results[i].id});
        }

        return ret;

    } else {
        console.log('error or no locations')
    }
}

function get_one_location(location_id) {
    var locationsRAW = httpGet("https://themachine.jeremystucki.com/coop/api/v2/locations/" + location_id)

    try {
        var location = JSON.parse(locationsRAW.responseText);
    } catch (e) {
        console.log("error: failed to parse json");
    }
    var ret = [];
    ret.push({"name":location.name, "id":location.id, "zip":location.address.zip, "city":location.address.city});
    return ret;

}

function get_all_menus(location_id) {
    var menusRAW = httpGet("https://themachine.jeremystucki.com/coop/api/v2/locations/" + location_id + "/menus/today")
    try {
        var menus = JSON.parse(menusRAW.responseText);
    } catch (e) {
        console.log("error: failed to parse json");
    }
    if (menusRAW.status >= 200 && menusRAW.status < 400) {
        var ret = [];
        for (var i = 0; i < menus.results.length; i++) {
            ret.push({"title":menus.results[i].title, "price":menus.results[i].price});
        }
        return ret;
    } else {
        console.log('error or no menus')
    }
}

function get_one_menu(location_id, menu) {
     var menusRAW = httpGet("https://themachine.jeremystucki.com/coop/api/v2/locations/" + location_id + "/menus/today")

    try {
        var menus = JSON.parse(menusRAW.responseText);
    } catch (e) {
        console.log("error: failed to parse json");
    }
    if (menusRAW.status >= 200 && menusRAW.status < 400) {
        var ret = [];
        for (var i = 0; i < menus.results.length; i++) {
            if(menus.results[i].title === menu) {
                var meal = menus.results[i].menu.join("\n");
                return meal
            }
        }
    } else {
        console.log('error or no menu')
    }
}

