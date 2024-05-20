<template>
  <div class="signup">
    <h1>This is a sign up page</h1>
    <div class="login-container">
      <div class="row">
        <div class="col-sm"></div>
        <div class="col-sm">
          <form @submit.prevent="register">
            <div class="form-group">
              <label for="exampleInputFirstName">Name</label>
              <input
                type="text"
                class="form-control"
                id="exampleInputFirstName"
                v-model="firstName"
                placeholder="Enter first name"
                required
              />
            </div>
            <div class="form-group">
              <label for="exampleInputLastName">Last name</label>
              <input
                type="text"
                class="form-control"
                id="exampleInputLastName"
                v-model="lastName"
                placeholder="Enter last name"
                required
              />
            </div>
            <div class="form-group">
              <label for="exampleInputEmail">E-mail address</label>
              <input
                type="email"
                class="form-control"
                id="exampleInputEmail"
                v-model="email"
                aria-describedby="emailHelp"
                placeholder="Enter e-mail address"
                required
              />
              <small id="emailHelp" class="form-text text-muted">
                Your e-mail address stays private.
              </small>
            </div>
            <div class="form-group">
              <label for="exampleInputPassword">Password</label>
              <input
                type="password"
                class="form-control"
                id="exampleInputPassword"
                v-model="password"
                placeholder="Enter Password"
                required
              />
            </div>
            <button type="submit" class="btn btn-primary">Submit</button>
          </form>
        </div>
        <div class="col-sm"></div>
      </div> <!-- zatvaranje row -->
    </div> <!-- zatvaranje login-container -->
  </div> <!-- zatvaranje signup -->
</template>
