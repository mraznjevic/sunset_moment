<template>
 <div class="row">
 <div class="col-1"></div>
 <div class="col-9">
 ... ovo je 2. stupac!
 </div>
 <div class="col-2">
 ... ovo je 3. stupac!
 </div>
 </div>
</template>

<script>
// @ is an alias to /src
import HelloWorld from '@/components/HelloWorld.vue'

export default {
  name: 'Home',
  components: {
    HelloWorld
  }
}
</script>
