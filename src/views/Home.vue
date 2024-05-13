<template>
  <div class="row">
    <div class="col-1"></div>
    <div class="col-9">
     <sunset-moments-card/>
    </div>
    <div class="col-2">... ovo je 3. stupac!</div>
  </div>
</template>

<script>
// @ is an alias to /src
import SunsetMomentsCard from "@/components/SunsetMomentsCard.vue";


export default {
  name: "Home",
  components: {
    SunsetMomentsCard: SunsetMomentsCard
  },
};
</script>
