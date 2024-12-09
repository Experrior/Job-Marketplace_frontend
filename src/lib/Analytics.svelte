<script>
    import { onMount } from 'svelte';
    import { Chart } from 'chart.js/auto';
    import AppBar from './AppBar.svelte';
    import axios from 'axios';
  
    let chart1, chart2, chart3, chart4;
  
    async function fetchData(endpoint) {
      const response = await fetch(endpoint);
      return response.json();
    }
  
    async function renderCharts() {
      const all_jsons = await axios.get('http://127.0.0.1:8081/charts/get-json');
      const json1 = all_jsons.data.top_10_locations_by_average_salaries;
      const json2 = all_jsons.data.top_5_industries_by_average_salaries;
      const json3 = all_jsons.data.avg_applications_by_level;
      const json4 = all_jsons.data.avg_job_offers_per_company_by_industry;
  
      console.log(all_jsons);
  
      if (chart1) chart1.destroy();
      if (chart2) chart2.destroy();
      if (chart3) chart3.destroy();
      if (chart4) chart4.destroy();
  
      // Chart 1: Average Salary by Location
      const ctx1 = document.getElementById('chart1').getContext('2d');
      chart1 = new Chart(ctx1, {
        type: 'bar',
        data: {
          labels: json1.data.map(item => item.location),
          datasets: [
            {
              label: 'Average Salary',
              data: json1.data.map(item => item.average_salary),
              backgroundColor: 'rgba(75, 192, 192, 0.6)',
            },
          ],
        },
        options: {
          responsive: true,
          maintainAspectRatio: false,
          scales: {
            x: { ticks: { autoSkip: false } },
          },
        },
      });
  
      // Chart 2: Views by Job Title
      const ctx2 = document.getElementById('chart2').getContext('2d');
      chart2 = new Chart(ctx2, {
        type: 'bar',
        data: {
          labels: json2.data.map(item => item.job_title),
          datasets: [
            {
              label: 'Views',
              data: json2.data.map(item => item.views),
              backgroundColor: 'rgba(153, 102, 255, 0.6)',
            },
          ],
        },
        options: {
          responsive: true,
          maintainAspectRatio: false,
        },
      });
  
      // Chart 3: Applications by Level
      const ctx3 = document.getElementById('chart3').getContext('2d');
      chart3 = new Chart(ctx3, {
        type: 'bar',
        data: {
          labels: json3.data.map(item => item.level),
          datasets: [
            {
              label: 'Average Applications',
              data: json3.data.map(item => item.average_applications),
              backgroundColor: 'rgba(255, 159, 64, 0.6)',
            },
          ],
        },
        options: {
          responsive: true,
          maintainAspectRatio: false,
        },
      });
      // Chart 4: Average Number of Job Offers per Company in Given Industry
      const ctx4 = document.getElementById('chart4').getContext('2d');
      chart4 = new Chart(ctx4, {
        type: 'bar',
        data: {
          labels: json4.data.map(item => item.industry),
          datasets: [
            {
              label: 'Average Number of Job Offers per Company',
              data: json4.data.map(item => item.average_offers),
              backgroundColor: 'rgba(75, 192, 192, 0.6)',
            },
          ],
        },
        options: {
          responsive: true,
          maintainAspectRatio: false,
          scales: {
            x: { ticks: { autoSkip: false } },
          },
        },
      });
    }
  
    onMount(() => {
      renderCharts();
  
      return () => {
        if (chart1) chart1.destroy();
        if (chart2) chart2.destroy();
        if (chart3) chart3.destroy();
        if (chart4) chart4.destroy();
      };
    });
  </script>
  
  <style>
    main {
      padding-top: 60px;
      height: calc(100vh - 60px);
      overflow-y: auto;
      background-color: #f8f9fa;
      display: grid;
      grid-template-columns: repeat(2, 1fr);
      gap: 1.5rem;
      justify-items: center;
    }
  
    .chart-container {
      margin-top: 20px;
      margin-bottom: 20px;
      width: 100%;
      max-width: 800px;
      height: 500px;
      background-color: #ffffff;
      border-radius: 8px;
      box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
      padding: 1rem;
    }
  
    .chart-title {
      text-align: center;
      margin-bottom: 1rem;
      font-size: 1.2rem;
      color: #333;
    }
  
    canvas {
      display: block;
      max-width: 100%;
      max-height: 400px;
    }
  </style>
  
  <AppBar />
  
  <main>
    <div class="chart-container">
      <h2 class="chart-title">Average Salary by Location</h2>
      <canvas id="chart1"></canvas>
    </div>
  
    <div class="chart-container">
      <h2 class="chart-title">Views by Job Title</h2>
      <canvas id="chart2"></canvas>
    </div>
  
    <div class="chart-container">
      <h2 class="chart-title">Applications by Level</h2>
      <canvas id="chart3"></canvas>
    </div>

    <div class="chart-container">
      <h2 class="chart-title">Average Number of Job Offers per Company in Given Industry</h2>
      <canvas id="chart4"></canvas>
    </div>
  </main>
  