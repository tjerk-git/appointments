window.onscroll = function () { scrollFunction() };

function scrollFunction() {
    let header = document.getElementById("header");
    let title = document.getElementById("title");

    if (!header.classList.contains('small__header')) {
        if (document.body.scrollTop >= 50 || document.documentElement.scrollTop >= 50) {
            if (header) {
                header.style.height = "110px";
                title.style.fontSize = "20pt";
            }
        } else {
            if (header && title) {
                header.style.height = "45%";
                title.style.fontSize = "55pt";
            }
        }
    }
}