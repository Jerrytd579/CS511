import java.util.concurrent.Semaphore;

static final N = 10;
Semaphore permToUseToilet = new Semaphore(N);

Thread.start{ //Man

    // Entry protocol

    permToUseToilet.acquire();
    // use restroom
    permToUseToilet.release();

    // exit protocol

}

Thread.start{ //Woman

    // Entry protocol

    // use restroom

    //exit protocol

}