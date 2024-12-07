<script>
    import { onMount, onDestroy } from "svelte";

    export let message = "";
    export let duration = 3000; // Default: 5 seconds
    export let onCancel;
    export let onExpire; // New prop for handling expiration

    let progress = 100; // Progress percentage
    let interval;

    function startCountdown() {
        const step = (100 / duration) * 50; // Decrease progress every 50ms
        interval = setInterval(() => {
            progress -= step;
            if (progress <= 0) {
                clearInterval(interval);
                if (onExpire) {
                    onExpire(); // Trigger confirmRemove after expiration
                }
            }
        }, 50);
    }
    function cancelToast() {
        clearInterval(interval); // Stop the timer
        if (onCancel) {
            onCancel(); // Trigger cancel action
        }
    }

    onMount(() => {
        startCountdown();
    });

    onDestroy(() => {
        clearInterval(interval); // Cleanup
    });
</script>

<div class="toast">
    <div class="content">
        <div class="message">{message}</div>
        <button class="cancel-button" on:click={cancelToast}>Cancel</button>
    </div>
    <div class="progress-bar">
        <div class="progress" style="width: {progress}%;"></div>
    </div>
</div>

<style>
    .toast {
        position: fixed;
        bottom: 1rem;
        right: 1rem;
        background: #fff;
        box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
        border-radius: 0.5rem;
        padding: 1rem;
        display: flex;
        flex-direction: column;
        gap: 0.5rem;
        width: 300px;
    }

    .content {
        display: flex;
        justify-content: space-between;
        align-items: center;
    }

    .message {
        font-size: 1rem;
        color: #333;
        flex-grow: 1;
    }

    .cancel-button {
        background: #ff5252;
        color: #fff;
        border: none;
        border-radius: 0.25rem;
        padding: 0.5rem 1rem;
        cursor: pointer;
        margin-left: 1rem;
    }

    .cancel-button:hover {
        background: #ff0000;
    }

    .progress-bar {
        position: relative;
        background: #e0e0e0;
        height: 5px;
        border-radius: 0.25rem;
        overflow: hidden;
    }

    .progress {
        background: #4caf50;
        height: 100%;
        transition: width 50ms linear;
    }
</style>
