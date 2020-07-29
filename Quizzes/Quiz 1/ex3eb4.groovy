// Andrew Chuah
// Jerry Cheng

// I pledge my honor that I have abided by the Stevens Honor System.

int turn = 0;

Thread.start {
    mutex.acquire();
    if(turn == 0){
        print("R");
        turn++;
    }
    mutex.release();
    print("OK");
}

Thread.start {
    mutex.acquire();
    if(turn == 1){
        print("I");
        turn++;
    }
    mutex.release();
    print("OK");
}

Thread.start {
    mutex.acquire();
    if(turn == 2){
        print("O");
        turn++;
    }
    mutex.release();
    print("OK");
}