import axios from 'axios';
import user from '$lib/../stores/user.js';
import { get } from 'svelte/store';

axios.defaults.baseURL = 'http://localhost:8080';

axios.defaults.headers.common['Content-Type'] = 'application/json';



//TODO FIX THIS
// const userCopy = get(user)

// if (userCopy) {
//     axios.defaults.headers.common['Authorization'] = `Bearer ${userCopy.jwt}`;
// }

export default axios;
