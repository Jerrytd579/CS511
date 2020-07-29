/**
 * Jerry Cheng, Andrew Chuah
 * Homework Assignment 2 
 * CS 511
 * I pledge my honor that I have abided by the Stevens Honor System.
 */

package Assignment2;
import java.util.*;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.Semaphore;

public class Gym implements Runnable {
    private static final int GYM_SIZE = 30;
    private static final int GYM_REGISTERED_CLIENTS = 10000;
    private Map<WeightPlateSize,Semaphore> noOfWeightPlates;
    private Set<Integer> clients; // for generating fresh client ids
    private ExecutorService executor;
    private Random rand = new Random();

    //private static Semaphore mutex = new Semaphore(1);
    private static Semaphore w_mutex = new Semaphore(1); // weights mutex
    private static Map<ApparatusType,Semaphore> app_semaphores;

    /**
     * Constructor for creating a Gym environment, and
     * groups semaphores into apparati.
     * 5 of each apparatus in the gym
     */
    public Gym(){
        clients = new HashSet<Integer>(GYM_REGISTERED_CLIENTS);
        noOfWeightPlates = new HashMap<WeightPlateSize,Semaphore>();
        app_semaphores = new HashMap<ApparatusType,Semaphore>();

        noOfWeightPlates.put(WeightPlateSize.values()[0], new Semaphore(110));
        noOfWeightPlates.put(WeightPlateSize.values()[1], new Semaphore(90));
        noOfWeightPlates.put(WeightPlateSize.values()[2], new Semaphore(75));

        // Assigning each apparatus with a semaphore
        for(int i = 0; i < ApparatusType.values().length; i++){
            app_semaphores.put(ApparatusType.values()[i], new Semaphore(5));
        }
    }

    /**
     * Executes the client's routine
     */
    public void run(){
        executor = Executors.newFixedThreadPool(GYM_SIZE);
        for(int i = 0; i < GYM_REGISTERED_CLIENTS; i++){
            int cnum = 0;
            do{
                cnum = rand.nextInt(GYM_REGISTERED_CLIENTS) + 1;
            } while(clients.contains(cnum));
            Client client = Client.generateRandom(cnum);
            executor.execute(new Runnable() {
                public void run(){
                    System.out.println("Client " + client.getid() + " has entered the gym.");
                    for(Exercise exercise : client.getRoutine()){
                        try{
                            // Starting to work out
                            app_semaphores.get(exercise.getApparatus()).acquire();
                            // Critical Section
                            w_mutex.acquire();
                            for(int i = 0; i < exercise.getWeight().get(WeightPlateSize.values()[0]); i++){
                                noOfWeightPlates.get(WeightPlateSize.values()[0]).acquire();
                            }
                            for(int i = 0; i < exercise.getWeight().get(WeightPlateSize.values()[1]); i++){
                                noOfWeightPlates.get(WeightPlateSize.values()[1]).acquire();
                            }
                            for(int i = 0; i < exercise.getWeight().get(WeightPlateSize.values()[2]); i++){
                                noOfWeightPlates.get(WeightPlateSize.values()[2]).acquire();
                            }
                            w_mutex.release();
                            System.out.println("Client " + client.getid() + " is working out on the " + exercise.getApparatus() + 
                                                " with " + exercise.getWeight().get(WeightPlateSize.values()[0]) + " small weights, " +
                                                exercise.getWeight().get(WeightPlateSize.values()[1]) + " medium weights, and " +
                                                exercise.getWeight().get(WeightPlateSize.values()[2]) + " large weights for " +
                                                exercise.getDuration() + " ms.");
                            Thread.sleep(exercise.getDuration());

                            // Getting off the machine
                            app_semaphores.get(exercise.getApparatus()).release();
                            for(int i = 0; i < exercise.getWeight().get(WeightPlateSize.values()[0]); i++){
                                noOfWeightPlates.get(WeightPlateSize.values()[0]).release();
                            }
                            for(int i = 0; i < exercise.getWeight().get(WeightPlateSize.values()[1]); i++){
                                noOfWeightPlates.get(WeightPlateSize.values()[1]).release();
                            }
                            for(int i = 0; i < exercise.getWeight().get(WeightPlateSize.values()[2]); i++){
                                noOfWeightPlates.get(WeightPlateSize.values()[2]).release();
                            }

                            System.out.println("Client " + client.getid() + " is done with the current exercise.");
                        }
                        catch(InterruptedException e){
                            System.out.println("Client " + client.getid() + " failed to equip plates.");
                        }
                    }
                    System.out.println("Client " + client.getid() + " has left the gym.");
                }
            });
        }
        executor.shutdown();
    }
}