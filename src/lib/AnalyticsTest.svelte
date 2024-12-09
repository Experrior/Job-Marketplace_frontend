<script>
    import { onMount } from 'svelte';
    import { Chart, registerables } from 'chart.js';
    Chart.register(...registerables);

    const categories = [
        { id: 'salary', label: 'Salary Analytics' },
        { id: 'applications', label: 'Application Statistics' },
        { id: 'offers', label: 'Job Offers' }
    ];

    let selectedCategory = 'salary';

    const topLocationsBySalary = {
        "topLocationsBySalary": [
            { "location": "San Francisco, CA", "averageSalary": 145000 },
            { "location": "New York, NY", "averageSalary": 135000 },
            { "location": "Seattle, WA", "averageSalary": 130000 },
            { "location": "Boston, MA", "averageSalary": 125000 },
            { "location": "Austin, TX", "averageSalary": 120000 },
            { "location": "Washington, DC", "averageSalary": 118000 },
            { "location": "Chicago, IL", "averageSalary": 115000 },
            { "location": "Los Angeles, CA", "averageSalary": 110000 },
            { "location": "Denver, CO", "averageSalary": 108000 },
            { "location": "Atlanta, GA", "averageSalary": 105000 }
        ]
    }

    const topIndustriesBySalary = {
        "topIndustriesBySalary": [
            { "industry": "Tech", "averageSalary": 140000 },
            { "industry": "Finance", "averageSalary": 135000 },
            { "industry": "Healthcare", "averageSalary": 125000 },
            { "industry": "Consulting", "averageSalary": 120000 },
            { "industry": "Energy", "averageSalary": 118000 }
        ]
    }

    const mostViewedJobOffers = {
        "mostViewedJobOffers": [
            { "jobTitle": "Software Engineer", "views": 12500 },
            { "jobTitle": "Data Scientist", "views": 11200 },
            { "jobTitle": "Product Manager", "views": 9500 },
            { "jobTitle": "Marketing Specialist", "views": 8500 },
            { "jobTitle": "Financial Analyst", "views": 8200 }
        ]
    }

    const averageApplicationsPerUser = {
        "averageApplicationsPerUser": {
            "value": 3.8
        }
    }

    const averageApplicationsByLevel = {
        "averageApplicationsByLevel": [
            { "level": "Entry", "averageApplications": 25 },
            { "level": "Mid", "averageApplications": 20 },
            { "level": "Senior", "averageApplications": 15 },
            { "level": "Director", "averageApplications": 10 },
            { "level": "Executive", "averageApplications": 5 }
        ]
    }

    const totalApplicationsLast30Days = {
        "totalApplicationsLast30Days": {
            "value": 58000
        }
    }

    const averageJobOffersByIndustry = {
        "averageJobOffersByIndustry": [
            { "industry": "Tech", "averageJobOffers": 250 },
            { "industry": "Finance", "averageJobOffers": 200 },
            { "industry": "Healthcare", "averageJobOffers": 180 },
            { "industry": "Consulting", "averageJobOffers": 150 },
            { "industry": "Energy", "averageJobOffers": 120 }
        ]
    }

    const percentageChangeJobOffersByIndustry = {
        "percentageChangeJobOffersByIndustry": [
            { "industry": "Tech", "percentageChange": 10 },
            { "industry": "Finance", "percentageChange": -5 },
            { "industry": "Healthcare", "percentageChange": 7 },
            { "industry": "Consulting", "percentageChange": 12 },
            { "industry": "Energy", "percentageChange": -3 }
        ]
    }

    const jobOffersBySeniority = {
        "jobOffersBySeniority": [
            { "seniority": "Entry", "jobOffers": 500, "averageSalary": 45000 },
            { "seniority": "Mid", "jobOffers": 400, "averageSalary": 75000 },
            { "seniority": "Senior", "jobOffers": 300, "averageSalary": 100000 },
            { "seniority": "Director", "jobOffers": 150, "averageSalary": 135000 },
            { "seniority": "Executive", "jobOffers": 50, "averageSalary": 180000 }
        ]
    }

    const yearsOfExperienceHistogram = {
        "yearsOfExperienceHistogram": [
            { "range": "0-3", "percentage": 30 },
            { "range": "3-6", "percentage": 25 },
            { "range": "6-10", "percentage": 20 },
            { "range": "10-15", "percentage": 15 },
            { "range": "15-25", "percentage": 8 },
            { "range": ">25", "percentage": 2 }
        ]
    }

    const averageRequiredYearsBySeniority = {
        "averageRequiredYearsBySeniority": [
            { "seniority": "Entry", "averageYears": 1 },
            { "seniority": "Mid", "averageYears": 3 },
            { "seniority": "Senior", "averageYears": 7 },
            { "seniority": "Director", "averageYears": 10 },
            { "seniority": "Executive", "averageYears": 15 }
        ]
    }

    const averageRequiredYearsByIndustry = {
        "averageRequiredYearsByIndustry": [
            { "industry": "Tech", "averageYears": 5 },
            { "industry": "Finance", "averageYears": 6 },
            { "industry": "Healthcare", "averageYears": 7 },
            { "industry": "Consulting", "averageYears": 8 },
            { "industry": "Energy", "averageYears": 9 }
        ]
    }

    const topMostViewedJobOffers = {
        "topMostViewedJobOffers": [
            { "jobTitle": "Software Engineer", "views": 15200 },
            { "jobTitle": "Data Scientist", "views": 14000 },
            { "jobTitle": "Product Manager", "views": 12500 },
            { "jobTitle": "UX Designer", "views": 11200 },
            { "jobTitle": "DevOps Engineer", "views": 10800 },
            { "jobTitle": "Marketing Specialist", "views": 9800 },
            { "jobTitle": "Business Analyst", "views": 9200 },
            { "jobTitle": "Account Manager", "views": 8700 },
            { "jobTitle": "Financial Analyst", "views": 8500 },
            { "jobTitle": "Sales Executive", "views": 8100 }
        ]
    }

    const topCompaniesByAverageSalary = {
        "topCompaniesByAverageSalary": [
            { "company": "TechCorp", "averageSalary": 150000 },
            { "company": "FinBank", "averageSalary": 140000 },
            { "company": "HealthCare Inc.", "averageSalary": 135000 },
            { "company": "Innovate LLC", "averageSalary": 130000 },
            { "company": "EcoEnergy", "averageSalary": 125000 }
        ]
    }

    const topCompaniesByJobOffers = {
        "topCompaniesByJobOffers": [
            { "company": "TechCorp", "jobOffers": 300 },
            { "company": "FinBank", "jobOffers": 250 },
            { "company": "HealthCare Inc.", "jobOffers": 220 },
            { "company": "Innovate LLC", "jobOffers": 180 },
            { "company": "RetailPlus", "jobOffers": 150 }
        ]
    }

    const ratioOfLevelRequiredByIndustry = {
        "ratioOfLevelRequiredByIndustry": [
            {
                "industry": "Tech",
                "level": {
                    "Entry": 40,
                    "Mid": 35,
                    "Senior": 20,
                    "Director": 4,
                    "Executive": 1
                }
            },
            {
                "industry": "Finance",
                "level": {
                    "Entry": 30,
                    "Mid": 40,
                    "Senior": 25,
                    "Director": 3,
                    "Executive": 2
                }
            },
            {
                "industry": "Healthcare",
                "level": {
                    "Entry": 35,
                    "Mid": 30,
                    "Senior": 25,
                    "Director": 7,
                    "Executive": 3
                }
            },
            {
                "industry": "Consulting",
                "level": {
                    "Entry": 25,
                    "Mid": 35,
                    "Senior": 30,
                    "Director": 7,
                    "Executive": 3
                }
            },
            {
                "industry": "Energy",
                "level": {
                    "Entry": 20,
                    "Mid": 40,
                    "Senior": 30,
                    "Director": 8,
                    "Executive": 2
                }
            }
        ]
    }

    const salaryDifferenceByIndustry = {
        "salaryDifferenceByIndustry": [
            { "industry": "Tech", "difference": 80000 },
            { "industry": "Finance", "difference": 75000 },
            { "industry": "Healthcare", "difference": 70000 },
            { "industry": "Consulting", "difference": 65000 },
            { "industry": "Energy", "difference": 60000 }
        ]
    }

    // Define the dataSources array with all charts, including descriptions
    const dataSources = [
        {
            id: 'chart1',
            label: 'Top Locations by Salary',
            description: 'This chart displays the average salaries across the top locations.',
            data: topLocationsBySalary.topLocationsBySalary,
            xKey: 'location',
            yKey: 'averageSalary',
            type: 'bar',
            category: 'salary'
        },
        {
            id: 'chart2',
            label: 'Top Industries by Salary',
            description: 'Average salaries in the leading industries.',
            data: topIndustriesBySalary.topIndustriesBySalary,
            xKey: 'industry',
            yKey: 'averageSalary',
            type: 'bar',
            category: 'salary'
        },
        {
            id: 'chart3',
            label: 'Most Viewed Job Offers',
            description: 'Job offers with the highest number of views.',
            data: mostViewedJobOffers.mostViewedJobOffers,
            xKey: 'jobTitle',
            yKey: 'views',
            type: 'bar',
            indexAxis: 'y',
            category: 'offers'
        },
        {
            id: 'chart5',
            label: 'Average Applications by Level',
            description: 'Average number of applications received per job level.',
            data: averageApplicationsByLevel.averageApplicationsByLevel,
            xKey: 'level',
            yKey: 'averageApplications',
            type: 'line',
            category: 'applications'
        },
        {
            id: 'chart7',
            label: 'Average Job Offers by Industry',
            description: 'Average number of job offers available in each industry.',
            data: averageJobOffersByIndustry.averageJobOffersByIndustry,
            xKey: 'industry',
            yKey: 'averageJobOffers',
            type: 'bar',
            category: 'offers'
        },
        {
            id: 'chart8',
            label: 'Percentage Change in Job Offers by Industry',
            description: 'Percentage change in job offers compared to the previous period.',
            data: percentageChangeJobOffersByIndustry.percentageChangeJobOffersByIndustry,
            xKey: 'industry',
            yKey: 'percentageChange',
            type: 'bar',
            category: 'offers'
        },
        {
            id: 'chart9',
            label: 'Job Offers by Seniority',
            description: 'Distribution of job offers across different seniority levels.',
            data: jobOffersBySeniority.jobOffersBySeniority,
            xKey: 'seniority',
            yKey: 'jobOffers',
            type: 'bar',
            category: 'offers'
        },
        {
            id: 'chart10',
            label: 'Years of Experience Histogram',
            description: 'Distribution of job offers based on years of experience required.',
            data: yearsOfExperienceHistogram.yearsOfExperienceHistogram,
            xKey: 'range',
            yKey: 'percentage',
            type: 'bar',
            category: 'offers'
        },
        {
            id: 'chart11',
            label: 'Average Required Years by Seniority',
            description: 'Average years of experience required for each seniority level.',
            data: averageRequiredYearsBySeniority.averageRequiredYearsBySeniority,
            xKey: 'seniority',
            yKey: 'averageYears',
            type: 'bar',
            category: 'offers'
        },
        {
            id: 'chart12',
            label: 'Average Required Years by Industry',
            description: 'Average years of experience required in each industry.',
            data: averageRequiredYearsByIndustry.averageRequiredYearsByIndustry,
            xKey: 'industry',
            yKey: 'averageYears',
            type: 'bar',
            category: 'offers'
        },
        {
            id: 'chart13',
            label: 'Top Most Viewed Job Offers',
            description: 'Top job offers based on the number of views received.',
            data: topMostViewedJobOffers.topMostViewedJobOffers,
            xKey: 'jobTitle',
            yKey: 'views',
            type: 'bar',
            indexAxis: 'y',
            category: 'offers'
        },
        {
            id: 'chart14',
            label: 'Top Companies by Average Salary',
            description: 'Companies offering the highest average salaries.',
            data: topCompaniesByAverageSalary.topCompaniesByAverageSalary,
            xKey: 'company',
            yKey: 'averageSalary',
            type: 'bar',
            category: 'salary'
        },
        {
            id: 'chart15',
            label: 'Top Companies by Job Offers',
            description: 'Companies with the most job offers available.',
            data: topCompaniesByJobOffers.topCompaniesByJobOffers,
            xKey: 'company',
            yKey: 'jobOffers',
            type: 'bar',
            category: 'offers'
        },
        {
            id: 'chart16',
            label: 'Salary Difference by Industry',
            description: 'Difference in salaries across various industries.',
            data: salaryDifferenceByIndustry.salaryDifferenceByIndustry,
            xKey: 'industry',
            yKey: 'difference',
            type: 'bar',
            category: 'salary'
        },
        {
            id: 'chart17',
            label: 'Ratio of Level Required by Industry',
            description: 'Proportion of different seniority levels required in each industry.',
            data: ratioOfLevelRequiredByIndustry.ratioOfLevelRequiredByIndustry,
            xKey: 'level',
            yKey: 'industry',
            type: 'bar',
            nested: true,
            category: 'applications'
        }
    ];

    // Function to dynamically create charts
    let filteredDataSources = dataSources.filter(chart => chart.category === selectedCategory);

    let chartInstances = {};

    function handleCategoryChange(event) {
        selectedCategory = event.target.value;
        filteredDataSources = dataSources.filter(chart => chart.category === selectedCategory);

        // Destroy existing charts and clear instances
        Object.values(chartInstances).forEach(chart => chart.destroy());
        chartInstances = {};

        // Ensure the DOM updates with new canvases before initializing charts
        setTimeout(() => {
            initializeCharts();
        }, 0);
    }

    function initializeCharts() {
        filteredDataSources.forEach(({ id, label, data, xKey, yKey, type, singleValue, nested, indexAxis }) => {
            createChart(id, label, data, xKey, yKey, type, { singleValue, nested, indexAxis });
        });
    }

    function createChart(canvasId, chartLabel, dataset, xKey, yKey, type = 'bar', optionsOverride = {}) {
        const canvas = document.getElementById(canvasId);
        if (!canvas) return;

        const ctx = canvas.getContext('2d');

        if (chartInstances[canvasId]) {
            chartInstances[canvasId].destroy();
        }

        chartInstances[canvasId] = new Chart(ctx, {
            type,
            data: {
                labels: dataset.map(item => item[xKey]),
                datasets: [
                    {
                        label: chartLabel,
                        data: dataset.map(item => item[yKey]),
                        backgroundColor: type === 'line' ? 'rgba(75, 192, 192, 0.2)' : 'rgba(54, 162, 235, 0.6)',
                        borderColor: type === 'line' ? 'rgba(75, 192, 192, 1)' : 'rgba(54, 162, 235, 1)',
                        borderWidth: 2,
                        fill: type === 'line'
                    }
                ]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false
            }
        });
    }

    onMount(() => {
        initializeCharts();
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
    <div class="dropdown-container">
        <label for="categoryDropdown">Choose a category:</label>
        <select id="categoryDropdown" bind:value={selectedCategory} on:change={handleCategoryChange}>
            {#each categories as { id, label }}
                <option value={id}>{label}</option>
            {/each}
        </select>
    </div>
    <div class="charts-container">
        {#each filteredDataSources as { id, label, description }}
            <div class="chart-wrapper">
                <h2 class="chart-label">{label}</h2>
                <canvas id={id}></canvas>
                <p class="chart-description">{description}</p>
            </div>
        {/each}
    </div>
</main>

<style>
    .dropdown-container {
        display: flex;
        align-items: center;
        justify-content: center;
        margin-bottom: 2rem;
    }

    select {
        padding: 0.5rem;
        border-radius: 5px;
        border: 1px solid #ccc;
        font-size: 1rem;
        margin-left: 1rem;
    }
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
        max-width: 1400px;
        margin: 0 auto;
        padding: 2rem;
    }

    .chart-title {
        margin-top: 40px;
        margin-bottom: 2rem;
        font-size: 2.5rem;
        text-align: center;
        color: #333;
    }

    .charts-container {
        display: grid;
        grid-template-columns: 1fr;
        gap: 2rem;
    }

    .chart-wrapper {
        background-color: #f8f9fa;
        border-radius: 10px;
        box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        padding: 2rem;
        display: flex;
        flex-direction: column;
        align-items: center;
    }

    .chart-label {
        text-align: center;
        margin-bottom: 1rem;
        font-size: 1.5rem;
        color: #555;
    }

    .chart-description {
        margin-top: 1rem;
        text-align: center;
        font-size: 1rem;
        color: #666;
        max-width: 800px;
    }

    canvas {
        width: 100% !important;
        height: 400px !important;
    }

    @media (max-width: 768px) {
        .charts-container {
            grid-template-columns: 1fr;
        }

        canvas {
            height: 300px !important;
        }

        .chart-wrapper {
            padding: 1rem;
        }

        .chart-title {
            font-size: 2rem;
        }

        .chart-label {
            font-size: 1.2rem;
        }

        .chart-description {
            font-size: 0.9rem;
        }
    }
</style>
