<template>
  <div class="row">
    <div class="col-1"></div>
    <div class="col-9">
     <sunset-moments-card v-for="card in cards"  :key="card" :info="card"/>
     <sunset-moments-card/>
    </div>
    <div class="col-2">... ovo je 3. stupac!</div>
  </div>
</template>

<script>
// @ is an alias to /src
import SunsetMomentsCard from "@/components/SunsetMomentsCard.vue";

let cards = []

cards = [
  "@/assets/images/sunset1.jpg",
  "@/assets/images/sunset2.jpg",
  "@/assets/images/sunset3.jpg",
  "@/assets/images/sunset4.jpg"
];


export default {
  name: "Home",
  data: function(){
    return{
          cards:cards,
    };
  },

  components: {
    SunsetMomentsCard: SunsetMomentsCard
  },
};
</script>
