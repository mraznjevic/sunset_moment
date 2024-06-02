import Vue from 'vue'
import VueRouter from 'vue-router'
import Home from '../views/Home.vue'
import FirstPage from '../views/FirstPage.vue'
import Login from '../views/Login.vue'
import Signup from '../views/Signup.vue'
import store from '@/store';

Vue.use(VueRouter)

const routes = [
  {
    path: '/',
    name: 'home',
    component: Home,
    meta: {
      needsAuth: true, 
    },
  },
  {
    path: '/FirstPage',
    name: 'FirstPage',
    // route level code-splitting
    // this generates a separate chunk (about.[hash].js) for this route
    // which is lazy-loaded when the route is visited.
    component: () => import(/* webpackChunkName: "FirstPage" */ '../views/FirstPage.vue')
  },
  {
    path: '/login',
    name: 'login',
    // route level code-splitting
    // this generates a separate chunk (about.[hash].js) for this route
    // which is lazy-loaded when the route is visited.
    component: () => import(/* webpackChunkName: "Login" */ '../views/Login.vue')
  },
  {
    path: "/signup",
    name: "signup",
    // route level code-splitting
    // this generates a separate chunk (about.[hash].js) for this route
    // which is lazy-loaded when the route is visited.
    component: () =>
      import(/* webpackChunkName: "about" */ "../views/Signup.vue"),
  },
  {
    path: '/image/:id',
    name: 'ImageDetail',
    component: () => import('../views/ImageDetail.vue'),
    meta: {
      needsAuth: true,
    },
  }
  

]

const router = new VueRouter({
  mode: 'history',
  base: process.env.BASE_URL,
  routes
});

router.beforeEach((to, from, next) => {
  console.log('Stara ruta', from.name, 'idem na', to.name, 'korisnik', store.currentUser);

  const isAuthenticated = store.currentUser !== null;
  console.log('Authenticated:', isAuthenticated);

  if (to.meta.needsUser && !noUser) {
    next('login');
  } else {
    next();
  }  
   });

export default router;
