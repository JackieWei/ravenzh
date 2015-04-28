function getQueryStringValue(queryStr) {
    var url = window.top.location.toString();
    var index = url.indexOf("?");

    if (index == -1) return null;
    else {
        var queryString = url.substr(index + 1);
        var arr = queryString.split("&");
        return arr;
    }
}
function getUrl() {
    return window.top.location.toString();
}