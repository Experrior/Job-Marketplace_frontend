<script>
  import { auth } from '../stores/auth';
    import { onDestroy } from 'svelte';
    import { format } from 'date-fns';
  
    let user;
    const userDataList = [{
  firstName: 'John',
  lastName: 'Doe',
  email: 'john.doe@example.com',
  photoUrl: '/images/front1.png', 
  accountCreatedAt: '2023-01-01T10:00:00Z',
  lastLoginAt: '2023-05-15T14:30:00Z',
  cvUpdatedAt: '2023-05-10T09:15:00Z', 
    },
    {
  firstName: 'John',
  lastName: 'Doe',
  email: 'john.doe@example.com',
  photoUrl: '/images/front1.png', 
  accountCreatedAt: '2023-01-01T10:00:00Z',
  lastLoginAt: '2023-05-15T14:30:00Z',
  cvUpdatedAt: '2023-05-10T09:15:00Z', 
    },];

    function formatDate(dateString) {
      return format(new Date(dateString), 'PPPpp');
    }




</script>
{#each userDataList as user}
{#key user.id}
{console.log('Rendering user:', user)}
<div class="personal-data-widget">

    {#if user.photoUrl}
      <img src="{user.photoUrl}" alt="{user.firstName} {user.lastName}" class="user-photo" />
    {:else}
      <div class="user-photo placeholder">
        <span>{user.firstName.charAt(0)}{user.lastName.charAt(0)}</span>
      </div>
    {/if}

    <div class="user-details">
      <h2>{user.firstName} {user.lastName}</h2>
      <p><strong>Email:</strong> {user.email}</p>
      <p><strong>Account Created:</strong> {formatDate(user.accountCreatedAt)}</p>
      <p><strong>Last Login:</strong> {formatDate(user.lastLoginAt)}</p>
      
      {#if user.cvUpdatedAt}
        <p><strong>CV Updated:</strong> {formatDate(user.cvUpdatedAt)}</p>
      {:else}
        <p><strong>CV Updated:</strong> Not updated yet</p>
      {/if}
    </div>
  </div>
  {/key}
{/each}

<style>

.user-photo {
      width: 120px;
      height: 120px;
      border-radius: 50%;
      object-fit: cover;
      margin-right: 1.5rem;
      background-color: #ddd;
      display: flex;
      align-items: center;
      justify-content: center;
    }
    .user-details {
      flex: 1;
    }
  
    .user-details h2 {
      font-size: 1.75rem;
      margin: 0 0 0.5rem 0;
    }
  
    .user-details p {
      font-size: 1rem;
      margin: 0.25rem 0;
      color: #555;
    }
  
</style>