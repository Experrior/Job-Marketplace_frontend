<script>
    export let message = "Your registration was successful!";
    export let additionalInfo = "Please check your email to verify your account.";
</script>

<div class="success-container">
    <h2>{message}</h2>
    <p>{additionalInfo}</p>
    <button on:click={() => window.location.reload()}>
        Go to Login
    </button>
</div>

<style>
    .success-container {
        display: flex;
        flex-direction: column;
        align-items: center;
        justify-content: center;
        padding: 2rem;
        text-align: center;
        background-color: #f9f9f9;
        border: 1px solid #ccc;
        border-radius: 8px;
        margin: 2rem auto;
        max-width: 400px;
    }

    h2 {
        color: #155724;
    }

    p {
        margin-top: 1rem;
        font-size: 1rem;
        color: #555;
    }

    button {
        margin-top: 1.5rem;
        padding: 0.5rem 1rem;
        border: none;
        border-radius: 4px;
        background-color: #007bff;
        color: white;
        cursor: pointer;
    }
</style>
