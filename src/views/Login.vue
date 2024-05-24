<template>
  <div class="login-container">
    <h1 class="login-title">This is a login page</h1>
    <div class="container">
      <div class="row">
        <div class="col-sm"></div>
        <div class="col-sm">
          <form>
            <div class="form-group">
              <label for="exampleInputEmail1">Email address</label>
              <input type="email" 
  v-model="username"
 class="form-control" id="exampleInputEmail1" aria-describedby="emailHelp" placeholder="Enter email" />
              <small id="emailHelp" class="form-text text-muted">We'll never share your email with anyone else.</small>
            </div>
            <div class="form-group">
              <label for="exampleInputPassword1">Password</label>
              <input type="password" v-model="password" class="form-control" id="exampleInputPassword1" placeholder="Password" />
            </div>
            <button type="button" @click= "login()" class="btn btn-primary">Submit</button>
          </form>
        </div>
        <div class="col-sm"></div>
      </div>
    </div>
  </div>
</template>

<script>
import { firebase } from '@/firebase';

export default {
    name: 'login',
    data() {
        return {
            username: '',
            password: '',
        };
    },
    methods: {
        login() {
            console.log('login...'+ this.username);


            firebase
                .auth()
                .signInWithEmailAndPassword(this.username, this.password)
                .then((result) => {
                    console.log('Uspješna prijava', result);
                    
                })
                .catch(function(e) {
                    console.error('Greška', e);
                });
        },
    },
};

</script>

<style>
.login-container {
  width: 700px;
  margin: auto;
  padding: 40px;
  border-radius: 5px;
  box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
  background-image: url('../assets/images/sunsetbackground1.jpg');
  background-size: cover;
  background-position: center;
}

.login-title {
  text-align: center;
  margin-bottom: 20px;
}

.form-group {
  margin-bottom: 20px;
}

.btn-primary {
  background-color: #ffbf00;
  border-color: #00ff1a;
}

.btn-primary:hover {
  background-color: #39b300;
  border-color: #1eb300;
}
</style>
