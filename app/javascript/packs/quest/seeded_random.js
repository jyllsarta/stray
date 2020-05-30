module.exports = class SeededRandom {
    static INT_MAX = 2147483647;

    constructor(seed) {
        this.x = 123456789;
        this.y = 362436069;
        this.z = 521288629;
        this.w = seed;

        //初期値依存性を捨てるために10000回まわす
        for(let i = 0; i < 10000; ++i){
            this.rand()
        }
    }

    rand() {
        let t = this.x ^ (this.x << 11);
        this.x = this.y;
        this.y = this.z;
        this.z = this.w;
        return this.w = (this.w^(this.w>>>19))^(t^(t>>>8));
    }

    //setSeedでシード値を指定した乱数を[min,max]で整えて返す
    randInt(min, max){
        let rand = Math.abs(this.rand());
        let result = rand / (SeededRandom.INT_MAX / (max + 1)) + min;
        return Math.floor(result);
    }
};
