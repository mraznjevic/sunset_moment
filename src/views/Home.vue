<template>
  <div class="row">
    <div class="col-1"></div>
    <div class="col-9">
      <div class="card text-center">
        <div class="card-header">Featured</div>
        <div class="card-body p-0">
          <img class="card-img-top" src='@/assets/images/sunset1.jpg'/>
        </div>
        <div class="card-footer text-muted">2 days ago</div> 
      </div>
    </div>
    <div class="col-2">... ovo je 3. stupac!</div>
  </div>
</template>

<script>
// @ is an alias to /src
import HelloWorld from "@/components/HelloWorld.vue";

export default {
  name: "Home",
  components: {
    HelloWorld,
  },
};
</script>
