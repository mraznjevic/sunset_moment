<template>
  <div id="app">
    <nav id="nav" class="navbar navbar-expand-lg navbar-light bg-light">
      <!-- Image and text -->
      <a class="navbar-brand" href="#">
        <img
          src="@/assets/images/Sunset-Bar-Logo-300x212.png"
          width="auto"
          height="40"
          class="d-inline-block align-top"
          alt="Sunset Moments Logo"
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
      <div class="collapse navbar-collapse" id="navbarNavDropdown">
        <!-- Navigation links -->
        <ul class="navbar-nav mr-auto mt-2 mt-lg-0">
          <li v-if="!store.currentUser" class="nav-item">
            <router-link to="/FirstPage" class="nav-link">FirstPage</router-link>
          </li>
          <li v-if="!store.currentUser && !isFirstPage && !isLoginPage" class="nav-item">
            <router-link to="/signup" class="nav-link">Sign up</router-link>
          </li>
          <li v-if="!store.currentUser && !isFirstPage && !isSignupPage" class="nav-item">
            <router-link to="/login" class="nav-link">Prijava</router-link>
          </li>
          <li v-if="store.currentUser" class="nav-item">
            <router-link to="/" class="nav-link">Home</router-link>
          </li>
          <li v-if="store.currentUser" class="nav-item">
            <router-link to="/profile" class="nav-link">Profile</router-link> <!-- Dodana navigacijska veza za profil -->
          </li>
          <li v-if="store.currentUser" class="nav-item">
            <a href="#" @click="logout()" class="nav-link">Logout</a>
          </li>
        </ul>
      </div>
    </nav>
    <div class="container">
      <router-view />
    </div>
  </div>
</template>

<script>
import store from '@/store';
import { firebase } from '@/firebase';
import router from '@/router';

firebase.auth().onAuthStateChanged((user) => {
  const currentRoute = router.currentRoute;
  if (user) {
    // User is signed in.
    console.log('*** User', user.email);
    store.currentUser = user.email;
    // take me home
    if (!currentRoute.meta.needsAuth) {
      router.push({ name: 'home' });
    }
  } else {
    // User is not signed in.
    console.log('*** No user');
    store.currentUser = null;
    // kick me out
    if (currentRoute.meta.needsAuth) {
      router.push({ name: 'login' });
    }
  }
});
export default {
  name: 'app',
  data() {
    return {
      store: store,
    };
  },
  computed: {
    isLoginPage() {
      return this.$route.path === '/login';
    },
    isFirstPage() {
      return this.$route.path === '/FirstPage';
    },
    isSignupPage() {
      return this.$route.path === '/signup';
    }
  },
  methods: {
    logout() {
      firebase
        .auth()
        .signOut()
        .then(() => {
          this.$router.push({ name: 'login' });
        });
    },
  },
};
</script>

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
