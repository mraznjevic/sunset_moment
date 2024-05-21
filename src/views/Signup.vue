<template>
  <div class="login-container">
    <div class="about">
        <h1>This is a signup page</h1>

        <div class="row">
            <div class="col"></div>
            <div class="col">
                <form @submit.prevent="signup">
                    <div class="form-group">
                        <label for="exampleInputEmail1">Email address</label>
                        <input
                            type="email"
                            v-model="email"
                            class="form-control"
                            id="exampleInputEmail1"
                            aria-describedby="emailHelp"
                            placeholder="Enter email"
                            required
                        />
                        <small id="emailHelp" class="form-text text-muted">
                            We'll never share your email with anyone else.
                        </small>
                    </div>
                    <div class="form-group">
                        <label for="exampleInputFirstName">First Name</label>
                        <input
                            type="text"
                            v-model="firstName"
                            class="form-control"
                            id="exampleInputFirstName"
                            placeholder="Enter first name"
                            required
                        />
                    </div>
                    <div class="form-group">
                        <label for="exampleInputLastName">Last Name</label>
                        <input
                            type="text"
                            v-model="lastName"
                            class="form-control"
                            id="exampleInputLastName"
                            placeholder="Enter last name"
                            required
                        />
                    </div>
                    <div class="form-group">
                        <label for="exampleInputPassword1">Password</label>
                        <input
                            type="password"
                            v-model="password"
                            class="form-control"
                            id="exampleInputPassword1"
                            placeholder="Password"
                            required
                        />
                    </div>
                    <div class="form-group">
                        <label for="exampleInputPassword2">Repeat Password</label>
                        <input
                            type="password"
                            v-model="passwordRepeat"
                            class="form-control"
                            id="exampleInputPassword2"
                            placeholder="Password"
                            required
                        />
                    </div>
                    <button type="submit" class="btn btn-primary">Submit</button>
                </form>
            </div>
            <div class="col"></div>
        </div>
    </div>
 </div>
</template>

<script>
import { firebase } from '@/firebase';
export default {
    name: 'Signup',
    data() {
        return {
            email: '',
            firstName: '',
            lastName: '',
            password: '',
            passwordRepeat: ''
        };
    },
    methods: {
        signup() {
            if (this.password !== this.passwordRepeat) {
                console.error('Passwords do not match');
                return;
            }
            firebase
                .auth()
                .createUserWithEmailAndPassword(this.email, this.password)
                .then(() => {
                    console.log('Successful registration');
                })
                .catch(error => {
                    console.error('Error during registration:', error);
                });
        }
    }
};
</script>