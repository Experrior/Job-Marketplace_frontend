<script>
    export let message = "Your registration was successful!";
    export let additionalInfo = "Please check your email to verify your account.";
    let supportEmail = "asknow@jobsearch.com"; // Update with the actual support email
</script>

<div class="success-container">
    <div class="icon-container">
        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="48" height="48" fill="#28a745">
            <path d="M9 16.2L4.8 12l-1.4 1.4L9 19 21 7l-1.4-1.4z"></path>
        </svg>
    </div>
    <h2>{message}</h2>
    <p>{additionalInfo}</p>
    <div class="next-steps">
        <h3>What’s Next?</h3>
        <ul>
            <li>Check your email inbox for a verification message.</li>
            <li>If you don’t see the email, check your spam folder.</li>
            <li>Need assistance? Contact us at <a href="mailto:{supportEmail}">{supportEmail}</a>.</li>
        </ul>
    </div>
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

    .icon-container {
        margin-bottom: 1rem;
    }

    h2 {
        color: #155724;
        font-size: 1.5rem;
        margin-bottom: 0.5rem;
    }

    p {
        font-size: 1rem;
        color: #555;
        margin-bottom: 1.5rem;
    }

    .next-steps {
        text-align: left;
        width: 100%;
    }

    .next-steps h3 {
        font-size: 1.2rem;
        color: #155724;
        margin-bottom: 0.5rem;
    }

    .next-steps ul {
        list-style-type: none;
        padding: 0;
        margin: 0;
    }

    .next-steps li {
        font-size: 0.9rem;
        margin-bottom: 0.5rem;
        color: #333;
    }

    .next-steps li::before {
        content: "✔";
        color: #28a745;
        margin-right: 0.5rem;
    }

    a {
        color: #007bff;
        text-decoration: none;
    }

    a:hover {
        text-decoration: underline;
    }
</style>
