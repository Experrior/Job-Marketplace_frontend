<script>
  import { onMount, onDestroy } from 'svelte';

  const images = [
    '/images/front1.png',
    '/images/front2.png',
    '/images/front3.png'
  ];

  let currentImageIndex = 0;
  let interval;

  onMount(() => {
    interval = setInterval(() => {
      currentImageIndex = (currentImageIndex + 1) % images.length;
    }, 10000);

    return () => clearInterval(interval);
  });

  onDestroy(() => {
    clearInterval(interval);
  });
</script>

<style>
  .image-container {
    width: 100%;
    height: 100%;
    display: flex;
  }

  img {
    width: 100%;
    height: 100%;
    object-fit: cover; /* Ensures the image covers the container */
    display: block;    /* Removes any inline spacing */
  }
</style>

<div class="image-container">
  <img src={images[currentImageIndex]} alt="Rotating Image" />
</div>
