import java.util.concurrent.Semaphore;

Semaphore ticket = new Semaphore(0);
Semaphore mutex = new Semaphore(1);
int w, m = 0;

def ifGotLate(){
    while(true){
        ticket.release();
    }
}

20.times{
    Thread.start{ // Woman
        ticket.release();
        w++;
    }
}

20.times{
    Thread.start{ // Men
        mutex.acquire();
        ticket.acquire();
        ticket.acquire();
        m++;
        mutex.release();
    }
}