<template>
  <div id="app">
    <nav id="nav" class="navbar navbar-expand-lg navbar-light">
      <!-- Image and text -->
      <a class="navbar-brand" href="#">
        <img
          src="@/assets/images/Sunset-Bar-Logo-300x212.png"
          width="auto"
          height="40"
          class="d-inline-block align-top"
          alt=""
          loading="lazy"
        />
        Sunset Moments
      </a>
      <button
        class="navbar-toggler"
        type="button"
        data-toggle="collapse"
        data-target="#navbarNavDropdown"
        aria-controls="navbarNavDropdown"
        aria-expanded="false"
        aria-label="Toggle navigation"
      >
        <span class="navbar-toggler-icon"></span>
      </button>
      <div class="collapse navbar-collapse" id="navbarToggler">
        <!--Image and text-->
        <ul class="navbar-nav mr-auto mt-2 mt-lg-0">
          <li class="nav-item">
            <router-link to="/FirstPage">FirstPage </router-link> |
            <router-link to="/">Home</router-link> |
            <router-link to="/login">Prijava</router-link> |
          </li>
        </ul>
         <input v-model="pojam" /> <button @click="pretrazi()">Pretraga</button>
      </div>
    </nav>
    <div class="container">
    <router-view />
  </div>
  </div>
</template>

<style lang="scss">
#app {
  font-family: Avenir, Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  color: #2c3e50;
}

#nav {
  padding: 30px;
  

  a {
    font-weight: bold;
    color: #2c3e50;

    &.router-link-exact-active {
      color: #42b983;
    }
  }
}
</style>
