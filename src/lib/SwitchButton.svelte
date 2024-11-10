<script>
    export let isApplicant = true;
    export let leftText = "Applicant";
    export let rightText = "Recruiter";

    function toggle() {
        isApplicant = !isApplicant;
    }
</script>

<div class="switch-button" on:click={toggle}>
    <div class="option" class:selected={isApplicant}>{leftText}</div>
    <div class="option" class:selected={!isApplicant}>{rightText}</div>
</div>

<style>
    .switch-button {
        display: flex;
        border: 1px solid #ccc;
        border-radius: 20px;
        overflow: hidden;
        cursor: pointer;
                min-width: 230px;
    }

    .option {
        flex: 1;
        padding: 0.5rem;
        text-align: center;
        background-color: #e0e0e0;
        color: #333;
        transition: background-color 0.3s;
    }

    .option.selected {
        background-color: #007bff;
        color: white;
    }
</style>
