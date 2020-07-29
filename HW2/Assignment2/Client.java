/**
 * Jerry Cheng, Andrew Chuah
 * Homework Assignment 2 
 * CS 511
 * I pledge my honor that I have abided by the Stevens Honor System.
 */

package Assignment2;
import java.util.*;

public class Client {
    private int id;
    private List<Exercise> routine;

    /**
     * Constructor for Client
     * @param id
     */
    public Client(int id){
        this.id = id;
        this.routine = new ArrayList<Exercise>();
    }

    /**
     * Adds exercise into routine list
     * @param e Exercise to add to list
     */
    public void addExercise(Exercise e){
        routine.add(e);
    }
    
    /**
     * Gets client's ID
     * @return ID
     */
    public int getid(){
        return id;
    }

    /**
     * Get's client routine
     * @return routine (list of exercises)
     */
    public List<Exercise> getRoutine(){
        return routine;
    }

    /**
     * Generate client with random exercise routine of 15-20 exercises
     * @param id id of client
     * @return client with routine
     */
    public static Client generateRandom(int id){
        Client client = new Client(id);
        Random rand = new Random();

        int routine = 15 + rand.nextInt(6);
        for(int i = 0; i < routine; i++){
            client.addExercise(Exercise.generateRandom());
        }
        
        return client;
    }
}