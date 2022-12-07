
window.onscroll = function () { scrollFunction() };


window.addEventListener("load", () => {
    let header = document.getElementById("header");
    let container = document.getElementById("container");

    if (header.classList.contains('small__header')) {
        container.style.marginTop = "100px";
        header.style.marginTop = "45px";
    }

});


function scrollFunction() {
    let header = document.getElementById("header");
    let title = document.getElementById("title");
    let container = document.getElementById("container");

    if (!header.classList.contains('small__header')) {
        if (document.body.scrollTop >= 50 || document.documentElement.scrollTop >= 50) {
            if (header) {
                header.style.height = "110px";
                header.style.marginTop = "40px";
                title.style.fontSize = "20pt";
                container.style.marginTop = header.style.height;
            }
        } else {
            if (header && title) {
                header.style.height = "200px";
                header.style.marginTop = "90px";
                title.style.fontSize = "55pt";
                container.style.marginTop = header.style.height;
            }
        }
    }
}
