/**
 * Jerry Cheng, Andrew Chuah
 * Homework Assignment 2 
 * CS 511
 * I pledge my honor that I have abided by the Stevens Honor System.
 */

package Assignment2;
import java.util.*;

public class Exercise {
    private ApparatusType at;
    private Map<WeightPlateSize,Integer> weight;
    private int duration;

    /**
     * Constructor for Exercise
     * @param at
     * @param weight
     * @param duration
     */
    public Exercise(ApparatusType at, Map<WeightPlateSize,Integer> weight, int duration){
        this.at = at;
        this.weight = weight;
        this.duration = duration;
    }

    /**
     * Gets apparatus
     * @return apparatus
     */
    public ApparatusType getApparatus(){
        return at;
    }

    /**
     * Gets weight
     * @return weight
     */
    public Map<WeightPlateSize,Integer> getWeight(){
        return weight;
    }

    /**
     * Gets exercise duration
     * @return duration
     */
    public int getDuration(){
        return duration;
    }

    /**
     * Creates random exercise
     * @return new exercise
     */
    public static Exercise generateRandom(){
        Random rand = new Random();
        ApparatusType at = ApparatusType.values()[rand.nextInt(ApparatusType.values().length)];
        int duration = rand.nextInt(20) + 1;
        Map<WeightPlateSize,Integer> wmap = new HashMap<WeightPlateSize,Integer>();

        // Generates number of plates to be used for each weight
        int small = rand.nextInt(11);
        int med = rand.nextInt(11);
        int large = rand.nextInt(11);

        // Checks if we picked up no plates at all
        while(small + med + large == 0){
            small = rand.nextInt(11);
            med = rand.nextInt(11);
            large = rand.nextInt(11);
        }
        
        wmap.put(WeightPlateSize.values()[0], small);
        wmap.put(WeightPlateSize.values()[1], med);
        wmap.put(WeightPlateSize.values()[2], large);

        Exercise exercise = new Exercise(at, wmap, duration);
        return exercise;
    }
}