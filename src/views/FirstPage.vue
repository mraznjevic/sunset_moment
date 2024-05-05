<template>
  <div class="login-container">
    <h1 class="login-title">Welcome to Sunset Moments</h1>
    <div class="container">
      <div class="row">
        <div class="col-sm"></div>
        <div class="col-sm">
          <form>
             <button type="submit" class="btn btn-primary btn-lg" style="width: 100%;">Prijava</button>
            <button type="submit" class="btn btn-primary btn-lg" style="width: 100%;">Registracija</button>
          </form>
        </div>
        <div class="col-sm"></div>
      </div>
    </div>
  </div>
</template>

<script>
import Login from '@/views/Login.vue'


export default {
  name: 'FirstPage',
  components: {
    
   
  }
}
</script>

<style>
/* Stilizacija dijelova za prijavu i registraciju */
</style>
