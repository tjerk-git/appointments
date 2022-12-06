window.onscroll = function () { scrollFunction() };

function scrollFunction() {
    let header = document.getElementById("header");
    let title = document.getElementById("title");

    console.log(document.body.scrollTop);

    if (document.body.scrollTop >= 50 || document.documentElement.scrollTop >= 50) {
        if (header) {
            header.style.height = "110px";
            title.style.fontSize = "20pt";
        }
    } else {
        if (header && title) {
            header.style.height = "200px";
            title.style.fontSize = "55pt";
        }
    }
}