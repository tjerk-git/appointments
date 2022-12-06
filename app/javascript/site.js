window.onscroll = function () { scrollFunction() };

function scrollFunction() {
    let header = document.getElementById("header");
    let title = document.getElementById("title");

    if (document.body.scrollTop > 50 || document.documentElement.scrollTop > 50) {
        if (header) {
            header.style.height = "100px";
            title.style.fontSize = "1.0rem";
        }
    } else {
        if (header && title) {
            header.style.height = "200px";
            title.style.fontSize = "2.8rem";
        }
    }
}