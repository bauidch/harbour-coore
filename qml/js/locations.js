function httpGet(url) {
    //var XMLHttpRequest = require("xmlhttprequest").XMLHttpRequest;
    var xmlHttp = new XMLHttpRequest();
    xmlHttp.open("GET", url, false); // false for synchronous request
    xmlHttp.send(null);
    //console.log(xmlHttp.status);
    return xmlHttp;
}

function getLocationLength() {
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

function getAllLocation() {
    var locationsRAW = httpGet("https://themachine.jeremystucki.com/coop/api/v2/locations")

    try {
        var locations = JSON.parse(locationsRAW.responseText);
    } catch (e) {
        console.log("error: failed to parse week overview json");
    }
    if (locationsRAW.status >= 200 && locationsRAW.status < 400 && locations.results.length > 0) {
        console.log(locations.results[0]);

        var ret = [];
        for (var i = 0; i < locations.results.length; i++) {
            //console.log(locations.results[i].name);
            ret.push(locations.results[i].name);
            //if (ret.length == 50) break;
        }
        return ret;

    } else {
        console.log('error or no locations')
    }
}

