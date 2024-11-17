<script>
    import { onMount } from 'svelte';
    import { Chart, registerables } from 'chart.js';
    Chart.register(...registerables);

    let exampleData = [
        { x: 1, y: 10 },
        { x: 2, y: 20 },
        { x: 3, y: 30 },
        { x: 4, y: 25 },
        { x: 5, y: 15 }
    ];
    let cityData = [
        { x: "Wroclaw", y: 35 },
        { x: "Warszawa", y: 40 },
        { x: "Krakow", y: 28 }
    ];
    let jobMarketData = [
        { x: "Engineering", y: 50 },
        { x: "Healthcare", y: 45 },
        { x: "Finance", y: 38 },
        { x: "Education", y: 25 },
        { x: "IT", y: 32 }
    ];
    let seniorityData = [
        { x: "Junior", y: 20 },
        { x: "Mid", y: 35 },
        { x: "Senior", y: 50 },
        { x: "Manager", y: 55 },
        { x: "Director", y: 65 }
    ];
    let monthlyData = [
        { x: "January", y: 15 },
        { x: "February", y: 22 },
        { x: "March", y: 30 },
        { x: "April", y: 28 }
    ];


    function createChart(canvasId, chartLabel, data) {
        new Chart(canvasId, {
            type: 'bar', // or 'line', depending on your preference
            data: {
                labels: data.map(item => item.x),
                datasets: [
                    {
                        label: chartLabel,
                        data: data.map(item => item.y),
                        backgroundColor: 'rgba(75, 192, 192, 0.2)',
                        borderColor: 'rgba(75, 192, 192, 1)',
                        borderWidth: 2,
                        pointRadius: 3,
                        pointBackgroundColor: 'rgba(75, 192, 192, 1)',
                    }
                ]
            },
            options: {
                scales: {
                    x: {
                        type: 'category',
                        title: {
                            display: true,
                            text: 'Category'
                        }
                    },
                    y: {
                        title: {
                            display: true,
                            text: 'Values'
                        }
                    }
                }
            }
        });
    }


    onMount(() => {
        createChart('chart1', 'Chart 1', cityData);
        createChart('chart2', 'Chart 2', jobMarketData);
        createChart('chart3', 'Chart 3', seniorityData);
        createChart('chart4', 'Chart 4', monthlyData);
    });
</script>

<div class="app-bar">
    <a href="/" class="app-name" aria-label="Go to home">Analytics Dashboard</a>
    <button class="user-icon" aria-label="User settings">
        <svg width="24" height="24" fill="white" viewBox="0 0 24 24">
            <circle cx="12" cy="8" r="4" />
            <path d="M12 12c-4 0-8 2-8 5v2h16v-2c0-3-4-5-8-5z" />
        </svg>
    </button>
</div>

<main>
    <h1 class="chart-title">Analytics</h1>
    <div class="charts-container">
        <div class="chart-wrapper">
            <canvas id="chart1"></canvas>
        </div>
        <div class="chart-wrapper">
            <canvas id="chart2"></canvas>
        </div>
        <div class="chart-wrapper">
            <canvas id="chart3"></canvas>
        </div>
        <div class="chart-wrapper">
            <canvas id="chart4"></canvas>
        </div>
    </div>
</main>

<style>
    .app-bar {
        position: fixed;
        top: 0;
        left: 0;
        width: 100%;
        height: 60px;
        background-color: #007bff;
        display: flex;
        align-items: center;
        justify-content: space-between;
        padding: 0 1rem;
        color: white;
        z-index: 1000;
    }

    .app-name {
        font-size: 1.5rem;
        font-weight: bold;
        color: white;
        text-decoration: none;
    }

    .user-icon {
        width: 40px;
        height: 40px;
        display: flex;
        align-items: center;
        justify-content: center;
        background-color: #0056b3;
        border-radius: 50%;
        border: none;
        cursor: pointer;
        color: white;
    }

    main {
        margin-top: 80px;
        max-width: 1200px;
        margin: 0 auto;
        padding: 2rem;
    }

    h1 {
        margin-top: 40px;
        margin-bottom: 2rem;
        font-size: 2rem;
        text-align: center;
        color: #333;
    }

    .charts-container {
        display: grid;
        grid-template-columns: 1fr 1fr;
        gap: 2rem;
    }

    .chart-wrapper {
        background-color: #f8f9fa;
        border-radius: 10px;
        box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        padding: 1rem;
    }

    canvas {
        width: 100% !important;
        height: 300px !important;
    }
</style>
