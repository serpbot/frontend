var app = Elm.Main.init({
    flags: {
        year: new Date().getFullYear(),
        storage: JSON.parse(localStorage.getItem("storage"))
    }
})

app.ports.sendMessage.subscribe(function(message) {
    switch (message.action) {
        case "resetCaptcha":
            hcaptcha.reset();
            break;
        case "getCaptchaResponse":
            app.ports.messageReceiver.send(hcaptcha.getResponse());
            break;
        default:
            break;
    }
});

app.ports.loadCaptcha.subscribe(async function() {
    requestAnimationFrame(function() {
        try { hcaptcha.remove(); } catch (Exception){}
        hcaptcha.render('h-captcha', { sitekey: 'a69c40b1-9341-4eee-9ea4-9c11b82dcf50' })
    })
});

app.ports.loadJSGraph.subscribe(async function(message) {
    requestAnimationFrame(function() {
        generateCanvas(message[0], message[1]);
    });
})

app.ports.save.subscribe(storage => {
    localStorage.setItem('storage', JSON.stringify(storage))
    app.ports.load.send(storage)
})

function generateCanvas(engine, trend) {
    datasets = [];
    trend.keywords.forEach(function (keyword) {
        color = dynamicColors();
        datasets.push({
            label: keyword.label,
            data: keyword.data,
            fill: false,
            cubicInterpolationMode: 'monotone',
            tension: 0.4,
            backgroundColor: [
                color
            ],
            borderColor: [
                color
            ],
            borderWidth: 3
        });
    })
    const ctx = document.getElementById(engine).getContext('2d');

    // Destroy chart if exist
    c = Chart.getChart(engine);
    if (c != null)
        c.destroy();

    const chart = new Chart(ctx, {
        type: 'line',
        data: {
            labels: trend.labels,
            datasets: datasets
        },
        options: {
            responsive: true,
            interaction: {
                intersect: false,
            },
            scales: {
                x: {
                    display: true,
                    title: {
                        display: true,
                        text: 'Date'
                    }
                },
                y: {
                    display: true,
                    title: {
                        display: true,
                        text: 'Position'
                    },
                    ticks: {
                        stepSize: 10
                    },
                    suggestedMin: 1,
                    suggestedMax: 100,
                    reverse: true
                },
            }
        }
    });
}

var dynamicColors = function() {
    var r = Math.floor(Math.random() * 255);
    var g = Math.floor(Math.random() * 255);
    var b = Math.floor(Math.random() * 255);
    return "rgb(" + r + "," + g + "," + b + ")";
};