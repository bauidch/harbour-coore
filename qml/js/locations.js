function httpGet(url) {
    var XMLHttpRequest = require("xmlhttprequest").XMLHttpRequest;
    var xmlHttp = new XMLHttpRequest();
    xmlHttp.open("GET", url, false); // false for synchronous request
    xmlHttp.send(null);
    //console.log(xmlHttp.status);
    return xmlHttp;
}

var locationsRAW = httpGet("https://themachine.jeremystucki.com/coop/api/v2/locations")

try {
    var locations = JSON.parse(locationsRAW.responseText);
} catch (e) {
    console.log("error: failed to parse week overview json");
}
console.log(locations);
//console.log(locations.results);
//console.log(locations.results.length);
if (locationsRAW.status >= 200 && locationsRAW.status < 400 && locations.results.length > 0) {
    locations.results.forEach(restaurant => {
        console.log(restaurant.name);
        console.log(restaurant.id);
        console.log(restaurant.address.city);
        console.log("----");
    })
} else {
    console.log('error or no locations')
}
