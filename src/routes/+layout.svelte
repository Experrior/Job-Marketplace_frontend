<!-- <script>
    import { onMount } from 'svelte';
    import { resetUser } from '../stores/user';
    import { goto } from '$app/navigation';

    onMount(() => {
        const token = localStorage.getItem('jwt');

        if (!token){
            localStorage.removeItem('jwt');
                localStorage.removeItem('jwt_expiration');
                resetUser();
                goto('/login');
        }
        const expiration = localStorage.getItem('jwt_expiration');
        if (expiration) {
            const now = Date.now();
            if (now > parseInt(expiration, 10)) {
                localStorage.removeItem('jwt');
                localStorage.removeItem('jwt_expiration');
                resetUser();
                goto('/login');
            }
        }
    });
</script> -->
<script>
    import '../styles/global.css';
</script>
<slot />
