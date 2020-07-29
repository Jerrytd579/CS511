/**
 * Jerry Cheng, Andrew Chuah
 * Homework Assignment 2 
 * CS 511
 * I pledge my honor that I have abided by the Stevens Honor System.
 */

package Assignment2;
public class Assignment2 {
    public static void main(String[] args){
        Thread thread = new Thread(new Gym());
        thread.start();
        try{
            thread.join();
        } catch(InterruptedException e){
            // Auto-generated catch block
            e.printStackTrace();
        }
    }
}