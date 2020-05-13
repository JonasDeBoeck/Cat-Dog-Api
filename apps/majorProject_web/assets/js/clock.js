time()

function time () {
    if (document.getElementById("clock")) {
        let now = new Date();
        document.getElementById("clock").innerText = format(now.getHours()) + ":" + format(now.getMinutes()) + ":" + format(now.getSeconds());
        setTimeout(time, 1000);
    }
}

function format (getal) {
    return getal >= 10 ? getal : "0" + getal;
}