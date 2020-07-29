import java.util.concurrent.Semaphore;

// Stations are modelled as semaphores

Semaphore station0 = new Semaphore(1);
Semaphore station1 = new Semaphore(1);
Semaphore station2 = new Semaphore(1);

permToprocess = [new Semaphore(0), new Semaphore(0), new Semaphore(0)]
100.times{
    Thread.start{ car
    
    // go to station 0
    station0.acquire();
    permToProcess0.release();
    permToProcess0.acquire();

    // move on to station 1
    station0.release();
    station1.acquire();
    permToProcess1.release();
    permToProcess1.acquire();
    // move on to station 2
    station2.acquire();
    station1.release();
    permToProcess2.release();
    permToProcess2.acquire();
    station2.release;
    }
}

3 times{
    Thread.machine(i){ //machine at station i
        while(true){
        permToProcess[it].acquire();
        //process car when it becomes available
        permToProcess[it].release();
        }
    }
}