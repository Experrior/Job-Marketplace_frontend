<script>
import {user, verifyUser} from '$lib/stores/user'; 
console.log(verifyUser())
$: console.log($user.jwt);
</script>
