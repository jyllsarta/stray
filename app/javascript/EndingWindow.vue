<template lang="pug">
  .menu
    .full_covered_window(@click="proceed")
      transition(name="show-in")
        img.background(:key="chapter" :src="`/images/ending/${index}.png`" v-if="index === chapter" v-for="index in [0, 1, 2]")
      .scripts(:class="`chapter_${chapter}`")
        .line(
          v-for="script, index in scripts[chapter]"
          :key="`${chapter}-${index}`"
          :class="`talker_${script[0]}`"
          :style="{animationDelay: (500 + 700 * index + (chapter===0) * 1500)+'ms'}"
        )
          | {{ script[1] }}
      transition(name="show-in")
        .cover(v-if="showCover")
</template>

<script lang="ts">
import Constants from "./packs/constants.ts";
import store from './packs/store.ts'
import axios from 'axios'
import ax from "./packs/axios_default_setting.ts";

export default {
  data: function () {
    return {
      chapter: 0,
      showCover: true,
      blockClick: false,
      scripts: [
        [
          [3, "「それで、果ての妖精までコテンパンにして何しに来たの？」"],
          [1, "「最初は砂浜ピクニックのつもりだったんだけどね」"],
          [2, "「いつの間にかね」"],
          [3, "「は？ピクニック感覚で妖精みんなとやりあって勝ってたの？」"],
          [1, "「何回かは負けたよ」"],
          [2, "「根気よくいったね」"],
          [3, "「やばいのが来たなぁ」"],
        ],
        [
          [3, "「ここが果てであんたらの目標は達成したわけだけど、これからはどうするの？」"],
          [1, "「もっかい一回りしてみようかな」"],
          [2, "「わかる」"],
          [1, "「ここ来ればどこでも行き直せるしね」"],
          [2, "「便利」"],
          [3, "「どこからでもここに来れちゃうのはあんたらだけだよ」"],
        ],
        [
          [1, "「またみんなに会いたいな、シーフラとかミネラルは特にしばらく会ってないし」"],
          [2, "「鍛え直してるかもね」"],
          [1, "「お互い高め会ってこうじゃん」"],
          [2, "「スピカそういう素直に前向きなとこあるよね」"],
          [1, "「私がこうするの見てチロルも頑張ろって思ってくれてるみたいだしさ」"],
          [2, "「あーそういうね」"],
          [1, "　"],
          [1, "　"],
          [1, "　"],
          [4, "オールクリアおめでとう！"],
          [4, "おまけダンジョン「再開の巡礼旅」が解放されたよ！"],
        ],
      ]
    };
  },
  props: {
  },
  components: {
  },
  store,
  mounted(){
    setTimeout(this.hideCover, 1200);
    this.lockAndInvokeUnlockClick();
  },
  computed: {
  },
  methods: {
    hideCover(){
      this.showCover = false;
    },
    currentScript(){
      return this.scripts[this.chapter];
    },
    proceed(){
      if(this.blockClick){
        return;
      }
      this.chapter++;
      if(this.chapter >= this.scripts.length){
        this.closeWindow();
      }
      this.lockAndInvokeUnlockClick();
    },
    closeWindow(){
      this.$store.commit('window/updateWindowShowState', {windowName: "ending", state: false});
    },
    lockAndInvokeUnlockClick(){
      this.blockClick = true;
      setTimeout(this.unlockClick, 2000);
    },
    unlockClick(){
      this.blockClick = false;
    }
  }
}
</script>

<style lang="scss" scoped>
@import "stylesheets/global_setting";

.full_covered_window{
  position: absolute;
  width: $window-width;
  height: $window-height;
  background-color: white;
  opacity: 1;
  .background{
    position: absolute;
    width: 100%;
  }
  .cover{
    position: absolute;
    background-color: white;
    width: 100%;
    height: 100%;
  }
  .scripts{
    position: absolute;
    .line{
      font-size: 18px;
      animation: vertical-text-in .4s cubic-bezier(0.22, 0.15, 0.25, 1.43) 0s backwards;
      line-height: 170%;
    }
    .talker_1{
      $col: #b3467c;
      color: $col;
      text-shadow: $col 0 0 3px;
    }
    .talker_2{
      $col: #a07b2c;
      color: $col;
      text-shadow: $col 0 0 3px;
    }
    .talker_3{
      $col: #542b7a;
      color: $col;
      text-shadow: $col 0 0 3px;
    }
    .talker_4{
      $col: #397699;
      color: $col;
      text-shadow: $col 0 0 3px;
    }
  }
  .chapter_0{
    top: 40px;
    left: 40px;
  }
  .chapter_1{
    top: 40px;
    left: 40px;
  }
  .chapter_2{
    top: 60px;
    left: 10%;
    text-align: center;
    width: 80%;
  }
}


.show-in-enter-active {
  transition: all 0.7s;
}
.show-in-leave-active {
  transition: all 0.7s;
}
.show-in-enter{
  opacity: 0;
}
.show-in-leave-to{
  opacity: 0;
}

@keyframes vertical-text-in {
  0% {
    transform: translate(0, -4px);
    opacity: 0;
  }
}

</style>
