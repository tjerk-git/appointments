
window.onscroll = function () { scrollFunction() };

function moreConfetti() {
    confetti();
}


function scrollFunction() {
    let header = document.getElementById("header");
    let title = document.getElementById("title");
    let container = document.getElementById("container");
    let logo = document.getElementById("logo");

    if (header && title) {
        if (document.body.scrollTop >= 10 || document.documentElement.scrollTop >= 10) {
            if (header) {
                header.style.height = "110px";
                header.style.marginTop = "40px";
                title.style.fontSize = "20pt";
                logo.style.marginTop = "5px";
                container.style.marginTop = header.style.height;
            }
        } else {
            header.style.height = "250px";
            header.style.marginTop = "90px";
            title.style.fontSize = "40pt";
            logo.style.marginTop = "25px";
            container.style.marginTop = header.style.height;
        }
    }
}
